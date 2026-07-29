const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/universidades.controller');

// Rutas públicas (no requieren JWT — necesarias para el formulario de registro)
// GET /api/universidades
router.get('/', ctrl.list);

// GET /api/universidades/:id/programas
router.get('/:id/programas', ctrl.programas);

module.exports = router;
