const express = require('express');
const router = express.Router();
const usuariosController = require('../controllers/usuarios.controller');
const authMiddleware = require('../middleware/auth.middleware');

// Todas las rutas requieren autenticación
router.use(authMiddleware);

// GET /api/usuarios/:id
router.get('/:id', usuariosController.getById);

// PUT /api/usuarios/:id
router.put('/:id', usuariosController.update);

// GET /api/usuarios/:id/resumen
router.get('/:id/resumen', usuariosController.resumen);

// GET /api/usuarios/:id/promedio-global
router.get('/:id/promedio-global', usuariosController.promedioGlobal);

// GET /api/usuarios/:id/avance-tipologia
router.get('/:id/avance-tipologia', usuariosController.avanceTipologia);

module.exports = router;
