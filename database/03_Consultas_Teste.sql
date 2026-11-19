

USE sabor_da_vila;


-- 1) Listar tudo de cada tabela
SELECT * FROM categoria;
SELECT * FROM mesa;
SELECT * FROM funcionario;
SELECT * FROM produto;
SELECT * FROM comanda;
SELECT * FROM item_comanda;

-- 2) Produtos com preco maior ou igual a 50
SELECT * FROM produto WHERE preco_atual >= 50;

-- 3) Produtos com preco menor que 15
SELECT * FROM produto WHERE preco_atual < 15;

-- 4) Produtos com preco entre 20 e 50
SELECT * FROM produto WHERE preco_atual BETWEEN 20 AND 50;

-- 5) Produtos que contem "a" no nome
SELECT * FROM produto WHERE nome LIKE '%a%';

-- 6) Produtos que comecam com "S"
SELECT * FROM produto WHERE nome LIKE 'S%';

-- 7) Produtos que terminam com "o"
SELECT * FROM produto WHERE nome LIKE '%o';

-- 8) Produtos indisponiveis
SELECT * FROM produto WHERE disponivel = FALSE;

-- 9) Produtos da categoria 3 (Bebidas)
SELECT * FROM produto WHERE categoria_id = 3;

-- 10) Produtos ordenados do mais caro ao mais barato
SELECT * FROM produto ORDER BY preco_atual DESC;

-- 11) Os 3 produtos mais baratos
SELECT * FROM produto ORDER BY preco_atual ASC LIMIT 3;

-- 12) Mesas com 4 lugares ou mais
SELECT * FROM mesa WHERE lugares >= 4;

-- 13) Funcionarios com perfil garcom
SELECT * FROM funcionario WHERE perfil = 'garcom';

-- 14) Funcionarios inativos
SELECT * FROM funcionario WHERE ativo = FALSE;

-- 15) Funcionarios com email do dominio sabordavila.com
SELECT * FROM funcionario WHERE email LIKE '%@sabordavila.com';

-- 16) Funcionarios cujo nome comeca com "A" ou "C"
SELECT * FROM funcionario WHERE nome LIKE 'A%' OR nome LIKE 'C%';

-- 17) Comandas abertas
SELECT * FROM comanda WHERE status = 'aberta';

-- 18) Comandas fechadas pagas no pix
SELECT * FROM comanda WHERE status = 'fechada' AND forma_pagamento = 'pix';

-- 19) Comandas com taxa de servico
SELECT * FROM comanda WHERE taxa_servico = TRUE;

-- 20) Comandas abertas a partir de uma data
SELECT * FROM comanda WHERE aberta_em >= '2026-11-19 00:00:00';

-- 21) Itens com quantidade maior ou igual a 3
SELECT * FROM item_comanda WHERE quantidade >= 3;

-- 22) Itens pendentes
SELECT * FROM item_comanda WHERE status = 'pendente';

-- 23) Itens ainda nao entregues
SELECT * FROM item_comanda WHERE status IN ('pendente', 'em_preparo', 'pronto');

-- 24) Itens cancelados
SELECT * FROM item_comanda WHERE status = 'cancelado';

-- 25) Itens que tem observacao
SELECT * FROM item_comanda WHERE observacao IS NOT NULL;

-- 26) Itens cuja observacao contem "sem"
SELECT * FROM item_comanda WHERE observacao LIKE '%sem%';

-- 27) Itens da comanda 4
SELECT * FROM item_comanda WHERE comanda_id = 4;

