const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/semestres.controller');
const auth = require('../middleware/auth.middleware');

router.use(auth);

// Montado en /api/semestres
// GET  /api/semestres/:id/materias
router.get('/:id/materias',  ctrl.materiasBySemestre);

// GET  /api/semestres/:id/promedio
router.get('/:id/promedio',  ctrl.promedio);

// POST /api/semestres/:semestre_id/inscribir
router.post('/:semestre_id/inscribir', ctrl.inscribir);

module.exports = router;
