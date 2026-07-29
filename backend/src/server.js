const app = require('./app');
const pool = require('./config/db');

const PORT = process.env.PORT || 3001;

async function start() {
  try {
    // Verify DB connection before accepting traffic
    const conn = await pool.getConnection();
    conn.release();
    console.log('✅  Conexión a la base de datos establecida.');

    app.listen(PORT, () => {
      console.log(`🚀  UniGrades API corriendo en http://localhost:${PORT}/api`);
    });
  } catch (err) {
    console.error('❌  No se pudo conectar a la base de datos:', err.message);
    process.exit(1);
  }
}

start();
