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
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:5173',
  credentials: true,
}));
app.use(express.json());

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

// ── Health-check ──────────────────────────────────────────────────────────────
app.get('/api/health', (_req, res) => res.json({ status: 'ok' }));

// ── Error handler (debe ir al final) ─────────────────────────────────────────
app.use(errorMiddleware);

module.exports = app;
