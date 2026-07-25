-- ============================================================
-- E-COMMERCE SALES ANALYSIS
-- File: 00_database_setup.sql
-- Purpose:
-- Create the database table used for the analysis.
--
-- Dataset:
-- E-commerce Sales Transactions (34,500 records)
--
-- Note:
-- The CSV file was imported into PostgreSQL using the
-- pgAdmin Import/Export Wizard after creating this table.
-- ============================================================


-- ============================================================
-- CREATE TABLE
-- ============================================================

CREATE TABLE sales (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT,
    product_id TEXT,
    category TEXT,
    price NUMERIC(9,2),
    discount NUMERIC(5,2),
    quantity INTEGER,
    payment_method TEXT,
    order_date DATE,
    delivery_time_days INTEGER,
    region TEXT,
    returned BOOLEAN,
    total_amount NUMERIC(9,2),
    shipping_cost NUMERIC(9,2),
    profit_margin NUMERIC(9,2),
    customer_age INTEGER,
    customer_gender TEXT
);


-- ============================================================
-- DATA IMPORT
-- ============================================================
--
-- The dataset was imported from a CSV file using the
-- pgAdmin Import/Export Wizard with the following settings:
--
-- • Format: CSV
-- • Header: Yes
-- • Delimiter: Comma (,)
-- • Quote: Double Quote (")
-- • Encoding: UTF-8
--
-- After the import, the dataset contained:
--
-- • 34,500 rows
-- • 17 columns
--
-- Data quality validation begins in:
-- 01_data_quality_checks.sql
--
-- ============================================================