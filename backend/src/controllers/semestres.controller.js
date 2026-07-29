const pool = require('../config/db');

exports.listByUsuario = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query(
      `SELECT s.*,
              fn_promedio_semestre(s.semestre_usuario_id, s.semestre_id) AS promedio_semestre
       FROM semestre s
       WHERE s.semestre_usuario_id = ?
       ORDER BY s.semestre_year, s.semestre_periodo`,
      [id]
    );
    return res.json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};

exports.create = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { semestre_numero, semestre_year, semestre_periodo } = req.body;
    if (!semestre_numero || !semestre_year || !semestre_periodo)
      return res.status(400).json({ success: false, message: 'Faltan campos obligatorios.' });

    const [result] = await pool.query(
      `INSERT INTO semestre (semestre_usuario_id, semestre_numero, semestre_year, semestre_periodo)
       VALUES (?, ?, ?, ?)`,
      [id, semestre_numero, semestre_year, semestre_periodo]
    );
    const [[sem]] = await pool.query('SELECT * FROM semestre WHERE semestre_id = ?', [result.insertId]);
    return res.status(201).json({ success: true, data: sem });
  } catch (err) {
    next(err);
  }
};

exports.materiasBySemestre = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query(
      'SELECT * FROM v_nota_materia WHERE semestre_id = ?',
      [id]
    );
    return res.json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};

exports.promedio = async (req, res, next) => {
  try {
    const { id } = req.params;
    // Need usuario_id — get it from the semestre row
    const [[sem]] = await pool.query(
      'SELECT semestre_usuario_id FROM semestre WHERE semestre_id = ?',
      [id]
    );
    if (!sem) return res.status(404).json({ success: false, message: 'Semestre no encontrado.' });

    const [[row]] = await pool.query(
      'SELECT fn_promedio_semestre(?, ?) AS promedio_semestre',
      [sem.semestre_usuario_id, id]
    );
    return res.json({ success: true, data: row });
  } catch (err) {
    next(err);
  }
};

exports.inscribir = async (req, res, next) => {
  try {
    const { semestre_id } = req.params;
    const { usuario_id, materia_id } = req.body;
    if (!usuario_id || !materia_id)
      return res.status(400).json({ success: false, message: 'usuario_id y materia_id requeridos.' });

    await pool.query('SET @msg = ""');
    await pool.query('CALL sp_inscribir_materia(?, ?, ?, @msg)', [usuario_id, materia_id, semestre_id]);
    const [[{ mensaje }]] = await pool.query('SELECT @msg AS mensaje');

    if (mensaje.startsWith('Materia inscrita correctamente')) {
      return res.status(201).json({ success: true, data: { mensaje } });
    }
    return res.status(422).json({ success: false, message: mensaje });
  } catch (err) {
    next(err);
  }
};
