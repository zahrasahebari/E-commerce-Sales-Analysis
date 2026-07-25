-- ============================================================
-- E-COMMERCE SALES ANALYSIS
-- File: 01_data_quality_checks.sql
-- Purpose:
-- Assess the completeness, validity, consistency, and reliability
-- of the e-commerce sales dataset before business analysis.
-- ============================================================


-- ============================================================
-- 1. DATASET SIZE
-- ============================================================

SELECT
    COUNT(*) AS total_rows
FROM sales;

-- Result:
-- 34,500 rows.


-- ============================================================
-- 2. PRIMARY KEY DUPLICATE CHECK
-- ============================================================
-- Each order should appear only once in the dataset.

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM sales
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Result:
-- No duplicate order IDs were found.

-- Data Quality Interpretation:
-- Each row represents a unique order, consistent with the
-- expected grain of one row per order.


-- ============================================================
-- 3. NULL VALUE CHECK
-- ============================================================

SELECT
    COUNT(*) FILTER (
        WHERE order_id IS NULL
    ) AS null_order_id,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS null_customer_id,

    COUNT(*) FILTER (
        WHERE product_id IS NULL
    ) AS null_product_id,

    COUNT(*) FILTER (
        WHERE category IS NULL
    ) AS null_category,

    COUNT(*) FILTER (
        WHERE price IS NULL
    ) AS null_price,

    COUNT(*) FILTER (
        WHERE discount IS NULL
    ) AS null_discount,

    COUNT(*) FILTER (
        WHERE quantity IS NULL
    ) AS null_quantity,

    COUNT(*) FILTER (
        WHERE payment_method IS NULL
    ) AS null_payment_method,

    COUNT(*) FILTER (
        WHERE order_date IS NULL
    ) AS null_order_date,

    COUNT(*) FILTER (
        WHERE delivery_time_days IS NULL
    ) AS null_delivery_time_days,

    COUNT(*) FILTER (
        WHERE region IS NULL
    ) AS null_region,

    COUNT(*) FILTER (
        WHERE returned IS NULL
    ) AS null_returned,

    COUNT(*) FILTER (
        WHERE total_amount IS NULL
    ) AS null_total_amount,

    COUNT(*) FILTER (
        WHERE shipping_cost IS NULL
    ) AS null_shipping_cost,

    COUNT(*) FILTER (
        WHERE profit_margin IS NULL
    ) AS null_profit_margin,

    COUNT(*) FILTER (
        WHERE customer_age IS NULL
    ) AS null_customer_age,

    COUNT(*) FILTER (
        WHERE customer_gender IS NULL
    ) AS null_customer_gender

FROM sales;

-- Result:
-- No NULL values were found in any column.

-- Data Quality Interpretation:
-- The dataset is complete and does not require missing-value
-- treatment before analysis.


-- ============================================================
-- 4. BLANK STRING CHECK
-- ============================================================
-- NULL checks do not identify empty strings or values containing
-- only spaces, so text columns are checked separately.

SELECT
    COUNT(*) FILTER (
        WHERE TRIM(order_id) = ''
    ) AS blank_order_id,

    COUNT(*) FILTER (
        WHERE TRIM(customer_id) = ''
    ) AS blank_customer_id,

    COUNT(*) FILTER (
        WHERE TRIM(product_id) = ''
    ) AS blank_product_id,

    COUNT(*) FILTER (
        WHERE TRIM(category) = ''
    ) AS blank_category,

    COUNT(*) FILTER (
        WHERE TRIM(payment_method) = ''
    ) AS blank_payment_method,

    COUNT(*) FILTER (
        WHERE TRIM(region) = ''
    ) AS blank_region,

    COUNT(*) FILTER (
        WHERE TRIM(customer_gender) = ''
    ) AS blank_customer_gender

FROM sales;

-- Result:
-- No blank strings were found in the checked text columns.

-- Data Quality Interpretation:
-- The main identifier and categorical columns contain usable
-- text values rather than empty or whitespace-only entries.


-- ============================================================
-- 5. NUMERIC RANGE PROFILE
-- ============================================================
-- Review minimum, maximum, and average values to identify
-- unexpected or implausible observations.

SELECT
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    ROUND(AVG(price), 2) AS average_price,

    MIN(discount) AS minimum_discount,
    MAX(discount) AS maximum_discount,
    ROUND(AVG(discount), 4) AS average_discount,

    MIN(quantity) AS minimum_quantity,
    MAX(quantity) AS maximum_quantity,
    ROUND(AVG(quantity), 2) AS average_quantity,

    MIN(delivery_time_days) AS minimum_delivery_time,
    MAX(delivery_time_days) AS maximum_delivery_time,
    ROUND(AVG(delivery_time_days), 2) AS average_delivery_time,

    MIN(total_amount) AS minimum_total_amount,
    MAX(total_amount) AS maximum_total_amount,
    ROUND(AVG(total_amount), 2) AS average_total_amount,

    MIN(shipping_cost) AS minimum_shipping_cost,
    MAX(shipping_cost) AS maximum_shipping_cost,
    ROUND(AVG(shipping_cost), 2) AS average_shipping_cost,

    MIN(profit_margin) AS minimum_profit_margin,
    MAX(profit_margin) AS maximum_profit_margin,
    ROUND(AVG(profit_margin), 2) AS average_profit_margin,

    MIN(customer_age) AS minimum_customer_age,
    MAX(customer_age) AS maximum_customer_age,
    ROUND(AVG(customer_age), 2) AS average_customer_age

