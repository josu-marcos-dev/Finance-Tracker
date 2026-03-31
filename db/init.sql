-- ============================================================
-- FINANCE TRACKER — Database Initialization
-- ============================================================

-- ============================================================
-- Stage 3.1: Tables creation
-- ============================================================

-- 1. Accounts
CREATE TABLE accounts (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100)    NOT NULL,
    type        VARCHAR(50)     NOT NULL CHECK (type IN ('checking', 'savings', 'credit_card', 'cash', 'investment')),
    balance     NUMERIC(15, 2)  NOT NULL DEFAULT 0.00,
    currency    CHAR(3)         NOT NULL DEFAULT 'BRL',
    is_active   BOOLEAN         NOT NULL DEFAULT TRUE,
    deleted_at  TIMESTAMPTZ     NULL,
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- 2. Categories
CREATE TABLE categories (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100)    NOT NULL,
    type        VARCHAR(10)     NOT NULL CHECK (type IN ('income', 'expense')),
    color       CHAR(7)         NULL CHECK (color ~ '^#[0-9A-Fa-f]{6}$'),
    icon        VARCHAR(50)     NULL,
    is_active   BOOLEAN         NOT NULL DEFAULT TRUE,
    deleted_at  TIMESTAMPTZ     NULL,
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- 3. Transactions
CREATE TABLE transactions (
    id              SERIAL PRIMARY KEY,
    account_id      INTEGER         NOT NULL REFERENCES accounts(id) ON DELETE RESTRICT,
    category_id     INTEGER         NULL     REFERENCES categories(id) ON DELETE SET NULL,
    amount          NUMERIC(15, 2)  NOT NULL CHECK (amount > 0),
    type            VARCHAR(10)     NOT NULL CHECK (type IN ('income', 'expense', 'transfer')),
    description     VARCHAR(255)    NULL,
    notes           TEXT            NULL,
    transaction_date DATE           NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,
    deleted_at      TIMESTAMPTZ     NULL,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- 4. Tags
CREATE TABLE tags (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(50)     NOT NULL UNIQUE,
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- 5. Transaction <-> Tag (N:N)
CREATE TABLE transaction_tags (
    transaction_id  INTEGER NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    tag_id          INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (transaction_id, tag_id)
);

-- 6. Budgets
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

-- 8. Audit Log
CREATE TABLE audit_log (
    id              BIGSERIAL PRIMARY KEY,
    table_name      VARCHAR(50)     NOT NULL,
    record_id       INTEGER         NOT NULL,
    action          VARCHAR(10)     NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    old_data        JSONB           NULL,
    new_data        JSONB           NULL,
    changed_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- ============================================================
-- Stage 3.3: Indexes
-- ============================================================