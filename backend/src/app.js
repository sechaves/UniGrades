const express = require('express');
const cors = require('cors');
require('dotenv').config();

const authRoutes          = require('./routes/auth.routes');
const usuariosRoutes      = require('./routes/usuarios.routes');
const semestresRoutes     = require('./routes/semestres.routes');
const materiasRoutes      = require('./routes/materias.routes');
const materiaUsuarioRoutes = require('./routes/materia_usuario.routes');
const componentesRoutes   = require('./routes/componentes.routes');
const notasRoutes         = require('./routes/notas.routes');
const reportesRoutes      = require('./routes/reportes.routes');
const universidadesRoutes = require('./routes/universidades.routes');

const errorMiddleware = require('./middleware/error.middleware');

const app = express();

// ── Middleware global ─────────────────────────────────────────────────────────
// CORS_ORIGIN puede ser una URL única o una lista separada por comas
// Ej: https://unigrades.vercel.app,https://unigrades-git-main.vercel.app
const allowedOrigins = (process.env.CORS_ORIGIN || 'http://localhost:5173')
  .split(',')
  .map(o => o.trim());

app.use(cors({
  origin: (origin, callback) => {
    // Permitir peticiones sin origin (Postman, Railway health-checks)
    if (!origin) return callback(null, true);
    if (allowedOrigins.includes(origin)) return callback(null, true);
    callback(new Error(`CORS bloqueado para: ${origin}`));
  },
  credentials: true,
}));
app.use(express.json());

// ── Health-check (público, debe ir ANTES de las rutas protegidas) ─────────────
app.get('/api/health', (_req, res) => res.json({ 
  status: 'ok', 
  timestamp: new Date().toISOString(),
  version: '2.0',
  routes: ['/api/materias', '/api/universidades', '/api/auth/login']
}));

// ── Rutas ─────────────────────────────────────────────────────────────────────
app.use('/api/auth',            authRoutes);
app.use('/api/universidades',   universidadesRoutes);
app.use('/api',                 usuariosRoutes);
app.use('/api',                 semestresRoutes);
app.use('/api/materias',        materiasRoutes);
app.use('/api/materia-usuario', materiaUsuarioRoutes);
app.use('/api',                 componentesRoutes);
app.use('/api',                 notasRoutes);
app.use('/api',                 reportesRoutes);

// ── Error handler (debe ir al final) ─────────────────────────────────────────
app.use(errorMiddleware);

module.exports = app;
