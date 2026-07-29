const pool = require('../config/db');

exports.promedioSemestres = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query(
      'SELECT * FROM v_promedio_semestre WHERE usuario_id = ? ORDER BY year, periodo',
      [id]
    );
    return res.json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};

exports.creditosTipologia = async (req, res, next) => {
  try {
    const { id, tipologia_id } = req.params;
    const [[row]] = await pool.query(
      'SELECT fn_creditos_aprobados_tipologia(?, ?) AS creditos_aprobados',
      [id, tipologia_id]
    );
    return res.json({ success: true, data: row });
  } catch (err) {
    next(err);
  }
};
