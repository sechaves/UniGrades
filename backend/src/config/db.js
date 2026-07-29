const mysql = require('mysql2/promise');
require('dotenv').config();

let pool;

if (process.env.DATABASE_URL) {
  // Railway provee MYSQL_URL con formato:
  // mysql://user:pass@host:port/dbname
  // Reemplazamos mysql:// por vacío para parsear manualmente
  const url = new URL(process.env.DATABASE_URL.replace(/^mysql2?:\/\//, 'http://'));
  pool = mysql.createPool({
    host:     url.hostname,
    port:     Number(url.port) || 3306,
    user:     url.username,
    password: url.password,
    database: url.pathname.replace('/', ''),
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
    charset: 'utf8mb4',
  });
} else {
  pool = mysql.createPool({
    host:     process.env.DB_HOST     || 'localhost',
    port:     Number(process.env.DB_PORT) || 3306,
    user:     process.env.DB_USER     || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME     || 'unigrades',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
    charset: 'utf8mb4',
  });
}

module.exports = pool;
