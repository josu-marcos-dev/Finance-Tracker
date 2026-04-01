-- ============================================================
-- FINANCE TRACKER — Database Initialization
-- ============================================================

-- This file contains all the structure related to de data definition language (DDL)
-- DML --> Data Manipulation Language (select, insert, update, delete) 

-- ============================================================
-- Stage 3.1 and 3.2: Tables creation, and set relationships
-- ============================================================

-- 1. Accounts -- diferentes contas do mesmo usuário
CREATE TABLE accounts (
    id          SERIAL PRIMARY KEY, --Gera Ids auto-incrementais
    name        VARCHAR(100)    NOT NULL, --nome da conta
    type        VARCHAR(50)     NOT NULL CHECK (type IN ('checking', 'savings', 'credit_card', 'cash', 'investment')), -- restringe os possiveis valores a essa lista de opções
    balance     NUMERIC(15, 2)  NOT NULL DEFAULT 0.00, --numeric pois não se pode usar float por imprecisão binária, ate 15digitos c 2 decimais
    --balance é um campo q registra saldo atual q vai ser alterado automaticamnete para auxilio das funções do db
    currency    CHAR(3)         NOT NULL DEFAULT 'BRL', --tipo de moeda usada
    is_active   BOOLEAN         NOT NULL DEFAULT TRUE,
    deleted_at  TIMESTAMPTZ     NULL,
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW(), --prenche automáticamente c a data do dia semprecisar passar na query de dml depois
    updated_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW()
); --Not null ou null, são instruções para dizer se a tabela deve aceitar ou não caso o campo vier vazio, e o check serve para verificar na lista q vem depois 

-- 2. Categories --classificar transações (alimentação, transporte, trabalho)
CREATE TABLE categories (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100)    NOT NULL,
    type        VARCHAR(10)     NOT NULL CHECK (type IN ('income', 'expense')), -- tipo da transação
    color       CHAR(7)         NULL CHECK (color ~ '^#[0-9A-Fa-f]{6}$'), --adiciona cor oque vai ser útil pro futuro dashboard
    icon        VARCHAR(50)     NULL, -- nomeclatura para o icone desse gasto no dashboard
    is_active   BOOLEAN         NOT NULL DEFAULT TRUE,
    deleted_at  TIMESTAMPTZ     NULL,
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW()
); --char (sempre valor fxo definido), varchar (sempre valor variável), text(tamanho ilimitado) 