FROM sales;

-- Confirmed Results:
-- Minimum customer age: 18
-- Maximum customer age: 69
-- Minimum discount: 0.00
-- Maximum discount: 0.30
-- Average discount: approximately 0.0493, or 4.93%

-- Note:
-- Record the remaining minimum, maximum, and average results
-- after running the query if they are required in the README.


-- ============================================================
-- 6. COLUMN SEMANTICS VALIDATION: PROFIT_MARGIN
-- ============================================================

SELECT
    MIN(profit_margin) AS minimum_value,
    MAX(profit_margin) AS maximum_value,
    ROUND(AVG(profit_margin), 2) AS average_value
FROM sales;

SELECT
    total_amount,
    profit_margin,
    ROUND((profit_margin / NULLIF(total_amount, 0)) * 100, 2)
        AS calculated_profit_margin_percent
FROM sales
ORDER BY RANDOM()
LIMIT 20;

-- Result:
-- The 'profit_margin' column is identified as a monetary
-- profit field rather than a profit margin percentage.

-- Data Quality Interpretation:
-- Validation confirms that calculating
-- (profit_margin / total_amount) × 100 produces realistic
-- profit margin percentages. Therefore, the 'profit_margin'
-- column will be interpreted as profit (£) throughout the
-- remainder of the analysis.


-- ============================================================
-- 7. NUMERIC BUSINESS-RULE VALIDATION
-- ============================================================
-- The following rules are applied:
--
-- 1. Price must not be negative.
-- 2. Discount must be between 0 and less than 1.
-- 3. Quantity must be greater than zero.
-- 4. Delivery time must not be negative.
-- 5. Total amount must not be negative.
-- 6. Shipping cost must not be negative.
-- 7. Customer age must be between 18 and 69 inclusive.

SELECT
    COUNT(*) FILTER (
        WHERE price < 0
    ) AS invalid_price_rows,

    COUNT(*) FILTER (
        WHERE discount < 0
           OR discount >= 1
    ) AS invalid_discount_rows,

    COUNT(*) FILTER (
        WHERE quantity <= 0
    ) AS invalid_quantity_rows,

    COUNT(*) FILTER (
        WHERE delivery_time_days < 0
    ) AS invalid_delivery_time_rows,

    COUNT(*) FILTER (
        WHERE total_amount < 0
    ) AS invalid_total_amount_rows,

    COUNT(*) FILTER (
        WHERE shipping_cost < 0
    ) AS invalid_shipping_cost_rows,

    COUNT(*) FILTER (
        WHERE customer_age < 18
           OR customer_age > 69
    ) AS invalid_customer_age_rows

FROM sales;

-- Result:
-- No values were found outside the validated numeric ranges.

-- Data Quality Interpretation:
-- The principal numeric variables contain no obvious negative,
-- zero, or out-of-range values under the stated rules.


-- ============================================================
-- 8. DISCOUNT PROFILE
-- ============================================================

SELECT
    MIN(discount) AS minimum_discount,
    MAX(discount) AS maximum_discount,
    ROUND(AVG(discount), 4) AS average_discount
FROM sales;

-- Result:
-- Minimum discount: 0.00
-- Maximum discount: 0.30
-- Average discount: approximately 0.0493

-- Business Interpretation:
-- Discounts range from 0% to 30%, with an average discount of
-- approximately 4.93% per order.


-- ============================================================
-- 9. TOTAL AMOUNT CONSISTENCY CHECK
-- ============================================================
-- Expected total amount:
--
-- price × quantity × (1 - discount)
--
-- The expected value is rounded to two decimal places to match
-- the monetary precision of the stored total_amount column.

WITH sales_with_calculated_total AS (
    SELECT
        order_id,
        price,
        quantity,
        discount,
        total_amount,
        ROUND(
            price * quantity * (1 - discount),
            2
        ) AS calculated_total
    FROM sales
)

SELECT
    COUNT(*) AS inconsistent_total_amount_rows
FROM sales_with_calculated_total
WHERE ABS(total_amount - calculated_total) > 0.01;

-- Result:
-- No rows differ by more than £0.01.

-- Additional Observation:
-- 551 rows differ from the recalculated value by exactly £0.01.

-- Data Quality Interpretation:
-- The small £0.01 differences are consistent with monetary
-- rounding behaviour and are not considered material errors.
--
-- Therefore, total_amount is accepted as sufficiently reliable
-- for the subsequent analysis.


-- ============================================================
-- 10. REVIEW OF TOTAL AMOUNT DIFFERENCES
-- ============================================================
-- This query displays the rows whose stored total differs from
-- the recalculated amount by more than £0.01.
--
-- It should return no rows.

