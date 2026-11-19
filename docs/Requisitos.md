# Requisitos do Sistema - Sabor da Vila

## Requisitos funcionais

| Código | Perfil | Requisito |
|--------|--------|-----------|
| RF01 | Todos | Login com e-mail e senha (só funcionário ativo entra) |
| RF02 | Gerente | Cadastrar funcionários (nome, e-mail, senha, perfil, ativo/inativo) |
| RF03 | Gerente | Cadastrar mesas, categorias e produtos; alterar preços e disponibilidade |
| RF04 | Garçom | Abrir comanda para uma mesa |
| RF05 | Garçom | Lançar itens nas comandas que ele abriu (produto, quantidade, observação) |
| RF06 | Garçom | Ver o status dos itens das suas comandas |
| RF07 | Cozinha | Ver a fila de itens pendentes em ordem de chegada |
| RF08 | Cozinha | Mudar o status do item (em preparo, pronto) |
| RF09 | Gerente | Cancelar itens |
| RF10 | Sistema | Calcular o total da comanda (sem itens cancelados) |
| RF11 | Caixa | Ver todas as comandas abertas e consultar a conta de cada mesa (itens, quantidades, valores e total) antes de fechar |
| RF12 | Caixa | Fechar a comanda com forma de pagamento (dinheiro, cartão, PIX) e taxa de serviço de 10% (sim/não) |
| RF13 | Gerente, Cozinha | Relatório: fila da cozinha (sem valores para a cozinha) |
| RF14 | Caixa, Gerente | Relatório: conta de uma mesa (comanda aberta) |
| RF15 | Gerente | Relatório: 10 produtos mais vendidos do mês, com categoria |
| RF16 | Gerente | Relatório: faturamento por dia e por forma de pagamento |
| RF17 | Gerente | Relatório: comandas atendidas por garçom no mês |

## Requisitos não funcionais

- **RNF01:** senha guardada com hash, nunca em texto puro.
- **RNF02:** integridade referencial (chaves estrangeiras).
- **RNF03:** valores monetários em `DECIMAL`.
- **RNF04:** índices para a fila da cozinha e os relatórios.

## Regras de negócio

- **RN01:** uma mesa só pode ter uma comanda aberta por vez.
- **RN02:** uma comanda tem vários itens, e o mesmo produto aparece em várias comandas.
- **RN03:** cada produto pertence a uma única categoria.
- **RN04:** o preço cobrado fica registrado no item, e mudar o preço do produto não altera comandas antigas.
- **RN05:** produto indisponível não pode ser lançado em comanda.
- **RN06:** item cancelado não é apagado, muda de status e não entra no total.
- **RN07:** o número da mesa não se repete.
- **RN08:** o e-mail do funcionário não se repete.

### Permissões

- **RN09:** o garçom não fecha comanda, não cancela item já enviado à cozinha e não altera o cardápio.
- **RN10:** a cozinha não vê valores e não lança nem cancela itens.
- **RN11:** o caixa vê valores e a conta das mesas, mas não altera cardápio nem preços.
- **RN12:** o gerente faz tudo o que os outros fazem, mais cadastros, preços, cancelamentos e relatórios.

### Derivadas - decisão do grupo

- **RN13:** comanda fechada não aceita novos itens.
- **RN14:** quantidade do item deve ser maior que zero.
- **RN15:** total = soma de quantidade × preço unitário dos itens não cancelados, mais 10% se houver taxa. É calculado, não armazenado, e o caixa vê esse mesmo total antes de fechar.
- **RN16:** o garçom que abre a comanda deve ter perfil Garçom.
- **RN17:** a fila da cozinha mostra só itens pendentes ou em preparo, do mais antigo para o mais recente.
- **RN18:** clientes do restaurante não são cadastrados.