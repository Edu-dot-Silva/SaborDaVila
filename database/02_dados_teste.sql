-- =====================================================================
-- Sabor da Vila - Dados de teste
-- Rodar depois do 01_criacao.sql:
--   mysql -u root -p sabor_da_vila < 02_dados_teste.sql
-- Todos os funcionários usam a senha de teste: 123456
-- (o hash abaixo é bcrypt; no back-end gere o hash com a lib bcrypt)
-- =====================================================================
USE sabor_da_vila;

-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- FUNCIONÁRIOS: 1 gerente, 4 garçons, 1 caixa, 3 cozinha (+1 garçom inativo)
-- ---------------------------------------------------------------------
INSERT INTO funcionario (funcionario_id, perfil, nome, email, senha_hash, ativo) VALUES
('gerente',  'Célia Andrade',    'celia@sabordavila.com',    '$2b$10$6Epso9SQJ85K80kR2gzipuLv2xKpQ7yWuDdlno.q5hu2DyC9g2hKK', TRUE),
('garcom', 'Bruno Martins',    'bruno@sabordavila.com',    '$2b$10$6Epso9SQJ85K80kR2gzipuLv2xKpQ7yWuDdlno.q5hu2DyC9g2hKK', TRUE),
('garcom', 'Carla Souza',      'carla@sabordavila.com',    '$2b$10$6Epso9SQJ85K80kR2gzipuLv2xKpQ7yWuDdlno.q5hu2DyC9g2hKK', TRUE),
('garcom', 'Diego Lima',       'diego@sabordavila.com',    '$2b$10$6Epso9SQJ85K80kR2gzipuLv2xKpQ7yWuDdlno.q5hu2DyC9g2hKK', TRUE),
('garcom', 'Elisa Rocha',      'elisa@sabordavila.com',    '$2b$10$6Epso9SQJ85K80kR2gzipuLv2xKpQ7yWuDdlno.q5hu2DyC9g2hKK', TRUE),
('caixa', 'Fátima Gomes',     'fatima@sabordavila.com',   '$2b$10$6Epso9SQJ85K80kR2gzipuLv2xKpQ7yWuDdlno.q5hu2DyC9g2hKK', TRUE),
('cozinha', 'Gustavo Pires',    'gustavo@sabordavila.com',  '$2b$10$6Epso9SQJ85K80kR2gzipuLv2xKpQ7yWuDdlno.q5hu2DyC9g2hKK', TRUE),
('cozinha', 'Helena Costa',     'helena@sabordavila.com',   '$2b$10$6Epso9SQJ85K80kR2gzipuLv2xKpQ7yWuDdlno.q5hu2DyC9g2hKK', TRUE),
('cozinha', 'Igor Ferreira',    'igor@sabordavila.com',     '$2b$10$6Epso9SQJ85K80kR2gzipuLv2xKpQ7yWuDdlno.q5hu2DyC9g2hKK', TRUE),
('garcom', 'Joana Barbosa',    'joana@sabordavila.com',    '$2b$10$6Epso9SQJ85K80kR2gzipuLv2xKpQ7yWuDdlno.q5hu2DyC9g2hKK', FALSE);

-- ---------------------------------------------------------------------
-- MESAS: 15 mesas
-- ---------------------------------------------------------------------
INSERT INTO mesa (lugares) VALUES
(2),  (2),  (4),  (4),  (4),
(4),  (6),  (6),  (2),  (4),
(4), (6), (8), (8), (10);

-- ---------------------------------------------------------------------
-- CATEGORIAS
-- ---------------------------------------------------------------------
INSERT INTO categoria (categoria_id, nome) VALUES
(1, 'Entradas'),
(2, 'Pratos principais'),
(3, 'Bebidas'),
(4, 'Sobremesas');

-- ---------------------------------------------------------------------
-- PRODUTOS (amostra do cardápio de ~40 itens). O id 9 está indisponível.
-- ---------------------------------------------------------------------
INSERT INTO produto (produto_id, nome, descricao, categoria_id, preco_atual, disponivel) VALUES
(1,  'Bruschetta',               'Pão italiano, tomate, manjericão e azeite',   1, 22.00, TRUE),
(2,  'Pastel de queijo',         'Porção com 6 unidades',                       1, 18.00, TRUE),
(3,  'Caldo verde',              'Batata, couve e calabresa',                   1, 16.00, TRUE),
(4,  'Salada caprese',           'Tomate, muçarela de búfala e manjericão',     1, 24.00, TRUE),
(5,  'Filé à parmegiana',        'Filé empanado com queijo e molho, arroz e fritas', 2, 58.00, TRUE),
(6,  'Frango grelhado',          'Peito de frango, arroz, feijão e salada',     2, 42.00, TRUE),
(7,  'Feijoada individual',      'Feijoada completa com acompanhamentos',       2, 46.00, TRUE),
(8,  'Risoto de cogumelos',      'Arroz arbóreo com mix de cogumelos',          2, 54.00, TRUE),
(9,  'Spaghetti à bolonhesa',    'Massa com molho de carne',                    2, 38.00, FALSE),
(10, 'Refrigerante lata',        '350 ml',                                      3,  7.00, TRUE),
(11, 'Suco natural',             'Laranja, limão ou maracujá',                  3, 12.00, TRUE),
(12, 'Água mineral',             '500 ml',                                      3,  5.00, TRUE),
(13, 'Cerveja long neck',        '355 ml',                                      3, 14.00, TRUE),
(14, 'Pudim de leite',           'Fatia com calda de caramelo',                 4, 14.00, TRUE),
(15, 'Petit gâteau',             'Com sorvete de creme',                        4, 22.00, TRUE),
(16, 'Mousse de maracujá',       NULL,                                          4, 12.00, TRUE);


