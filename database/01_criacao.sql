-- Sabor da Vila

CREATE DATABASE sabor_da_vila;

USE sabor_da_vila;

-- TABELAS


CREATE TABLE categoria (
    categoria_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    PRIMARY KEY (categoria_id),
    UNIQUE (nome)
);

CREATE TABLE mesa (
    mesa_id INT UNSIGNED NOT NULL AUTO_INCREMENT,                
    lugares INT UNSIGNED  NOT NULL,
    PRIMARY KEY (mesa_id)
);

CREATE TABLE funcionario (
    funcionario_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    perfil ENUM('garcom', 'cozinha', 'caixa', 'gerente') NOT NULL,
    nome VARCHAR(180) NOT NULL,
    email VARCHAR(200) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (funcionario_id),
    UNIQUE (email)
);



CREATE TABLE produto (
    produto_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    categoria_id INT UNSIGNED NOT NULL,
    preco_atual DECIMAL(10,2) NOT NULL,
    disponivel BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (produto_id),
    UNIQUE (nome),
    FOREIGN KEY (categoria_id) REFERENCES categoria (categoria_id)
);

CREATE TABLE comanda (
    comanda_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    mesa_id INT UNSIGNED NOT NULL,
    funcionario_id INT UNSIGNED NOT NULL,           
    aberta_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fechada_em DATETIME,
    status ENUM('aberta','fechada') NOT NULL DEFAULT 'aberta',
    forma_pagamento ENUM('dinheiro','cartao','pix'),
    taxa_servico BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (comanda_id),
    FOREIGN KEY (mesa_id)   REFERENCES mesa (mesa_id),
    FOREIGN KEY (funcionario_id) REFERENCES funcionario (funcionario_id)
);

CREATE TABLE item_comanda (
    item_comanda_id INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    comanda_id INT UNSIGNED NOT NULL,
    produto_id INT UNSIGNED NOT NULL,
    quantidade INT UNSIGNED NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    observacao VARCHAR(255),
    hora_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pendente','em_preparo','pronto','entregue','cancelado') NOT NULL DEFAULT 'pendente',        
    PRIMARY KEY (item_comanda_id),
    FOREIGN KEY (comanda_id) REFERENCES comanda (comanda_id),
    FOREIGN KEY (produto_id) REFERENCES produto (produto_id)
);

