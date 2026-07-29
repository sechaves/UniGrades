const router = require('express').Router();
const ctrl   = require('../controllers/notas.controller');
const auth   = require('../middleware/auth.middleware');

router.use(auth);

// Montado en /api — paths completos para claridad
router.get(   '/componentes/:id/notas', ctrl.list);
router.post(  '/componentes/:id/notas', ctrl.create);
router.put(   '/notas/:id',             ctrl.update);
router.delete('/notas/:id',             ctrl.deleteNota);

module.exports = router;
