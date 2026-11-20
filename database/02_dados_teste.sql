-- =====================================================================
-- Sabor da Vila - 02_Dados_Teste.sql
-- Testes de INSERT
-- Execute apos criar o banco (01) e com o banco recem-criado (vazio),
-- pois os IDs abaixo assumem AUTO_INCREMENT comecando em 1.
-- =====================================================================

USE sabor_da_vila;

-- ---------------------------------------------------------------------
-- CATEGORIA
-- ---------------------------------------------------------------------
INSERT INTO categoria (nome) VALUES
    ('Entradas'),            -- 1
    ('Pratos Principais'),   -- 2
    ('Bebidas'),             -- 3
    ('Sobremesas');          -- 4

-- ---------------------------------------------------------------------
-- MESA
-- ---------------------------------------------------------------------
INSERT INTO mesa (lugares) VALUES
    (2),
    (2),
    (4),
    (4),
    (6),
    (8);

-- ---------------------------------------------------------------------
-- FUNCIONARIO
-- (senha_hash abaixo e apenas ilustrativo, nao e um hash real)
-- ---------------------------------------------------------------------
INSERT INTO funcionario (perfil, nome, email, senha_hash, ativo) VALUES
    ('garcom',  'Carlos Almeida',  'carlos@sabordavila.com', '$2y$10$hashficticio.carlos.aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', TRUE),   -- 1
    ('garcom',  'Ana Souza',       'ana@sabordavila.com',    '$2y$10$hashficticio.ana.bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',    TRUE),   -- 2
    ('cozinha', 'Marcos Pereira',  'marcos@sabordavila.com', '$2y$10$hashficticio.marcos.cccccccccccccccccccccccccccccccccccc',   TRUE),   -- 3
    ('caixa',   'Juliana Ribeiro', 'juliana@sabordavila.com','$2y$10$hashficticio.juliana.dddddddddddddddddddddddddddddddddddd',  TRUE),   -- 4
    ('gerente', 'Roberto Lima',    'roberto@sabordavila.com','$2y$10$hashficticio.roberto.eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee',  TRUE),   -- 5
    ('garcom',  'Paulo Mendes',    'paulo@sabordavila.com',  '$2y$10$hashficticio.paulo.fffffffffffffffffffffffffffffffffffff',    FALSE);  -- 6 (inativo)

-- ---------------------------------------------------------------------
-- PRODUTO
-- ---------------------------------------------------------------------
INSERT INTO produto (nome, descricao, categoria_id, preco_atual, disponivel) VALUES
    ('Bolinho de Bacalhau',     '6 unidades com molho de pimenta',            1, 28.00, TRUE),   -- 1
    ('Mandioca Frita',          'Porcao individual com maionese da casa',     1, 22.00, TRUE),   -- 2
    ('Feijoada Completa',       'Serve 2 pessoas, acompanha arroz e couve',   2, 54.90, TRUE),   -- 3
    ('Moqueca de Peixe',        'Serve 2 pessoas, acompanha arroz e pirao',   2, 68.00, TRUE),   -- 4
    ('File a Parmegiana',       'Acompanha arroz e batata frita',             2, 49.90, TRUE),   -- 5
    ('Suco de Laranja',         'Copo 400 ml, natural',                       3,  9.00, TRUE),   -- 6
    ('Refrigerante Lata',       'Lata 350 ml',                                3,  7.00, TRUE),   -- 7
    ('Cerveja Long Neck',       'Long neck 330 ml',                           3, 12.00, TRUE),   -- 8
    ('Pudim de Leite',          'Fatia individual com calda de caramelo',     4, 14.00, TRUE),   -- 9
    ('Petit Gateau',            'Com sorvete de creme',                       4, 21.00, FALSE);  -- 10 (indisponivel)

-- ---------------------------------------------------------------------
-- COMANDA
-- Obs.: a mesma mesa pode ter varias comandas FECHADAS, mas apenas uma ABERTA.
-- ---------------------------------------------------------------------

