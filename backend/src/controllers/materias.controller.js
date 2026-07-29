const pool = require('../config/db');

exports.list = async (req, res, next) => {
  try {
    const [rows] = await pool.query(
      `SELECT
          m.materia_id,
          m.materia_codigo,
          m.materia_nombre,
          m.materia_creditos,
          m.materia_nota_minima_aprobacion,
          m.materia_semestre_sugerido,
          t.tipologia_id,
          t.tipologia_nombre,
          t.tipologia_cuenta_promedio,
          p.programa_id,
          p.programa_nombre
       FROM materia m
       INNER JOIN tipologia t ON t.tipologia_id = m.materia_tipologia_id
       INNER JOIN programa p  ON p.programa_id  = t.tipologia_programa_id
       ORDER BY p.programa_nombre, t.tipologia_nombre, m.materia_semestre_sugerido, m.materia_nombre`
    );
    return res.json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};

exports.getById = async (req, res, next) => {
  try {
    const { id } = req.params;

    const [[materia]] = await pool.query(
      `SELECT
          m.materia_id,
          m.materia_codigo,
          m.materia_nombre,
          m.materia_creditos,
          m.materia_nota_minima_aprobacion,
          m.materia_semestre_sugerido,
          t.tipologia_id,
          t.tipologia_nombre,
          t.tipologia_cuenta_promedio,
          p.programa_id,
          p.programa_nombre
       FROM materia m
       INNER JOIN tipologia t ON t.tipologia_id = m.materia_tipologia_id
       INNER JOIN programa p  ON p.programa_id  = t.tipologia_programa_id
       WHERE m.materia_id = ?`,
      [id]
    );

    if (!materia) {
      return res.status(404).json({ success: false, message: 'Materia no encontrada.' });
    }

    const [prerrequisitos] = await pool.query(
      `SELECT m2.materia_id, m2.materia_codigo, m2.materia_nombre, m2.materia_creditos
       FROM materia_prerrequisito mp
       INNER JOIN materia m2 ON m2.materia_id = mp.prerrequisito_materia_id
       WHERE mp.materia_id = ?`,
      [id]
    );

    const [correquisitos] = await pool.query(
      `SELECT m2.materia_id, m2.materia_codigo, m2.materia_nombre, m2.materia_creditos
       FROM materia_correquisito mc
       INNER JOIN materia m2 ON m2.materia_id = mc.correquisito_materia_id
       WHERE mc.materia_id = ?`,
      [id]
    );

    return res.json({
      success: true,
      data: { ...materia, prerrequisitos, correquisitos },
    });
  } catch (err) {
    next(err);
  }
};
