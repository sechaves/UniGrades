const express = require('express');
const router = express.Router();
const materiasController = require('../controllers/materias.controller');
const authMiddleware = require('../middleware/auth.middleware');

// Todas las rutas requieren autenticación
router.use(authMiddleware);

// GET /api/materias
router.get('/', materiasController.list);

// GET /api/materias/:id
router.get('/:id', materiasController.getById);

module.exports = router;