WITH sales_with_calculated_total AS (
    SELECT
        order_id,
        price,
        quantity,
        discount,
        total_amount,
        ROUND(
            price * quantity * (1 - discount),
            2
        ) AS calculated_total
    FROM sales
)

SELECT
    order_id,
    price,
    quantity,
    discount,
    total_amount,
    calculated_total,
    ROUND(
        total_amount - calculated_total,
        2
    ) AS amount_difference
FROM sales_with_calculated_total
WHERE ABS(total_amount - calculated_total) > 0.01
ORDER BY ABS(total_amount - calculated_total) DESC;

-- Result:
-- No material total-amount inconsistencies were found.


-- ============================================================
-- 11. CUSTOMER GENDER CONSISTENCY CHECK
-- ============================================================
-- A customer-level attribute should normally remain consistent
-- across all orders associated with the same customer ID.

SELECT
    customer_id,
    COUNT(DISTINCT customer_gender) AS number_of_gender_values
FROM sales
GROUP BY customer_id
HAVING COUNT(DISTINCT customer_gender) > 1
ORDER BY number_of_gender_values DESC;

-- Result:
-- 6,391 customer IDs are associated with more than one gender.


-- ============================================================
-- 12. CUSTOMER GENDER INCONSISTENCY RATE
-- ============================================================

WITH customer_gender_check AS (
    SELECT
        customer_id,
        COUNT(DISTINCT customer_gender) AS number_of_gender_values
    FROM sales
    GROUP BY customer_id
)

SELECT
    COUNT(*) AS total_unique_customers,

    COUNT(*) FILTER (
        WHERE number_of_gender_values > 1
    ) AS customers_with_inconsistent_gender,

    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE number_of_gender_values > 1
        )
        / COUNT(*),
        2
    ) AS inconsistent_customer_percentage

FROM customer_gender_check;

-- Result:
-- Total unique customers: 7,903
-- Customers with inconsistent gender: 6,391
-- Inconsistent customer percentage: approximately 80.87%

-- Data Quality Interpretation:
-- Customer gender is not consistently recorded at the customer
-- level. Therefore, customer-level gender analysis cannot be
-- considered reliable without additional data cleaning or access
-- to an authoritative customer master table.


-- ============================================================
-- 13. CUSTOMER AGE CONSISTENCY CHECK
-- ============================================================
-- This check determines whether the same customer ID is linked
-- to multiple recorded ages across different orders.

SELECT
    customer_id,
    COUNT(DISTINCT customer_age) AS number_of_age_values
FROM sales
GROUP BY customer_id
HAVING COUNT(DISTINCT customer_age) > 1
ORDER BY number_of_age_values DESC;

-- Result:
-- Run this query and record the number of returned customers.

-- Data Quality Interpretation:
-- If a substantial number of customers have multiple ages during
-- the approximately two-year dataset period, customer_age should
-- not be treated as a reliable fixed customer attribute.
--
-- A change of one or two years could be legitimate due to
-- birthdays, while larger differences may indicate inconsistent
-- or synthetically generated customer data.


-- ============================================================
-- 14. DISTINCT CATEGORICAL VALUES
-- ============================================================
-- Review categorical values for spelling differences,
-- inconsistent capitalisation, or unexpected categories.

SELECT DISTINCT
    category
FROM sales
ORDER BY category;

SELECT DISTINCT
    payment_method
FROM sales
ORDER BY payment_method;

SELECT DISTINCT
    region
FROM sales
ORDER BY region;

SELECT DISTINCT
    customer_gender
FROM sales
ORDER BY customer_gender;

-- Result:
-- No NULL or blank categorical values were identified.
-- Review the returned values visually for inconsistent spelling
-- or capitalisation.


-- ============================================================
-- DATA QUALITY SUMMARY
-- ============================================================
--
-- 1. The dataset contains 34,500 order-level records.
--
-- 2. No duplicate order IDs were identified.
--
-- 3. No NULL values were found.
--
-- 4. No blank strings were found in the checked text columns.
--
-- 5. Numeric values satisfied the principal validation rules.
--
-- 6. The 'profit_margin' column was validated as a monetary
--    profit field rather than a profit margin percentage and
--    will be treated as profit (£) throughout the analysis.
-- 
-- 7. Discounts range from 0% to 30%, with an average of
--    approximately 4.93%.
--
-- 8. The total_amount field is consistent with the expected
--    calculation within an accepted £0.01 rounding tolerance.
--
-- 9. A significant customer demographic issue was identified:
--    6,391 of 7,903 customer IDs, approximately 80.87%, are
--    associated with more than one gender.
--
-- 10. Customer-level gender analysis should therefore be excluded
--    from reliable business conclusions unless the demographic
--    data is corrected or validated against a customer master.
--
-- 11. Transaction-level variables such as category, region,
--     revenue, quantity, returns, delivery time, and shipping
--     cost remain suitable for further analysis.
--
-- ============================================================