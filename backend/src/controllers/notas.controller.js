const pool = require('../config/db');

/**
 * GET /api/componentes/:id/notas
 * Lista notas de un componente
 */
const list = async (req, res, next) => {
  try {
    const { id } = req.params;

    const [rows] = await pool.query(`
      SELECT 
        nota_id,
        nota_nombre,
        nota_valor,
        nota_fecha_registro,
        nota_componente_id
      FROM nota
      WHERE nota_componente_id = ?
      ORDER BY nota_fecha_registro DESC
    `, [id]);

    res.json({
      success: true,
      data: rows
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/componentes/:id/notas
 * Crea una nueva nota
 * Después de insertar, re-lee materia_usuario_estado (trigger trg_actualizar_estado_materia)
 * Catch CHECK constraint violation y SQLSTATE 45000
 */
const create = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { nombre, valor, fecha_registro } = req.body;

    if (!nombre || valor === undefined) {
      return res.status(400).json({
        success: false,
        message: 'Los campos nombre y valor son requeridos'
      });
    }

    // Validación escala colombiana 0.0 - 5.0
    if (valor < 0.0 || valor > 5.0) {
      return res.status(400).json({
        success: false,
        message: 'El valor de la nota debe estar entre 0.0 y 5.0'
      });
    }

    // Obtener materia_usuario_id para re-leer después
    const [componente] = await pool.query(
      'SELECT componente_materia_usuario_id FROM componente WHERE componente_id = ?',
      [id]
    );

    if (componente.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Componente no encontrado'
      });
    }

    const materia_usuario_id = componente[0].componente_materia_usuario_id;

    // Insert nota
    const [result] = await pool.query(
      `INSERT INTO nota 
       (nota_nombre, nota_valor, nota_fecha_registro, nota_componente_id) 
       VALUES (?, ?, ?, ?)`,
      [nombre, valor, fecha_registro || new Date(), id]
    );

    const [newNota] = await pool.query(
      'SELECT * FROM nota WHERE nota_id = ?',
      [result.insertId]
    );

    // Re-leer materia_usuario_estado (trigger trg_actualizar_estado_materia puede haberlo cambiado)
    const [materiaUsuario] = await pool.query(
      'SELECT materia_usuario_estado FROM materia_usuario WHERE materia_usuario_id = ?',
      [materia_usuario_id]
    );

    res.status(201).json({
      success: true,
      data: {
        nota: newNota[0],
        materia_usuario_estado: materiaUsuario[0]?.materia_usuario_estado
      }
    });
  } catch (error) {
    // Catch trigger error or CHECK constraint
    if (error.sqlState === '45000' || error.code === 'ER_CHECK_CONSTRAINT_VIOLATED') {
      return res.status(422).json({
        success: false,
        message: error.sqlMessage || error.message
      });
    }
    next(error);
  }
};

/**
 * PUT /api/notas/:id
 * Actualiza una nota
 * Validar nota_valor 0.0 - 5.0 antes de DB
 */
const update = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { nombre, valor, fecha_registro } = req.body;

    // Validación escala colombiana si se envía valor
    if (valor !== undefined && (valor < 0.0 || valor > 5.0)) {
      return res.status(400).json({
        success: false,
        message: 'El valor de la nota debe estar entre 0.0 y 5.0'
      });
    }

    const fields = [];
    const values = [];

    if (nombre !== undefined) {
      fields.push('nota_nombre = ?');
      values.push(nombre);
    }
    if (valor !== undefined) {
      fields.push('nota_valor = ?');
      values.push(valor);
    }
    if (fecha_registro !== undefined) {
      fields.push('nota_fecha_registro = ?');
      values.push(fecha_registro);
    }

    if (fields.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'No hay campos para actualizar'
      });
    }

    values.push(id);

    const [result] = await pool.query(
      `UPDATE nota SET ${fields.join(', ')} WHERE nota_id = ?`,
      values
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: 'Nota no encontrada'
      });
    }

    const [updated] = await pool.query(
      'SELECT * FROM nota WHERE nota_id = ?',
      [id]
    );

    res.json({
      success: true,
      data: updated[0]
    });
  } catch (error) {
    // Catch CHECK constraint
    if (error.code === 'ER_CHECK_CONSTRAINT_VIOLATED') {
      return res.status(422).json({
        success: false,
        message: error.sqlMessage || error.message
      });
    }
    next(error);
  }
};

/**
 * DELETE /api/notas/:id
 */
const deleteNota = async (req, res, next) => {
  try {
    const { id } = req.params;

    const [result] = await pool.query(
      'DELETE FROM nota WHERE nota_id = ?',
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: 'Nota no encontrada'
      });
    }

    res.json({
      success: true,
      message: 'Nota eliminada correctamente'
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  list,
  create,
  update,
  deleteNota
};
