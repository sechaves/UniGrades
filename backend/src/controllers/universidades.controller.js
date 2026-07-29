const pool = require('../config/db');

exports.list = async (req, res, next) => {
  try {
    const [rows] = await pool.query(
      `SELECT universidad_id, universidad_nombre, universidad_sigla,
              universidad_pais, universidad_ciudad, universidad_logo_url
       FROM universidad
       ORDER BY universidad_nombre`
    );
    return res.json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};

exports.programas = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query(
      `SELECT p.programa_id, p.programa_nombre, p.programa_facultad,
              p.programa_total_creditos
       FROM programa p
       WHERE p.programa_universidad_id = ?
       ORDER BY p.programa_nombre`,
      [id]
    );
    return res.json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};
