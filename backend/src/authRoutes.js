
const express = require('express');
const router = express.Router();

const authController = require('./authController');
const authMiddleware = require('./authMiddleware');

router.post('/cadastrar', authController.cadastrar);
router.post('/login', authController.login);


router.get('/me', authMiddleware, authController.me);

module.exports = router;