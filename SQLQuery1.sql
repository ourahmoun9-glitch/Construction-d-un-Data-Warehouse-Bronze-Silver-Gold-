CREATE DATABASE DataWarehouse;

USE DataWarehouse;

CREATE SCHEMA bronze;

CREATE SCHEMA silver;

CREATE SCHEMA gold;

SELECT name FROM sys.schemas;

CREATE TABLE bronze.transactions (
    transaction_id INT,
    transaction_date DATE,
    store_code VARCHAR(20),
    account_number INT,
    amount_local FLOAT,
    currency VARCHAR(10),
    document_number VARCHAR(50),
    description VARCHAR(255)
);



CREATE TABLE bronze.account (
    account_number  NVARCHAR(50),
    account_name    NVARCHAR(255),
    account_type    NVARCHAR(100),
    currency        NVARCHAR(10)
);
 
CREATE TABLE bronze.account_mapping (
    AccountNumber   NVARCHAR(50),
    AccountName     NVARCHAR(255),
    PLLine          NVARCHAR(255),
    StatementType   NVARCHAR(100),
    SortOrder       NVARCHAR(50),
    Notes           NVARCHAR(MAX)
);
 
CREATE TABLE bronze.store (
    store_code  NVARCHAR(20),
    country     NVARCHAR(100),
    region      NVARCHAR(100)
);
 
CREATE TABLE bronze.store_master (
    store_code  NVARCHAR(20),
    store_name  NVARCHAR(255),
    store_type  NVARCHAR(100)
);

--transactions
BULK INSERT bronze.transactions
FROM 'C:\Users\HUAWEI MATEBOOK\Desktop\Simplon\Construction d’un Data Warehouse (Bronze → Silver → Gold)\transaction.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

-- account
BULK INSERT bronze.account
FROM 'C:\Users\HUAWEI MATEBOOK\Desktop\Simplon\Construction d’un Data Warehouse (Bronze → Silver → Gold)\account.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

-- account_mapping
BULK INSERT bronze.account_mapping
FROM 'C:\Users\HUAWEI MATEBOOK\Desktop\Simplon\Construction d’un Data Warehouse (Bronze → Silver → Gold)\account_mapping.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

-- store
BULK INSERT bronze.store
FROM 'C:\Users\HUAWEI MATEBOOK\Desktop\Simplon\Construction d’un Data Warehouse (Bronze → Silver → Gold)\store.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

-- store_master
BULK INSERT bronze.store_master
FROM 'C:\Users\HUAWEI MATEBOOK\Desktop\Simplon\Construction d’un Data Warehouse (Bronze → Silver → Gold)\store_master.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
--Data Profiling / Data Quality Checks

SELECT COUNT(*) FROM bronze.account;
SELECT COUNT(*) FROM bronze.account_mapping;
SELECT COUNT(*) FROM bronze.store;
SELECT COUNT(*) FROM bronze.store_master;
SELECT COUNT(*) FROM bronze.transactions;


SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'bronze';


SELECT 'transactions' AS table_name, COUNT(*) AS nb_rows FROM bronze.transactions
UNION ALL
SELECT 'account', COUNT(*) FROM bronze.account
UNION ALL
SELECT 'account_mapping', COUNT(*) FROM bronze.account_mapping
UNION ALL
SELECT 'store', COUNT(*) FROM bronze.store
UNION ALL
SELECT 'store_master', COUNT(*) FROM bronze.store_master;


SELECT
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_transaction_id,
    SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS null_transaction_date,
    SUM(CASE WHEN store_code IS NULL THEN 1 ELSE 0 END) AS null_store_code,
    SUM(CASE WHEN account_number IS NULL THEN 1 ELSE 0 END) AS null_account_number,
    SUM(CASE WHEN amount_local IS NULL THEN 1 ELSE 0 END) AS null_amount_local,
    SUM(CASE WHEN currency IS NULL THEN 1 ELSE 0 END) AS null_currency,
    SUM(CASE WHEN document_number IS NULL THEN 1 ELSE 0 END) AS null_document_number,
    SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) AS null_description
FROM bronze.transactions;


-- =========================
-- NULL VALUES : transactions
-- =========================

SELECT *
FROM bronze.transactions
WHERE transaction_id IS NULL
   OR transaction_date IS NULL
   OR store_code IS NULL
   OR account_number IS NULL
   OR amount_local IS NULL
   OR currency IS NULL
   OR document_number IS NULL
   OR description IS NULL;


-- =========================
-- NULL VALUES : account
-- =========================

SELECT *
FROM bronze.account
WHERE account_number IS NULL
   OR account_name IS NULL
   OR account_type IS NULL
   OR currency IS NULL;


-- =========================
-- NULL VALUES : account_mapping
-- =========================

SELECT *
FROM bronze.account_mapping
WHERE AccountNumber IS NULL
   OR AccountName IS NULL
   OR PLLine IS NULL
   OR StatementType IS NULL
   OR SortOrder IS NULL
   OR Notes IS NULL;


