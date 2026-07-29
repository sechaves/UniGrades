const pool = require('../config/db');

exports.getById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [[row]] = await pool.query(
      'SELECT * FROM v_nota_materia WHERE materia_usuario_id = ?',
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
