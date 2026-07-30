const pool = require('../config/db');

exports.getById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [[user]] = await pool.query(
      `SELECT u.usuario_id, u.usuario_nombre, u.usuario_apellido,
              u.usuario_email, u.usuario_codigo_estudiantil,
              u.usuario_avatar_url, u.usuario_programa_id,
              p.programa_nombre, p.programa_total_creditos,
              un.universidad_nombre
       FROM usuario u
       JOIN programa p ON p.programa_id = u.usuario_programa_id
       JOIN universidad un ON un.universidad_id = p.programa_universidad_id
       WHERE u.usuario_id = ?`,
      [id]
    );
    if (!user) return res.status(404).json({ success: false, message: 'Usuario no encontrado.' });
    return res.json({ success: true, data: user });
  } catch (err) {
    next(err);
  }
};

exports.update = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { nombre, apellido, avatar_url } = req.body;
    await pool.query(
      `UPDATE usuario
       SET usuario_nombre = COALESCE(?, usuario_nombre),
           usuario_apellido = COALESCE(?, usuario_apellido),
           usuario_avatar_url = COALESCE(?, usuario_avatar_url)
       WHERE usuario_id = ?`,
      [nombre || null, apellido || null, avatar_url || null, id]
    );
    const [[user]] = await pool.query(
      'SELECT usuario_id, usuario_nombre, usuario_apellido, usuario_email, usuario_avatar_url FROM usuario WHERE usuario_id = ?',
      [id]
    );
    return res.json({ success: true, data: user });
  } catch (err) {
    next(err);
  }
};

exports.resumen = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [results] = await pool.query('CALL sp_resumen_academico_usuario(?)', [id]);
    // results[0] = encabezado (array de 1 fila), results[1] = semestres
    return res.json({
      success: true,
      data: {
        encabezado: results[0][0] || null,
        semestres: results[1] || [],
      },
    });
  } catch (err) {
    next(err);
  }
};

exports.promedioGlobal = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [[row]] = await pool.query(
      'SELECT * FROM v_promedio_global WHERE usuario_id = ?',
      [id]
    );
    // Si la vista devuelve null, retornar estructura con 0s en vez de null
    return res.json({
      success: true,
      data: row || {
        usuario_id: Number(id),
        promedio_global: null,
        total_creditos_cursados: 0,
        total_creditos_aprobados: 0,
      },
    });
  } catch (err) {
    next(err);
  }
};

exports.avanceTipologia = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query(
      'SELECT * FROM v_avance_tipologia WHERE usuario_id = ?',
      [id]
    );
    return res.json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};
