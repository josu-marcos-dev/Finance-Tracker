#ENDPOINTS 

#ENDPOINTS TRANSACTIONS
POST /transactions → criar transação
GET /transactions → listar todas
GET /transactions/{id} → pegar específica
PUT /transactions/{id} → atualizar
DELETE /transactions/{id} → deletar

#FILTROS E CONSULTAS
GET /transactions/by-date → transações por dia
GET /transactions/by-period → por intervalo (ex: mês)
GET /transactions/by-category → por categoria
GET /transactions/by-type → receitas ou despesas

#SALDO
GET /balance → saldo atual
GET /balance/by-date → saldo em uma data específica
GET /balance/by-period → saldo em intervalo

#RELATÓRIOS
GET /reports/monthly → relatório mensal
GET /reports/daily → relatório diário
GET /reports/by-category → gastos por categoria
GET /reports/income-vs-expense → comparação receita vs despesa

#CATEGORIAS
POST /categories
GET /categories
PUT /categories/{id}
DELETE /categories/{id}

#USUÁRIOS
POST /auth/register
POST /auth/login
GET /users/me

#ANÁLISES
GET /insights → análises automáticas (tipo “vc gastou +30% esse mês”)
GET /forecast → previsão de saldo