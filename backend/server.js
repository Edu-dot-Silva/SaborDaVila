require('dotenv').config();
const app = require('./app');
const db = require('./src/database');
 
const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || "127.0.0.1";
 
db.query('SELECT 1').then(() => {
    console.log('✅ MySQL conectado');
    app.listen(PORT, HOST, () => console.log(`✅ Servidor rodando em http://${HOST}:${PORT}`));
})
.catch(err => {console.error('❌ Erro MySQL: ', err.message);  process.exit(1);});