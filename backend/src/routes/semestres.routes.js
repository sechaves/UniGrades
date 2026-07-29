const express = require('express');
const router = express.Router();
const semestresController = require('../controllers/semestres.controller');
const authMiddleware = require('../middleware/auth.middleware');

// Todas las rutas requieren autenticación
router.use(authMiddleware);

// GET /api/usuarios/:id/semestres
router.get('/usuarios/:id/semestres', semestresController.listByUsuario);

// POST /api/usuarios/:id/semestres
router.post('/usuarios/:id/semestres', semestresController.create);

// GET /api/semestres/:id/materias
router.get('/semestres/:id/materias', semestresController.materiasBySemestre);

// GET /api/semestres/:id/promedio
router.get('/semestres/:id/promedio', semestresController.promedio);

// POST /api/semestres/:semestre_id/inscribir
router.post('/semestres/:semestre_id/inscribir', semestresController.inscribir);

module.exports = router;
