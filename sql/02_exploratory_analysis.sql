-- ============================================================
-- E-COMMERCE SALES ANALYSIS
-- File: 02_exploratory_analysis.sql
-- Purpose:
-- Explore the overall size, time coverage, customer base,
-- purchasing frequency, and product-category distribution
-- before answering detailed business questions.
-- ============================================================


-- ============================================================
-- 1. TOTAL NUMBER OF ORDERS
-- ============================================================

SELECT
    COUNT(*) AS total_orders
FROM sales;

-- Result:
-- Total orders: 34,500

-- Business Interpretation:
-- The dataset contains 34,500 order-level transactions,
-- providing a substantial base for further analysis.


-- ============================================================
-- 2. DATE RANGE OF THE DATASET
-- ============================================================

SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM sales;

-- Result:
-- First order date: 2023-09-12
-- Last order date:  2025-09-11

-- Business Interpretation:
-- The dataset covers approximately two years of transactions,
-- allowing purchasing patterns to be examined across an
-- extended period.


-- ============================================================
-- 3. NUMBER OF UNIQUE CUSTOMERS
-- ============================================================

SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM sales;

-- Result:
-- Total unique customers: 7,903

-- Business Interpretation:
-- The 34,500 orders were placed by 7,903 distinct customer IDs,
-- indicating that many customers made more than one purchase.


-- ============================================================
-- 4. AVERAGE NUMBER OF ORDERS PER CUSTOMER
-- ============================================================

SELECT
    ROUND(
        COUNT(*)::NUMERIC /
        COUNT(DISTINCT customer_id),
        2
    ) AS average_orders_per_customer
FROM sales;

-- Result:
-- Average orders per customer: 4.37

-- Business Interpretation:
-- Each customer ID is associated with approximately 4.37 orders
-- on average, suggesting a meaningful level of repeat purchasing.


-- ============================================================
-- 5. NUMBER OF ORDERS BY PRODUCT CATEGORY
-- ============================================================

SELECT
    category,
    COUNT(*) AS number_of_orders
FROM sales
GROUP BY category
ORDER BY number_of_orders DESC;

-- Result:
--
-- Fashion        6,254
-- Electronics    6,180
-- Home           5,487
-- Toys           4,247
-- Sports         4,171
-- Beauty         4,103
-- Grocery        4,058

-- Business Interpretation:
-- Fashion generated the highest number of orders, closely
-- followed by Electronics.
--
-- Grocery recorded the lowest number of orders. However, order
-- volume is relatively well distributed across the seven
-- categories, with no single category dominating the dataset.


-- ============================================================
-- EXPLORATORY ANALYSIS SUMMARY
-- ============================================================
--
-- 1. The dataset contains 34,500 order-level transactions.
--
-- 2. Transactions cover approximately two years, from
--    September 2023 to September 2025.
--
-- 3. The dataset includes 7,903 distinct customer IDs.
--
-- 4. Customers placed an average of 4.37 orders each,
--    indicating repeat purchasing activity.
--
-- 5. Fashion and Electronics have the highest order volumes,
--    while Grocery has the lowest.
--
-- 6. Order volume is reasonably balanced across the seven
--    product categories.
--
-- 7. Customer demographic exploration is excluded from this
--    file because the data quality assessment identified major
--    inconsistencies in customer-level demographic attributes.
--
-- 8. Further analysis will focus on reliable transactional
--    variables, including revenue, profit, category, region,
--    payment method, returns, delivery time, and shipping cost.
--
-- ============================================================