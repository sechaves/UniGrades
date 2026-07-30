const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/semestres.controller');
const auth = require('../middleware/auth.middleware');

router.use(auth);

// Rutas montadas en /api/usuarios
// GET  /api/usuarios/:id/semestres
// POST /api/usuarios/:id/semestres
router.get( '/:id/semestres',  ctrl.listByUsuario);
router.post('/:id/semestres',  ctrl.create);

// Rutas montadas en /api/semestres (via app.use('/api/semestres', semestresRoutes2))
// — se manejan en semestres2.routes.js

module.exports = router;