-- 3. Transactions -- cada movimentação de dinheiro que aconteceu
CREATE TABLE transactions (
    id              SERIAL PRIMARY KEY,
    account_id      INTEGER         NOT NULL REFERENCES accounts(id) ON DELETE RESTRICT, -- restrict blqueia o delete, pode ser cascade (deleta os filhos junto) ou SET NULL (coloca null no campo) em vez disso tb
--trecho de refrencia:nome da coluna atual + tipo + se deve ou não ser null + nome da coluna q vai refrenciar (ou seja, o id de table acconts)+ comportamento caso algume tente deletar 
    category_id     INTEGER         NULL     REFERENCES categories(id) ON DELETE SET NULL,
    amount          NUMERIC(15, 2)  NOT NULL CHECK (amount > 0),
    type            VARCHAR(10)     NOT NULL CHECK (type IN ('income', 'expense', 'transfer')), --> tipo de transação 
    description     VARCHAR(255)    NULL,
    notes           TEXT            NULL,
    transaction_date DATE           NOT NULL, --date = só o dia
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,
    deleted_at      TIMESTAMPTZ     NULL, --timestamptz = dia + hora + fuso
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- 4. Tags - rótulos livres, uma transação pode ter várias tags, e diferentes transações podem ter as mesmas tags, tipo (viajem, carro, etc)
CREATE TABLE tags (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(50)     NOT NULL UNIQUE,
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- 5. Transaction <-> Tag (N:N) -- ponte de conexão entre transactions e tags
CREATE TABLE transaction_tags (
    transaction_id  INTEGER NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    tag_id          INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (transaction_id, tag_id)
);

-- 6. Budgets -- orçamento planejado por categoria por mes, tudo planejado
CREATE TABLE budgets (
    id              SERIAL PRIMARY KEY,
    category_id     INTEGER         NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    amount          NUMERIC(15, 2)  NOT NULL CHECK (amount > 0),
    period_month    SMALLINT        NOT NULL CHECK (period_month BETWEEN 1 AND 12),
    period_year     SMALLINT        NOT NULL CHECK (period_year >= 2000),
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    UNIQUE (category_id, period_month, period_year)
);

-- 7. Recurring Transactions
CREATE TABLE recurring_transactions (
    id              SERIAL PRIMARY KEY,
    account_id      INTEGER         NOT NULL REFERENCES accounts(id) ON DELETE RESTRICT,
    category_id     INTEGER         NULL     REFERENCES categories(id) ON DELETE SET NULL,
    amount          NUMERIC(15, 2)  NOT NULL CHECK (amount > 0),
    type            VARCHAR(10)     NOT NULL CHECK (type IN ('income', 'expense')),
    description     VARCHAR(255)    NOT NULL,
    frequency       VARCHAR(20)     NOT NULL CHECK (frequency IN ('daily', 'weekly', 'monthly', 'yearly')),
    start_date      DATE            NOT NULL,
    end_date        DATE            NULL,
    next_due_date   DATE            NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- 8. Audit Log -- historico de tudo que aconteceu no sistema 
CREATE TABLE audit_log ( 
    id              BIGSERIAL PRIMARY KEY,
    table_name      VARCHAR(50)     NOT NULL,
    record_id       INTEGER         NOT NULL,
    action          VARCHAR(10)     NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    old_data        JSONB           NULL,
    new_data        JSONB           NULL, --JSONB = jason em formato binário otimizado
    changed_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- ============================================================
-- Stage 3.3: Indexes -- summary for eficient research 
-- ============================================================

-- ===========
-- accounts
-- ===========
CREATE INDEX idx_accounts_deleted_at        ON accounts(deleted_at); 
-- Soft delete: buscar só contas ativas vai ser frequente

-- ===========
-- categories
-- ===========
CREATE INDEX idx_categories_type            ON categories(type); 
-- Filtrar por tipo (income/expense) nas telas de cadastro de transação
CREATE INDEX idx_categories_deleted_at      ON categories(deleted_at); 
-- Soft delete

-- =============
-- transactions
-- =============
-- Relatório mensal: filtro por data é a query mais comum do sistema
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
-- Filtro por conta: "todas as transações do Nubank"
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
-- Filtro por categoria: "quanto gastei em alimentação"
CREATE INDEX idx_transactions_category_id ON transactions(category_id);
-- Soft delete
CREATE INDEX idx_transactions_deleted_at ON transactions(deleted_at);
-- Índice composto: relatório mensal por conta (as duas colunas juntas numa query)
-- mais eficiente que dois índices separados quando o WHERE usa as duas
CREATE INDEX idx_transactions_account_date ON transactions(account_id, transaction_date);

-- ===========
-- budgets
-- ===========
CREATE INDEX idx_budgets_period             ON budgets(period_year, period_month);
-- Consulta de orçamento do mês atual: sempre filtra por mês e ano

-- ========================
-- recurring_transactions
-- ========================
CREATE INDEX idx_recurring_next_due         ON recurring_transactions(next_due_date);
-- O job que gera transações automáticas vai filtrar por next_due_date todo dia
CREATE INDEX idx_recurring_active           ON recurring_transactions(is_active);
-- Filtrar só as ativas

-- ===========
-- audit_log
-- ===========
CREATE INDEX idx_audit_table_record         ON audit_log(table_name, record_id);
-- Buscar histórico de um registro específico: "o que mudou na transação 42?"
CREATE INDEX idx_audit_changed_at           ON audit_log(changed_at);
-- Buscar por período de tempo

-- ===========
-- tags
-- ===========
CREATE INDEX idx_tags_name                  ON tags(name);
-- Busca de tag por nome (autocomplete futuro)
CREATE INDEX idx_transaction_tags_tag_id    ON transaction_tags(tag_id);
-- transaction_tags já tem PK composta (transaction_id, tag_id)
-- o PostgreSQL cria índice automático na PK, não precisa criar manualmente
-- mas vale criar o inverso pra busca "quais transações têm essa tag?"