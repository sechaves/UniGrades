const express = require('express');
const router = express.Router();
const materiaUsuarioController = require('../controllers/materia_usuario.controller');
const authMiddleware = require('../middleware/auth.middleware');

// Todas las rutas requieren autenticación
router.use(authMiddleware);

// GET /api/materia-usuario/:id
router.get('/:id', materiaUsuarioController.getById);

// PUT /api/materia-usuario/:id/estado
router.put('/:id/estado', materiaUsuarioController.updateEstado);

module.exports = router;