/*


-- ---------------------------------------------------------------------
-- ÍNDICES (RNF04)
-- ---------------------------------------------------------------------
-- Fila da cozinha: filtra por status e ordena por hora do pedido (RN17)
CREATE INDEX idx_item_status_hora   ON item_comanda (status, hora_pedido);
-- Itens de uma comanda / vendas por produto
CREATE INDEX idx_item_comanda       ON item_comanda (comanda_id);
CREATE INDEX idx_item_produto       ON item_comanda (produto_id);
-- Relatórios mensais e faturamento diário
CREATE INDEX idx_comanda_fechamento ON comanda (status, fechada_em);
CREATE INDEX idx_comanda_garcom     ON comanda (garcom_id, fechada_em);
CREATE INDEX idx_comanda_mesa       ON comanda (mesa_id);

-- ---------------------------------------------------------------------
-- TRIGGERS (regras que o DER não expressa)
-- ---------------------------------------------------------------------
DELIMITER $$

-- RN16: quem abre a comanda deve ser funcionário ATIVO com perfil Garçom
CREATE TRIGGER trg_comanda_bi
BEFORE INSERT ON comanda
FOR EACH ROW
BEGIN
    DECLARE v_ok INT DEFAULT 0;

    SELECT COUNT(*) INTO v_ok
      FROM funcionario f
      JOIN perfil p ON p.id = f.perfil_id
     WHERE f.id = NEW.garcom_id
       AND f.ativo = TRUE
       AND p.nome = 'Garçom';

    IF v_ok = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN16: a comanda só pode ser aberta por um garçom ativo';
    END IF;
END$$

-- RN13 (comanda fechada não é alterada) e fechamento só sem itens em andamento
CREATE TRIGGER trg_comanda_bu
BEFORE UPDATE ON comanda
FOR EACH ROW
BEGIN
    DECLARE v_em_andamento INT DEFAULT 0;

    IF OLD.status = 'fechada' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN13: comanda fechada não pode ser alterada nem reaberta';
    END IF;

    IF NEW.status = 'fechada' THEN
        SELECT COUNT(*) INTO v_em_andamento
          FROM item_comanda
         WHERE comanda_id = OLD.id
           AND status IN ('pendente', 'em_preparo');

        IF v_em_andamento > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Não é possível fechar: há itens pendentes ou em preparo';
        END IF;

        IF NEW.fechada_em IS NULL THEN
            SET NEW.fechada_em = NOW();
        END IF;
    END IF;
END$$

-- RN13: comanda fechada não aceita itens | RN05: produto indisponível não é lançado
-- RN04: copia o preço atual do produto quando o preço não é informado
CREATE TRIGGER trg_item_bi
BEFORE INSERT ON item_comanda
FOR EACH ROW
BEGIN
    DECLARE v_status_comanda VARCHAR(10);
    DECLARE v_disponivel     BOOLEAN;
    DECLARE v_preco          DECIMAL(10,2);

    SELECT status INTO v_status_comanda FROM comanda WHERE id = NEW.comanda_id;
    IF v_status_comanda <> 'aberta' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN13: comanda fechada não aceita novos itens';
    END IF;

    SELECT disponivel, preco_atual INTO v_disponivel, v_preco
      FROM produto WHERE id = NEW.produto_id;
    IF v_disponivel = FALSE THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN05: produto indisponível não pode ser lançado';
    END IF;

    IF NEW.preco_unitario = 0 THEN
        SET NEW.preco_unitario = v_preco;
    END IF;
END$$

-- Item: preço não muda depois de lançado (RN04) e fluxo de status válido
--   pendente -> em_preparo -> pronto -> entregue ; cancelado a partir de qualquer um, menos entregue
-- Quem pode executar cada transição (cozinha, garçom, gerente) é controlado no back-end.
CREATE TRIGGER trg_item_bu
BEFORE UPDATE ON item_comanda
FOR EACH ROW
BEGIN
    IF NEW.preco_unitario <> OLD.preco_unitario THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN04: o preço cobrado no item não pode ser alterado';
    END IF;

    IF NEW.status <> OLD.status THEN
        IF NOT (
               (OLD.status = 'pendente'   AND NEW.status IN ('em_preparo', 'cancelado'))
            OR (OLD.status = 'em_preparo' AND NEW.status IN ('pronto', 'cancelado'))
            OR (OLD.status = 'pronto'     AND NEW.status IN ('entregue', 'cancelado'))
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Transição de status do item inválida';
        END IF;
    END IF;
END$$

-- Item não é apagado (RN06): cancelar = mudar status
CREATE TRIGGER trg_item_bd
BEFORE DELETE ON item_comanda
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'RN06: item não é apagado, use o status cancelado';
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- VIEW: total da comanda (RN15) - calculado, nunca armazenado
-- subtotal = soma(qtd x preço) dos itens NÃO cancelados
-- total    = subtotal + 10% quando taxa_servico = TRUE
-- ---------------------------------------------------------------------
CREATE VIEW vw_total_comanda AS
SELECT
    c.id                                                    AS comanda_id,
    c.mesa_id,
    c.garcom_id,
    c.status,
    c.forma_pagamento,
    c.fechada_em,
    c.taxa_servico,
    COALESCE(SUM(i.quantidade * i.preco_unitario), 0)       AS subtotal,
    ROUND(COALESCE(SUM(i.quantidade * i.preco_unitario), 0)
          * IF(c.taxa_servico, 0.10, 0), 2)                 AS valor_taxa,
    ROUND(COALESCE(SUM(i.quantidade * i.preco_unitario), 0)
          * IF(c.taxa_servico, 1.10, 1), 2)                 AS total
FROM comanda c
LEFT JOIN item_comanda i
       ON i.comanda_id = c.id
      AND i.status <> 'cancelado'
GROUP BY c.id, c.mesa_id, c.garcom_id, c.status, c.forma_pagamento,
         c.fechada_em, c.taxa_servico;



*/