USE sabor_da_vila;

-- Perfis de acesso
INSERT INTO perfis (nome, descricao) VALUES
('gerente', 'Acesso total, cadastros, cancelamentos e relatórios'),
('garcom', 'Abre comandas e lança itens nas próprias comandas'),
('cozinha', 'Visualiza fila de pedidos e atualiza status de preparo'),
('caixa', 'Visualiza comandas abertas e realiza fechamento/pagamento');

-- Funcionários (senha de teste em hash bcrypt fictício para exemplo: "123456")
INSERT INTO funcionarios (nome, email, senha_hash, perfil_id, ativo) VALUES
('Dona Célia', 'celia@sabordavila.com', '$2b$10$ExemploHashGerente12345678901234567890123456789012345', 1, TRUE),
('Carlos Silva', 'carlos@sabordavila.com', '$2b$10$ExemploHashGarcom112345678901234567890123456789012345', 2, TRUE),
('Mariana Souza', 'mariana@sabordavila.com', '$2b$10$ExemploHashGarcom212345678901234567890123456789012345', 2, TRUE),
('João Pedro', 'joao@sabordavila.com', '$2b$10$ExemploHashCozinha12345678901234567890123456789012345', 3, TRUE),
('Fernanda Lima', 'fernanda@sabordavila.com', '$2b$10$ExemploHashCaixa123456789012345678901234567890123456', 4, TRUE);

-- Mesas (ID representa o número da mesa)
INSERT INTO mesas (lugares) VALUES
(4), (4), (2), (6), (4), (8);

-- Categorias
INSERT INTO categorias (nome) VALUES
('Entradas'),
('Pratos Principais'),
('Bebidas'),
('Sobremesas'),
('Porções');

-- Produtos
INSERT INTO produtos (nome, descricao, categoria_id, preco_atual, disponivel) VALUES
('Bolinho de Bacalhau', 'Porção com 6 unidades crocantes', 1, 32.00, TRUE),
('Parmegiana de Filé', 'Acompanha arroz e fritas', 2, 58.90, TRUE),
('Feijoada Completa', 'Serve 2 pessoas', 2, 89.90, TRUE),
('Suco de Laranja 500ml', 'Natural da fruta', 3, 12.00, TRUE),
('Refrigerante Lata', '350ml', 3, 7.50, TRUE),
('Pudim de Leite', 'Fatia generosa com calda de caramelo', 4, 15.00, TRUE),
('Batata Frita Especial', 'Com cheddar e bacon', 5, 35.00, FALSE);

-- Comandas (abertas e fechadas no mês atual)
INSERT INTO comandas (mesa_id, garcom_id, data_abertura, data_fechamento, status, forma_pagamento, taxa_servico) VALUES
(1, 2, NOW() - INTERVAL 2 DAY, NOW() - INTERVAL 2 DAY + INTERVAL 1 HOUR, 'fechada', 'cartao', TRUE),
(2, 3, NOW() - INTERVAL 2 DAY, NOW() - INTERVAL 2 DAY + INTERVAL 2 HOUR, 'fechada', 'pix', TRUE),
(3, 2, NOW() - INTERVAL 1 DAY, NOW() - INTERVAL 1 DAY + INTERVAL 1 HOUR, 'fechada', 'dinheiro', FALSE),
(4, 3, NOW() - INTERVAL 1 HOUR, NULL, 'aberta', NULL, FALSE),
(5, 2, NOW() - INTERVAL 30 MINUTE, NULL, 'aberta', NULL, FALSE);

-- Itens da Comanda
INSERT INTO itens_comanda (comanda_id, produto_id, quantidade, preco_unitario, observacao, hora_pedido, status) VALUES
(1, 1, 1, 32.00, NULL, NOW() - INTERVAL 2 DAY, 'entregue'),
(1, 2, 2, 58.90, 'Sem cebola', NOW() - INTERVAL 2 DAY, 'entregue'),
(1, 4, 2, 12.00, 'Com gelo e limão', NOW() - INTERVAL 2 DAY, 'entregue'),
(2, 3, 1, 89.90, NULL, NOW() - INTERVAL 2 DAY, 'entregue'),
(2, 6, 2, 15.00, NULL, NOW() - INTERVAL 2 DAY, 'entregue'),
(3, 2, 1, 58.90, NULL, NOW() - INTERVAL 1 DAY, 'entregue'),
(3, 5, 1, 7.50, NULL, NOW() - INTERVAL 1 DAY, 'cancelado'),
(4, 1, 1, 32.00, 'Bem passado', NOW() - INTERVAL 40 MINUTE, 'em preparo'),
(4, 4, 2, 12.00, 'Sem açúcar', NOW() - INTERVAL 35 MINUTE, 'pronto'),
(5, 2, 1, 58.90, 'Molho à parte', NOW() - INTERVAL 15 MINUTE, 'pendente');