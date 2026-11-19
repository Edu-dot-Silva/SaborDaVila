const bcrypt = require('bcrypt');
const db = require('./database');
require('dotenv').config();

exports.cadastrar = async (req, res) => {
    try {
        const {perfil, nome, email, senha, chave} = req.body;
        if (!["garcom", "cozinha", "caixa", "gerente"].includes(perfil) || !nome || !email || !senha) return res.status(400).json({msg: "Campos não preenchidos ou inválidos"});
    
        if (perfil === 'gerente' && chave !== process.env.CHAVE_GERENTE) return res.status(403).json({msg: "Chave inválida"});
    
        const [emailExiste] = await db.query("SELECT email FROM funcionario WHERE email = ?", [email]);
        if (emailExiste.length > 0) return res.status(409).json({msg: "Email já cadastrado"});
    
        const senhaHash = await bcrypt.hash(senha, 10);
        await db.query("INSERT INTO funcionario(perfil, nome, email, senha_hash) VALUES (?, ?, ?, ?)", [perfil, nome, email, senhaHash]);
    
        return res.status(201).json({msg: `Funcionário ${nome} cadastrado com sucesso`});
        
    } catch (error) {
        console.error(error.message)
        return res.status(500).json({msg: "Erro interno do servidor"});
    }
};




// // teste
// this.cadastrar(
//     {
//         body: {
//             perfil: 'garcom',
//             nome: 'teste',
//             email: 'teste@gmail.com',
//             senha: '123456'
//         }
//     },
//     {
//         status: codigo => ({ json: dados => console.log(codigo, dados) })
//     }
// )