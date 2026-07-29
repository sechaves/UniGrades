module.exports = function errorMiddleware(err, req, res, _next) {
  // Trigger SIGNAL SQLSTATE '45000'
  if (err.sqlState === '45000') {
    return res.status(422).json({ success: false, message: err.sqlMessage });
  }
  // MySQL CHECK constraint violation
  if (err.code === 'ER_CHECK_CONSTRAINT_VIOLATED') {
    return res.status(422).json({ success: false, message: err.sqlMessage });
  }
  // MySQL duplicate entry
  if (err.code === 'ER_DUP_ENTRY') {
    return res.status(409).json({ success: false, message: 'Registro duplicado.' });
  }
  console.error(err);
  return res.status(500).json({ success: false, message: 'Error interno del servidor.' });
};