-- Comandas fechadas (historico)
INSERT INTO comanda (mesa_id, funcionario_id, aberta_em, fechada_em, status, forma_pagamento, taxa_servico) VALUES
    (1, 1, '2026-11-18 12:10:00', '2026-11-18 13:20:00', 'fechada', 'pix',      TRUE),    -- 1
    (2, 1, '2026-11-18 12:30:00', '2026-11-18 13:45:00', 'fechada', 'cartao',   FALSE),   -- 2
    (3, 2, '2026-11-18 19:00:00', '2026-11-18 21:05:00', 'fechada', 'dinheiro', TRUE);    -- 3

-- Comandas abertas (em andamento)
INSERT INTO comanda (mesa_id, funcionario_id, aberta_em, status, taxa_servico) VALUES
    (4, 2, '2026-11-19 12:15:00', 'aberta', TRUE),    -- 4
    (5, 1, '2026-11-19 12:40:00', 'aberta', FALSE),   -- 5
    (1, 2, '2026-11-19 13:05:00', 'aberta', TRUE);    -- 6 (mesa 1 reutilizada)

-- ---------------------------------------------------------------------
-- ITEM_COMANDA
-- preco_unitario guarda o preco praticado no momento do pedido.
-- ---------------------------------------------------------------------

-- Comanda 1 (fechada, mesa 1)
INSERT INTO item_comanda (comanda_id, produto_id, quantidade, preco_unitario, observacao, hora_pedido, status) VALUES
    (1, 1, 1, 28.00, NULL,                   '2026-11-18 12:12:00', 'entregue'),
    (1, 3, 1, 54.90, 'Sem couve',            '2026-11-18 12:15:00', 'entregue'),
    (1, 6, 2,  9.00, NULL,                   '2026-11-18 12:15:00', 'entregue'),
    (1, 9, 2, 14.00, NULL,                   '2026-11-18 12:55:00', 'entregue');

-- Comanda 2 (fechada, mesa 2)
INSERT INTO item_comanda (comanda_id, produto_id, quantidade, preco_unitario, observacao, hora_pedido, status) VALUES
    (2, 5, 2, 49.90, 'Um sem queijo extra',  '2026-11-18 12:35:00', 'entregue'),
    (2, 7, 2,  7.00, NULL,                   '2026-11-18 12:35:00', 'entregue'),
    (2, 2, 1, 22.00, NULL,                   '2026-11-18 12:40:00', 'entregue'),
    (2, 4, 1, 68.00, NULL,                   '2026-11-18 12:50:00', 'cancelado');   -- cancelado: nao entra no total

-- Comanda 3 (fechada, mesa 3)
INSERT INTO item_comanda (comanda_id, produto_id, quantidade, preco_unitario, observacao, hora_pedido, status) VALUES
    (3, 4, 2, 68.00, 'Pimenta a parte',      '2026-11-18 19:10:00', 'entregue'),
    (3, 8, 4, 12.00, 'Bem gelada',           '2026-11-18 19:10:00', 'entregue'),
    (3, 1, 1, 28.00, NULL,                   '2026-11-18 19:12:00', 'entregue'),
    (3, 9, 3, 14.00, NULL,                   '2026-11-18 20:30:00', 'entregue');

-- Comanda 4 (aberta, mesa 4) - itens em varios estados
INSERT INTO item_comanda (comanda_id, produto_id, quantidade, preco_unitario, observacao, hora_pedido, status) VALUES
    (4, 2, 1, 22.00, NULL,                   '2026-11-19 12:18:00', 'entregue'),
    (4, 3, 1, 54.90, NULL,                   '2026-11-19 12:20:00', 'pronto'),
    (4, 8, 2, 12.00, NULL,                   '2026-11-19 12:20:00', 'entregue'),
    (4, 5, 1, 49.90, 'Ao ponto',             '2026-11-19 12:50:00', 'em_preparo');

-- Comanda 5 (aberta, mesa 5)
INSERT INTO item_comanda (comanda_id, produto_id, quantidade, preco_unitario, observacao, hora_pedido, status) VALUES
    (5, 4, 1, 68.00, NULL,                   '2026-11-19 12:45:00', 'em_preparo'),
    (5, 7, 3,  7.00, 'Uma zero acucar',      '2026-11-19 12:45:00', 'entregue'),
    (5, 1, 2, 28.00, NULL,                   '2026-11-19 12:46:00', 'pendente');

