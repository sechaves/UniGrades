const pool = require('../config/db');

exports.list = async (req, res, next) => {
  try {
    const { mu_id } = req.params;
    const [rows] = await pool.query(
      `SELECT
          vc.*,
          c.componente_nota_minima,
          c.componente_orden
       FROM v_promedio_componente vc
       INNER JOIN componente c ON c.componente_id = vc.componente_id
       WHERE vc.componente_materia_usuario_id = ?
       ORDER BY c.componente_orden`,
      [mu_id]
    );
    return res.json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};

exports.create = async (req, res, next) => {
  try {
    const { mu_id } = req.params;
    const { nombre, porcentaje, nota_minima, orden } = req.body;

    if (!nombre || porcentaje === undefined || !orden) {
      return res.status(400).json({
        success: false,
        message: 'nombre, porcentaje y orden son obligatorios.',
      });
    }

    const [result] = await pool.query(
      `INSERT INTO componente
         (componente_materia_usuario_id, componente_nombre, componente_porcentaje,
          componente_nota_minima, componente_orden)
       VALUES (?, ?, ?, ?, ?)`,
      [mu_id, nombre, porcentaje, nota_minima || null, orden]
    );

    const [[comp]] = await pool.query(
      'SELECT * FROM componente WHERE componente_id = ?',
      [result.insertId]
    );
    return res.status(201).json({ success: true, data: comp });
  } catch (err) {
    next(err);
  }
};

exports.update = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { nombre, porcentaje, nota_minima, orden } = req.body;

    await pool.query(
      `UPDATE componente
       SET componente_nombre       = COALESCE(?, componente_nombre),
           componente_porcentaje   = COALESCE(?, componente_porcentaje),
           componente_nota_minima  = COALESCE(?, componente_nota_minima),
           componente_orden        = COALESCE(?, componente_orden)
       WHERE componente_id = ?`,
      [nombre || null, porcentaje ?? null, nota_minima ?? null, orden ?? null, id]
    );

    const [[comp]] = await pool.query(
      'SELECT * FROM componente WHERE componente_id = ?',
      [id]
    );
    if (!comp) {
      return res.status(404).json({ success: false, message: 'Componente no encontrado.' });
    }
    return res.json({ success: true, data: comp });
  } catch (err) {
    next(err);
  }
};

exports.remove = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [result] = await pool.query(
      'DELETE FROM componente WHERE componente_id = ?',
      [id]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Componente no encontrado.' });
    }
    return res.json({ success: true, data: { deleted_id: Number(id) } });
  } catch (err) {
    next(err);
  }
};
