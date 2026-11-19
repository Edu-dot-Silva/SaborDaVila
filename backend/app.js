const express = require('express');
const cors = require('cors');

const authRoutes = require('./src/authRoutes');

const app = express();


app.use(cors());
app.use(express.json());


app.use('/auth', authRoutes);


app.get('/', (req, res) => {
    res.json({ msg: 'API funcionando!' });
});

module.exports = app;