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
    // JOIN directo para incluir materias sin notas aún (v_nota_materia excluye las que no tienen notas)
    const [rows] = await pool.query(
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
       WHERE mu.materia_usuario_semestre_id = ?
       ORDER BY m.materia_nombre`,
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

exports.remove = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [result] = await pool.query(
      'DELETE FROM semestre WHERE semestre_id = ?',
      [id]
    );
    if (result.affectedRows === 0)
      return res.status(404).json({ success: false, message: 'Semestre no encontrado.' });
    return res.json({ success: true, data: { deleted_id: Number(id) } });
  } catch (err) {
    next(err);
  }
};
