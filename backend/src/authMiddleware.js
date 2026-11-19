const jwt = require('jsonwebtoken');
require('dotenv').config();

 
module.exports = (req, res, next) => {
    const authHeader = req.headers.authorization;

    if (!authHeader) {
        return res.status(401).json({ msg: 'Sem token!' });
    }

    const token = authHeader.split(' ')[1];

    try {
        const decoded = jwt.verify(
            token,
            process.env.JWT_SECRET
        );

        req.funcionarioId = decoded.id;

        next();

    } catch (error) {
        return res.status(401).json({
            msg: 'Token inválido!'
        });
    }
};
 