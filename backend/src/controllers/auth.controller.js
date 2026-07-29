const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('../config/db');

function signToken(user) {
  return jwt.sign(
    { id: user.usuario_id, email: user.usuario_email, programa_id: user.usuario_programa_id },
    process.env.JWT_SECRET,
    { expiresIn: '7d' }
  );
}

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password)
      return res.status(400).json({ success: false, message: 'Email y contraseña requeridos.' });

    const [[user]] = await pool.query(
      'SELECT * FROM usuario WHERE usuario_email = ?',
      [email]
    );
    if (!user)
      return res.status(401).json({ success: false, message: 'Credenciales incorrectas.' });

    const match = await bcrypt.compare(password, user.usuario_password_hash);
    if (!match)
      return res.status(401).json({ success: false, message: 'Credenciales incorrectas.' });

    const token = signToken(user);
    return res.json({
      success: true,
      data: {
        token,
        user: {
          usuario_id: user.usuario_id,
          usuario_nombre: user.usuario_nombre,
          usuario_apellido: user.usuario_apellido,
          usuario_email: user.usuario_email,
          usuario_programa_id: user.usuario_programa_id,
          usuario_avatar_url: user.usuario_avatar_url,
        },
      },
    });
  } catch (err) {
    next(err);
  }
};

exports.register = async (req, res, next) => {
  try {
    const { nombre, apellido, email, password, programa_id, codigo_estudiantil } = req.body;
    if (!nombre || !apellido || !email || !password || !programa_id)
      return res.status(400).json({ success: false, message: 'Campos obligatorios faltantes.' });

    const hash = await bcrypt.hash(password, 10);
    const [result] = await pool.query(
      `INSERT INTO usuario
         (usuario_programa_id, usuario_nombre, usuario_apellido,
          usuario_email, usuario_password_hash, usuario_codigo_estudiantil)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [programa_id, nombre, apellido, email, hash, codigo_estudiantil || null]
    );

    const [[user]] = await pool.query(
      'SELECT * FROM usuario WHERE usuario_id = ?',
      [result.insertId]
    );

    const token = signToken(user);
    return res.status(201).json({
      success: true,
      data: {
        token,
        user: {
          usuario_id: user.usuario_id,
          usuario_nombre: user.usuario_nombre,
          usuario_apellido: user.usuario_apellido,
          usuario_email: user.usuario_email,
          usuario_programa_id: user.usuario_programa_id,
        },
      },
    });
  } catch (err) {
    next(err);
  }
};