-- =========================
-- NULL VALUES : store
-- =========================

SELECT *
FROM bronze.store
WHERE store_code IS NULL
   OR country IS NULL
   OR region IS NULL;


-- =========================
-- NULL VALUES : store_master
-- =========================

SELECT *
FROM bronze.store_master
WHERE store_code IS NULL
   OR store_name IS NULL
   OR store_type IS NULL;



-----------------------------------------------------------------
CREATE TABLE silver.transactions (
    transaction_id INT,
    transaction_date DATE,
    store_code VARCHAR(20),
    account_number INT,
    amount_local DECIMAL(18,2),
    currency VARCHAR(10),
    document_number VARCHAR(50),
    description VARCHAR(255)
);

CREATE TABLE silver.account (
    account_number INT,
    account_name VARCHAR(100),
    account_type VARCHAR(50),
    currency VARCHAR(10)
);

CREATE TABLE silver.account_mapping (
    account_number INT,
    account_name VARCHAR(100),
    pl_line VARCHAR(100),
    statement_type VARCHAR(50),
    sort_order INT,
    notes VARCHAR(255)
);

CREATE TABLE silver.store (
    store_code VARCHAR(20),
    country VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE silver.store_master (
    store_code VARCHAR(20),
    store_name VARCHAR(100),
    store_type VARCHAR(50)
);

--insertion des donnée dans les tables silver 

-- 1) transactions
INSERT INTO silver.transactions
SELECT
    transaction_id,
    CAST(transaction_date AS DATE),
    TRIM(store_code),
    account_number,
    CAST(REPLACE(amount_local, ',', '.') AS DECIMAL(18,2)),
    UPPER(TRIM(currency)),
    TRIM(document_number),
    TRIM(description)
FROM bronze.transactions;

-- 2) account
INSERT INTO silver.account
SELECT
    account_number,
    TRIM(account_name),
    UPPER(TRIM(account_type)),
    UPPER(TRIM(currency))
FROM bronze.account;

-- 3) account_mapping
INSERT INTO silver.account_mapping
SELECT
    AccountNumber,
    TRIM(AccountName),
    TRIM(PLLine),
    REPLACE(UPPER(TRIM(StatementType)), 'P L', 'P&L'),
    CAST(CAST(SortOrder AS FLOAT) AS INT),
    TRIM(Notes)
FROM bronze.account_mapping;

-- 4) store
INSERT INTO silver.store
SELECT
    TRIM(store_code),
    TRIM(country),
    TRIM(region)
FROM bronze.store;

-- 5) store_master
INSERT INTO silver.store_master
SELECT
    TRIM(store_code),
    TRIM(store_name),
    TRIM(store_type)
FROM bronze.store_master;

SELECT TOP 10 * FROM silver.transactions;
SELECT TOP 10 * FROM silver.account;
SELECT TOP 10 * FROM silver.account_mapping;
SELECT TOP 10 * FROM silver.store;
SELECT TOP 10 * FROM silver.store_master;

--Gold Layer

CREATE VIEW gold.dim_account AS
SELECT
    a.account_number,
    a.account_name,
    a.account_type,
    a.currency,
    am.pl_line,
    am.statement_type,
    am.sort_order,
    am.notes
FROM silver.account a
LEFT JOIN silver.account_mapping am
ON a.account_number = am.account_number;


CREATE VIEW gold.dim_store AS
SELECT
    s.store_code,
    sm.store_name,
    sm.store_type,
    s.country,
    s.region
FROM silver.store s
LEFT JOIN silver.store_master sm
ON s.store_code = sm.store_code;

CREATE OR ALTER VIEW gold.fact_gl AS
SELECT DISTINCT
    t.transaction_id,
    t.transaction_date,
    t.store_code,
    ds.store_name,
    ds.country,
    ds.region,

    t.account_number,
    da.account_name,
    da.account_type,
    da.pl_line,
    da.statement_type,

    t.amount_local,
    t.currency,
    t.document_number,
    t.description

FROM silver.transactions t

LEFT JOIN gold.dim_account da
ON t.account_number = da.account_number

LEFT JOIN gold.dim_store ds
ON t.store_code = ds.store_code;

SELECT TOP 10 * FROM gold.dim_account;
SELECT TOP 10 * FROM gold.dim_store
SELECT TOP 10 * FROM gold.fact_gl

-- Data Quality Checks

SELECT COUNT(*) AS bronze_transactions
FROM bronze.transactions;

SELECT COUNT(*) AS silver_transactions
FROM silver.transactions;

SELECT COUNT(*) AS gold_transactions
FROM gold.fact_gl;


SELECT transaction_id, COUNT(*) AS nb
FROM gold.fact_gl
GROUP BY transaction_id
HAVING COUNT(*) > 1;

SELECT account_number, COUNT(*) AS nb
FROM silver.account_mapping
GROUP BY account_number
HAVING COUNT(*) > 1;

SELECT *
FROM silver.account_mapping
WHERE account_number = 5100;