const express = require('express');
const router = express.Router();
const componentesController = require('../controllers/componentes.controller');
const authMiddleware = require('../middleware/auth.middleware');

// Todas las rutas requieren autenticación
router.use(authMiddleware);

// GET /api/materia-usuario/:mu_id/componentes
router.get('/materia-usuario/:mu_id/componentes', componentesController.list);

// POST /api/materia-usuario/:mu_id/componentes
router.post('/materia-usuario/:mu_id/componentes', componentesController.create);

// PUT /api/componentes/:id
router.put('/componentes/:id', componentesController.update);

// DELETE /api/componentes/:id
router.delete('/componentes/:id', componentesController.remove);

module.exports = router;
