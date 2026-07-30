const pool = require('../config/db');

/**
 * Recalcula el estado de materia_usuario basado en notas actuales.
 * Reemplaza lo que haría el trigger AFTER UPDATE/DELETE en nota.
 */
async function recalcularEstadoMateria(materia_usuario_id) {
  // Obtener nota mínima y estado actual
  const [[mu]] = await pool.query(
    `SELECT mu.materia_usuario_estado, m.materia_nota_minima_aprobacion
     FROM materia_usuario mu
     JOIN materia m ON m.materia_id = mu.materia_usuario_materia_id
     WHERE mu.materia_usuario_id = ?`,
    [materia_usuario_id]
  );
  if (!mu || mu.materia_usuario_estado === 'retirada') return;

  // Calcular porcentaje evaluado y nota acumulada
  const [[calc]] = await pool.query(
    `SELECT ROUND(SUM(pc.componente_porcentaje), 2)           AS pct,
            ROUND(SUM(pc.promedio_componente * pc.componente_porcentaje / 100), 2) AS nota
     FROM v_promedio_componente pc
     WHERE pc.componente_materia_usuario_id = ?
       AND pc.promedio_componente IS NOT NULL`,
    [materia_usuario_id]
  );

  const pct  = Number(calc?.pct  ?? 0);
  const nota = Number(calc?.nota ?? 0);
  const min  = Number(mu.materia_nota_minima_aprobacion);

  let nuevoEstado;
  if (pct === 100) {
    nuevoEstado = nota >= min ? 'aprobada' : 'reprobada';
  } else {
    nuevoEstado = 'en_curso';
  }

  if (nuevoEstado !== mu.materia_usuario_estado) {
    await pool.query(
      'UPDATE materia_usuario SET materia_usuario_estado = ? WHERE materia_usuario_id = ?',
      [nuevoEstado, materia_usuario_id]
    );
  }
}

/** GET /api/componentes/:id/notas */
const list = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query(
      `SELECT nota_id, nota_nombre, nota_valor, nota_fecha_registro, nota_componente_id
       FROM nota WHERE nota_componente_id = ?
       ORDER BY nota_fecha_registro DESC`,
      [id]
    );
    res.json({ success: true, data: rows });
  } catch (error) {
    next(error);
  }
};

/** POST /api/componentes/:id/notas */
const create = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { nombre, valor, fecha_registro } = req.body;

    if (!nombre || valor === undefined)
      return res.status(400).json({ success: false, message: 'nombre y valor son requeridos' });

    if (valor < 0.0 || valor > 5.0)
      return res.status(400).json({ success: false, message: 'La nota debe estar entre 0.0 y 5.0' });

    const [[comp]] = await pool.query(
      'SELECT componente_materia_usuario_id FROM componente WHERE componente_id = ?', [id]
    );
    if (!comp) return res.status(404).json({ success: false, message: 'Componente no encontrado' });

    const materia_usuario_id = comp.componente_materia_usuario_id;

    const [result] = await pool.query(
      `INSERT INTO nota (nota_nombre, nota_valor, nota_fecha_registro, nota_componente_id)
       VALUES (?, ?, ?, ?)`,
      [nombre, valor, fecha_registro || new Date(), id]
    );

    const [[newNota]] = await pool.query('SELECT * FROM nota WHERE nota_id = ?', [result.insertId]);

    // El trigger INSERT ya actualiza el estado — re-leer
    const [[mu]] = await pool.query(
      'SELECT materia_usuario_estado FROM materia_usuario WHERE materia_usuario_id = ?',
      [materia_usuario_id]
    );

    res.status(201).json({
      success: true,
      data: { nota: newNota, materia_usuario_estado: mu?.materia_usuario_estado }
    });
  } catch (error) {
    if (error.sqlState === '45000' || error.code === 'ER_CHECK_CONSTRAINT_VIOLATED')
      return res.status(422).json({ success: false, message: error.sqlMessage || error.message });
    next(error);
  }
};

/** PUT /api/notas/:id */
const update = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { nombre, valor, fecha_registro } = req.body;

    if (valor !== undefined && (valor < 0.0 || valor > 5.0))
      return res.status(400).json({ success: false, message: 'La nota debe estar entre 0.0 y 5.0' });

    const fields = [];
    const values = [];
    if (nombre !== undefined)        { fields.push('nota_nombre = ?');          values.push(nombre); }
    if (valor !== undefined)         { fields.push('nota_valor = ?');           values.push(valor); }
    if (fecha_registro !== undefined){ fields.push('nota_fecha_registro = ?');  values.push(fecha_registro); }

    if (fields.length === 0)
      return res.status(400).json({ success: false, message: 'No hay campos para actualizar' });

    values.push(id);
    const [result] = await pool.query(
      `UPDATE nota SET ${fields.join(', ')} WHERE nota_id = ?`, values
    );

    if (result.affectedRows === 0)
      return res.status(404).json({ success: false, message: 'Nota no encontrada' });

    const [[updated]] = await pool.query('SELECT * FROM nota WHERE nota_id = ?', [id]);

    // Recalcular estado (no hay trigger para UPDATE)
    const [[comp]] = await pool.query(
      'SELECT componente_materia_usuario_id FROM componente WHERE componente_id = ?',
      [updated.nota_componente_id]
    );
    if (comp) await recalcularEstadoMateria(comp.componente_materia_usuario_id);

    res.json({ success: true, data: updated });
  } catch (error) {
    if (error.code === 'ER_CHECK_CONSTRAINT_VIOLATED')
      return res.status(422).json({ success: false, message: error.sqlMessage || error.message });
    next(error);
  }
};

/** DELETE /api/notas/:id */
const deleteNota = async (req, res, next) => {
  try {
    const { id } = req.params;

    // Obtener componente_id antes de borrar
    const [[nota]] = await pool.query(
      'SELECT nota_componente_id FROM nota WHERE nota_id = ?', [id]
    );
    if (!nota) return res.status(404).json({ success: false, message: 'Nota no encontrada' });

    const [[comp]] = await pool.query(
      'SELECT componente_materia_usuario_id FROM componente WHERE componente_id = ?',
      [nota.nota_componente_id]
    );

    await pool.query('DELETE FROM nota WHERE nota_id = ?', [id]);

    // Recalcular estado después de eliminar (no hay trigger para DELETE)
    if (comp) await recalcularEstadoMateria(comp.componente_materia_usuario_id);

    res.json({ success: true, message: 'Nota eliminada correctamente' });
  } catch (error) {
    next(error);
  }
};

module.exports = { list, create, update, deleteNota };
