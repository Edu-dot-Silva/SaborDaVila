const express = require('express');
const cors = require('cors');
const authController = require('./src/authController');
const authRoutes = require('./src/authRoutes');
const authMiddleware = require('./src/authMiddleware');
const app = express();


app.use(cors());
app.use(express.json());


app.post('/cadastrar', authController.cadastrar);
app.post('/login', authController.login);

app.use('/auth', authRoutes);
app.get('/me', authMiddleware, authController.me);

app.get('/', (req, res) => {
    res.json({ msg: 'API funcionando!' });
});

module.exports = app;