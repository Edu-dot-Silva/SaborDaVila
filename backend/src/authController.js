const bcrypt = require('bcrypt');
const db = require('./database');
const { generateToken } = require('./generateToken');
require('./generateToken');
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

exports.login = async (req, res) => {
    try {
        const {email, senha} = req.body;
        if (!email || !senha) return res.status(400).json({msg: "Campos não preenchidos ou inválidos"});

        const [rows] = await db.query("SELECT email, funcionario_id, senha_hash FROM funcionario WHERE email = ?", [email]);
        if (rows.lenght === 0) return res.status(401).json({msg: "Email ou senha inválidos"});
        const usuario = rows[0];

        const id = usuario.funcionario_id;
        const checkSenha = await bcrypt.compare(senha, usuario.senha_hash);

        if (!checkSenha) return res.status(401).json({msg: "Email ou senha inválidos"});

        const token = generateToken(id);

        return res.status(200).json({msg: "Login efetuado com sucesso", token, id});

    } catch (error) {
        console.error(error.message)
        return res.status(500).json({msg: "Erro interno do servidor"});        
    }
};


exports.me = async (req, res) => {
    try {
        return res.status(200).json({
            funcionarioId: req.funcionarioId
        });
    } catch (error) {
        return res.status(500).json({
            msg: 'Erro interno do servidor'
        });
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