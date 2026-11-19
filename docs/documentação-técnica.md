# Documentação Técnica — Restaurante Sabor da Vila

## 1. Visão Geral
- **Sistema:** Sabor da Vila (Gestão de Comandas e Pedidos)
- **SGBD:** MySQL 8 (XAMPP)
- **Nome do Banco:** `sabor_da_vila`
- **Quantidade de Tabelas:** 7

Banco de dados relacional para controle de mesas, cardápio, comandas, fila da cozinha e faturamento do restaurante. Apenas funcionários possuem acesso autenticado com e-mail e senha (RBAC em 4 perfis). Clientes não são cadastrados.

---

## 2. Dicionário de Dados



### Tabela `funcionarios`
| Coluna | Tipo | Nulo? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| id | INT AUTO_INCREMENT | Não | PK | Identificador do funcionário |
| perfil | ENUM | Não | - | Cargo do funcionário
| nome | VARCHAR(100) | Não | - | Nome completo |
| email | VARCHAR(100) | Não | UNIQUE | Login único do funcionário |
| senha_hash | VARCHAR(255) | Não | - | Senha criptografada com bcrypt |
| perfil_id | INT | Não | FK → perfis.id | Função ocupada pelo funcionário |
| ativo | BOOLEAN | Não | - | TRUE = ativo; FALSE = desativado (soft delete) |

### Tabela `mesas`
| Coluna | Tipo | Nulo? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| id | INT AUTO_INCREMENT | Não | PK | Número/identificador único da mesa |
| lugares | INT | Não | - | Capacidade de pessoas na mesa |

### Tabela `categorias`
| Coluna | Tipo | Nulo? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| id | INT AUTO_INCREMENT | Não | PK | Identificador da categoria |
| nome | VARCHAR(50) | Não | UNIQUE | Nome da categoria (ex.: Entradas, Bebidas) |

### Tabela `produtos`
| Coluna | Tipo | Nulo? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| id | INT AUTO_INCREMENT | Não | PK | Identificador do produto |
| nome | VARCHAR(100) | Não | - | Nome do prato ou bebida |
| descricao | TEXT | Sim | - | Detalhes e ingredientes |
| categoria_id | INT | Não | FK → categorias.id | Categoria do produto |
| preco_atual | DECIMAL(10,2) | Não | - | Preço vigente no cardápio |
| disponivel | BOOLEAN | Não | - | Indica se o item pode ser pedido no momento |

### Tabela `comandas`
| Coluna | Tipo | Nulo? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| id | INT AUTO_INCREMENT | Não | PK | Identificador da comanda |
| mesa_id | INT | Não | FK → mesas.id | Mesa vinculada à comanda |
| garcom_id | INT | Não | FK → funcionarios.id | Funcionário que abriu a comanda (dono do registro) |
| data_abertura | DATETIME | Não | - | Data e hora de abertura |
| data_fechamento | DATETIME | Sim | - | Data e hora de fechamento (NULL se aberta) |
| status | ENUM | Não | - | `aberta` ou `fechada` |
| forma_pagamento | ENUM | Sim | - | `dinheiro`, `cartao` ou `pix` |
| taxa_servico | BOOLEAN | Não | - | Indica cobrança dos 10% de serviço |

### Tabela `itens_comanda`
| Coluna | Tipo | Nulo? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| id | INT AUTO_INCREMENT | Não | PK | Identificador do item lançado |
| comanda_id | INT | Não | FK → comandas.id | Comanda à qual o item pertence |
| produto_id | INT | Não | FK → produtos.id | Produto pedido |
| quantidade | INT | Não | - | Quantidade solicitada |
| preco_unitario | DECIMAL(10,2) | Não | - | Preço congelado no momento do pedido (RN04) |
| observacao | VARCHAR(255) | Sim | - | Ex.: "sem cebola", "bem passado" |
| hora_pedido | DATETIME | Não | - | Horário exato para ordenação da fila da cozinha |
| status | ENUM | Não | - | `pendente`, `em preparo`, `pronto`, `entregue`, `cancelado` |

---

## 3. Matriz de Permissões

| Ação | Garçom | Cozinha | Caixa | Gerente |
| :--- | :---: | :---: | :---: | :---: |
| Abrir comanda para mesa | Sim | Não | Não | Sim |
| Lançar itens na comanda | Sim, só nas dele | Não | Não | Sim |
| Ver status dos itens | Sim, só nas dele | Sim (fila) | Sim | Sim |
| Mudar status do item (em preparo/pronto) | Não | Sim | Não | Sim |
| Ver valores das comandas | Sim, só nas dele | Não | Sim | Sim |
| Fechar comanda e registrar pagamento | Não | Não | Sim | Sim |
| Cancelar item lançado | Não | Não | Não | Sim |
| Cadastrar/alterar produtos, categorias e preços | Não | Não | Não | Sim |
| Cadastrar/desativar funcionários | Não | Não | Não | Sim |
| Ver relatórios gerenciais | Não | Não | Não | Sim |

