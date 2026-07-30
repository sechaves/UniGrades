const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/reportes.controller');
const auth = require('../middleware/auth.middleware');

router.use(auth);

// GET /api/usuarios/:id/reportes/semestres
router.get('/:id/reportes/semestres', ctrl.promedioSemestres);

// GET /api/usuarios/:id/reportes/tipologia/:tipologia_id
router.get('/:id/reportes/tipologia/:tipologia_id', ctrl.creditosTipologia);

module.exports = router;