-- Comanda 6 (aberta, mesa 1)
INSERT INTO item_comanda (comanda_id, produto_id, quantidade, preco_unitario, observacao, hora_pedido, status) VALUES
    (6, 6, 2,  9.00, NULL,                   '2026-11-19 13:07:00', 'pendente'),
    (6, 5, 2, 49.90, NULL,                   '2026-11-19 13:08:00', 'pendente');

-- ---------------------------------------------------------------------
-- TESTES DE UPDATE (fluxo normal de uso)
-- ---------------------------------------------------------------------

-- Cozinha avanca o status de um item
UPDATE item_comanda
   SET status = 'pronto'
 WHERE comanda_id = 4 AND produto_id = 5;

-- Fechamento da comanda 4 (exemplo, descomente para testar)
-- UPDATE comanda
--    SET status = 'fechada', fechada_em = NOW(), forma_pagamento = 'pix'
--  WHERE comanda_id = 4;

-- ---------------------------------------------------------------------
-- TESTES DE ERRO ESPERADO
-- Descomente UM por vez: cada um deve FALHAR com o erro indicado.
-- ---------------------------------------------------------------------

-- 1) Categoria duplicada (UNIQUE nome)           -> ERROR 1062 Duplicate entry
-- INSERT INTO categoria (nome) VALUES ('Bebidas');

-- 2) Mesa com numero duplicado (UNIQUE numero)   -> ERROR 1062 Duplicate entry
-- INSERT INTO mesa (numero, lugares) VALUES (1, 4);

-- 3) E-mail de funcionario duplicado             -> ERROR 1062 Duplicate entry
-- INSERT INTO funcionario (perfil, nome, email, senha_hash)
-- VALUES ('caixa', 'Outro Nome', 'ana@sabordavila.com', 'x');

-- 4) Perfil invalido (ENUM)                      -> ERROR 1265 Data truncated (modo estrito)
-- INSERT INTO funcionario (perfil, nome, email, senha_hash)
-- VALUES ('estagiario', 'Teste', 'teste@sabordavila.com', 'x');

-- 5) Produto com categoria inexistente (FK)      -> ERROR 1452 Cannot add or update a child row
-- INSERT INTO produto (nome, categoria_id, preco_atual) VALUES ('Produto X', 99, 10.00);

-- 6) Segunda comanda ABERTA na mesma mesa        -> ERROR 1062 Duplicate entry (UNIQUE mesa_aberta)
-- INSERT INTO comanda (mesa_id, funcionario_id) VALUES (4, 1);

-- 7) Item para comanda inexistente (FK)          -> ERROR 1452
-- INSERT INTO item_comanda (comanda_id, produto_id, quantidade, preco_unitario)
-- VALUES (999, 1, 1, 28.00);

-- 8) Quantidade negativa (UNSIGNED)              -> ERROR 1264 Out of range value
-- INSERT INTO item_comanda (comanda_id, produto_id, quantidade, preco_unitario)
-- VALUES (4, 1, -1, 28.00);

-- 9) Status de item invalido (ENUM)              -> ERROR 1265 Data truncated
-- INSERT INTO item_comanda (comanda_id, produto_id, quantidade, preco_unitario, status)
-- VALUES (4, 1, 1, 28.00, 'sumiu');

-- 10) Excluir produto que ja foi pedido (FK)     -> ERROR 1451 Cannot delete or update a parent row
-- DELETE FROM produto WHERE produto_id = 1;

-- ---------------------------------------------------------------------
-- CONFERENCIA RAPIDA
-- ---------------------------------------------------------------------
SELECT 'categoria'    AS tabela, COUNT(*) AS registros FROM categoria
UNION ALL SELECT 'mesa',          COUNT(*) FROM mesa
UNION ALL SELECT 'funcionario',   COUNT(*) FROM funcionario
UNION ALL SELECT 'produto',       COUNT(*) FROM produto
UNION ALL SELECT 'comanda',       COUNT(*) FROM comanda
UNION ALL SELECT 'item_comanda',  COUNT(*) FROM item_comanda;
