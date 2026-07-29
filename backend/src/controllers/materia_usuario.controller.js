const pool = require('../config/db');

exports.getById = async (req, res, next) => {
  try {
    const { id } = req.params;
    // Usamos JOIN directo para que funcione aunque la materia no tenga notas aún
    const [[row]] = await pool.query(
      `SELECT
          mu.materia_usuario_id,
          s.semestre_usuario_id            AS usuario_id,
          mu.materia_usuario_semestre_id   AS semestre_id,
          m.materia_id,
          m.materia_nombre                 AS materia,
          m.materia_codigo,
          m.materia_creditos               AS creditos,
          t.tipologia_id,
          t.tipologia_cuenta_promedio      AS cuenta_promedio,
          mu.materia_usuario_estado        AS estado,
          vnm.nota_acumulada,
          vnm.porcentaje_evaluado,
          vnm.nota_final
       FROM materia_usuario mu
       INNER JOIN semestre s   ON s.semestre_id  = mu.materia_usuario_semestre_id
       INNER JOIN materia m    ON m.materia_id   = mu.materia_usuario_materia_id
       INNER JOIN tipologia t  ON t.tipologia_id = m.materia_tipologia_id
       LEFT JOIN v_nota_materia vnm ON vnm.materia_usuario_id = mu.materia_usuario_id
       WHERE mu.materia_usuario_id = ?`,
      [id]
    );
    if (!row) {
      return res.status(404).json({ success: false, message: 'Materia no encontrada.' });
    }
    return res.json({ success: true, data: row });
  } catch (err) {
    next(err);
  }
};

exports.updateEstado = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { estado } = req.body;

    if (!estado) {
      return res.status(400).json({ success: false, message: 'El campo estado es requerido.' });
    }

    // Only 'retirada' is allowed — aprobada/reprobada are managed by trigger
    if (estado !== 'retirada') {
      return res.status(422).json({
        success: false,
        message:
          'Solo se puede cambiar el estado a "retirada". Los estados "aprobada" y "reprobada" los asigna el sistema automáticamente.',
      });
    }

    const [[current]] = await pool.query(
      'SELECT materia_usuario_estado FROM materia_usuario WHERE materia_usuario_id = ?',
      [id]
    );
    if (!current) {
      return res.status(404).json({ success: false, message: 'Materia no encontrada.' });
    }
    if (current.materia_usuario_estado !== 'en_curso') {
      return res.status(422).json({
        success: false,
        message: `No se puede retirar una materia en estado "${current.materia_usuario_estado}".`,
      });
    }

    await pool.query(
      'UPDATE materia_usuario SET materia_usuario_estado = ? WHERE materia_usuario_id = ?',
      [estado, id]
    );

    const [[updated]] = await pool.query(
      'SELECT * FROM materia_usuario WHERE materia_usuario_id = ?',
      [id]
    );
    return res.json({ success: true, data: updated });
  } catch (err) {
    next(err);
  }
};
