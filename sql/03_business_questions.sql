-- ============================================================
-- BUSINESS QUESTION 1
-- What is the total revenue generated?
-- ============================================================

SELECT
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM sales;

-- Result:
-- Total revenue: £5,865,293.05

-- Business Interpretation:
-- The business generated total revenue of £5.87 million during
-- the two-year period covered by the dataset.
--
-- This KPI provides the baseline for evaluating sales
-- performance across product categories, regions, payment
-- methods, and other business dimensions in the subsequent
-- analysis.

-- ============================================================
-- BUSINESS QUESTION 2
-- Which product categories generate the most revenue?
-- ============================================================

SELECT
	category,
	ROUND(SUM(total_amount), 2) AS total_revenue
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;

-- Result:
--
-- Electronics   £3,319,206.50
-- Home          £1,077,681.52
-- Sports        £629,825.54
-- Fashion       £471,545.80
-- Beauty        £153,019.38
-- Toys          £132,013.80
-- Grocery       £82,000.51

-- Business Interpretation:
-- Electronics is the strongest-performing product category,
-- generating approximately £3.32 million in revenue, which
-- accounts for more than half of the company's total revenue.
--
-- Home ranks second with approximately £1.08 million in sales,
-- while Sports contributes a further £0.63 million.
--
-- The remaining categories generate substantially lower revenue,
-- with Grocery contributing the least at approximately £82,000.
--
-- These results suggest that Electronics is the primary revenue
-- driver of the business, indicating that inventory planning,
-- marketing investment, and pricing strategies within this
-- category could have the greatest impact on overall revenue.

-- ============================================================
-- BUSINESS QUESTION 3
-- What is the average order value (AOV) by product category?
-- ============================================================

SELECT
    category,
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM sales
GROUP BY category
ORDER BY average_order_value DESC;

-- Result:
--
-- Electronics   £537.09
-- Home          £196.41
-- Sports        £151.00
-- Fashion       £75.40
-- Beauty        £37.29
-- Toys          £31.08
-- Grocery       £20.21

-- Business Interpretation:
-- Electronics has the highest average order value at £537.09,
-- significantly outperforming all other product categories.
--
-- Home ranks second with an average order value of £196.41,
-- followed by Sports at £151.00.
--
-- Grocery records the lowest average order value at £20.21,
-- indicating that customers typically purchase lower-value
-- items within this category.
--
-- These findings explain why Electronics generated the highest
-- total revenue despite having fewer orders than Fashion.
-- Rather than relying on high sales volume, Electronics
-- achieves stronger revenue through substantially higher-value
-- transactions.

-- ============================================================
-- BUSINESS QUESTION 4
-- Which product categories generate the highest total profit?
-- ============================================================

SELECT
    category,
    ROUND(SUM(profit_margin), 2) AS total_profit
FROM sales
GROUP BY category
ORDER BY total_profit DESC;

-- Result:
--
-- Electronics   £344,371.77
-- Home          £262,633.70
-- Sports        £160,521.41
-- Fashion       £128,814.65
-- Beauty        £49,196.59
-- Toys          £33,669.25
-- Grocery      -£9,187.96
--
-- Business Interpretation:
-- Electronics generated the highest total profit (£344,371.77),
-- followed by Home (£262,633.70) and Sports (£160,521.41).
--
-- In contrast, Grocery recorded a total loss of £9,187.96,
-- indicating that this category was unprofitable over the
-- analysis period.
--
-- Comparing these results with the revenue analysis shows that
-- categories generating the highest revenue also generated the
-- highest total profit. However, profitability varied
-- considerably across categories, highlighting the importance
-- of evaluating profit alongside revenue when assessing
-- business performance.

-- ============================================================
-- Business Question 5:
-- Which product categories have the highest profit margin percentage?
-- ============================================================

SELECT
    category,
    ROUND(
        SUM(profit_margin) / SUM(total_amount) * 100,
        2
    ) AS profit_margin_percentage
FROM sales
GROUP BY category
ORDER BY profit_margin_percentage DESC;

-- Result:
-- Beauty has the highest profit margin percentage (32.15%), followed by
-- Fashion (27.32%). Toys and Sports have similar profit margins of
-- approximately 25.5%, while Home achieves a margin of 24.37%.
-- Electronics records a considerably lower profit margin of 10.38%,
-- despite generating the highest revenue and total profit. Grocery is
-- the only category with a negative profit margin (-11.20%).

-- Business Interpretation:
-- Beauty is the most profitable category relative to its revenue,
-- indicating strong profitability efficiency despite generating lower
-- overall sales than Electronics. In contrast, Electronics relies on
-- high sales volume to generate total profit, but retains a much smaller
-- proportion of revenue as profit. Grocery operates at a loss, suggesting
-- that its revenue does not sufficiently cover associated costs.
-- Management should investigate pricing strategies, discount levels,
-- operating costs, and product mix to improve the profitability of
-- low-margin and loss-making categories.

-- ============================================================
-- Business Question 6:
-- Which regions generate the highest revenue?
-- ============================================================

SELECT
    region,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM sales
GROUP BY region
ORDER BY total_revenue DESC;

-- Result:
-- South generates the highest total revenue (£1,298,096.07), followed by
-- North (£1,264,008.35). West and East generate similar revenue levels,
-- while Central records the lowest total revenue (£940,503.38).

-- Business Interpretation:
-- Revenue is relatively well distributed across the five regions, with no
-- single region accounting for a disproportionately large share of total
-- sales. South represents the strongest-performing market, whereas Central
-- generates the lowest revenue and may offer opportunities for sales growth.
-- Management could investigate regional differences in customer demand,
-- marketing effectiveness, product availability, and pricing strategies to
-- identify factors contributing to South's stronger performance and improve
-- sales in lower-performing regions.

-- ============================================================
-- Business Question 7:
-- Which product categories have the highest return rates?
-- ============================================================

SELECT
    category,
    ROUND(
        COUNT(*) FILTER (WHERE returned = TRUE)::NUMERIC
        / COUNT(*) * 100,
        2
    ) AS return_rate
FROM sales
GROUP BY category
ORDER BY return_rate DESC;

-- Result:
-- Fashion records the highest return rate (8.28%), followed by
-- Electronics (7.30%). Home, Sports, and Toys have moderate return
-- rates ranging from 4.94% to 5.65%, while Beauty (3.78%) and Grocery
-- (1.31%) experience the lowest return rates.

-- Business Interpretation:
-- Fashion and Electronics experience substantially higher return rates
-- than the remaining product categories, which may indicate issues
-- related to product expectations, sizing, quality, or customer
-- satisfaction. In contrast, Grocery has a very low return rate,
-- suggesting that customers rarely return these products. Management
-- should investigate the causes of high return rates in Fashion and
-- Electronics to reduce reverse logistics costs, improve customer
-- satisfaction, and protect overall profitability.

-- ============================================================
-- Business Question 8:
-- How has monthly revenue changed over time?
-- ============================================================

SELECT
    TO_CHAR(
        DATE_TRUNC('month', order_date),
        'YYYY-MM'
    ) AS sales_month,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM sales
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);

-- Result:
-- Monthly revenue fluctuates between approximately £212k and £278k
-- throughout the analysis period. December 2024 records the highest
-- monthly revenue (£278,154.19), while the first and last months
-- (September 2023 and September 2025) record substantially lower revenue
-- because they contain only partial months of data.

-- Business Interpretation:
-- Monthly revenue remains relatively stable over the two-year period,
-- generally ranging between £220k and £265k, with no sustained upward or
-- downward trend. Revenue peaks in December 2024, suggesting a possible
-- seasonal increase in customer demand during the holiday period.
-- Management should investigate the factors contributing to higher sales
-- during peak months and explore opportunities to replicate these
-- successful strategies throughout the year.

-- ============================================================
-- Business Question 9:
-- Which payment methods generate the highest revenue?
-- ============================================================

SELECT
    payment_method,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM sales
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- Result:
-- Credit Card generates the highest total revenue (£2,056,787.40),
-- followed by Debit Card (£1,460,210.97). COD and UPI contribute
-- similar revenue of approximately £714k each, while PayPal
-- (£576,523.32) and Wallet (£342,556.50) generate the lowest revenue.

-- Business Interpretation:
-- Customers show a clear preference for card payments, with Credit Card
-- and Debit Card accounting for the majority of total revenue.
-- This suggests that maintaining a secure and efficient card payment
-- experience is essential for supporting sales. Meanwhile, digital
-- payment methods such as Wallet and PayPal contribute a smaller share
-- of revenue but remain valuable for offering customers flexibility and
-- improving the overall checkout experience.

-- ============================================================
-- Business Question 10:
-- How do different discount levels affect sales performance and profitability?
-- ============================================================

WITH discount_groups AS (
    SELECT
        CASE
            WHEN discount = 0 THEN 'No Discount'
            WHEN discount <= 0.10 THEN 'Low Discount (1–10%)'
            WHEN discount <= 0.20 THEN 'Medium Discount (11–20%)'
            ELSE 'High Discount (21–30%)'
        END AS discount_band,
        total_amount,
        profit_margin
    FROM sales
)

SELECT
    discount_band,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS average_order_value,
    ROUND(SUM(profit_margin), 2) AS total_profit
FROM discount_groups
GROUP BY discount_band
ORDER BY
    CASE discount_band
        WHEN 'No Discount' THEN 1
        WHEN 'Low Discount (1–10%)' THEN 2
        WHEN 'Medium Discount (11–20%)' THEN 3
        WHEN 'High Discount (21–30%)' THEN 4
    END;

-- Result:
-- Orders, revenue, average order value, and total profit all decrease as
-- discount levels increase. No Discount accounts for 18,939 orders,
-- £3,388,994.91 in revenue, an average order value of £178.94, and
-- £569,521.73 in total profit. In contrast, High Discount (21–30%)
-- generates only 704 orders, £93,301.44 in revenue, an average order
-- value of £132.53, and £13,678.47 in total profit.

-- Business Interpretation:
-- Higher discount levels are not associated with stronger sales
-- performance in this dataset. Instead, larger discounts coincide with
-- fewer orders, lower revenue, lower average order values, and
-- substantially lower total profit. These findings suggest that the
-- highest discount levels do not stimulate sufficient customer demand to
-- offset the reduction in selling prices. Management should review the
-- effectiveness of high-discount promotions and investigate whether more
-- targeted or moderate discount strategies could achieve better financial
-- outcomes.

-- ============================================================
-- Business Question 11:
-- Does delivery time affect product return rates?
-- ============================================================

WITH delivery_options AS (
    SELECT
        CASE
            WHEN delivery_time_days <= 3 THEN 'Fast'
            WHEN delivery_time_days <= 7 THEN 'Standard'
            ELSE 'Slow'
        END AS delivery_speed,
        returned
    FROM sales
)

SELECT
    delivery_speed,
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE returned = TRUE) AS returned_orders,
    ROUND(
        COUNT(*) FILTER (WHERE returned = TRUE)::NUMERIC
        / COUNT(*) * 100,
        2
    ) AS return_rate
FROM delivery_options
GROUP BY delivery_speed
ORDER BY
    CASE delivery_speed
        WHEN 'Fast' THEN 1
        WHEN 'Standard' THEN 2
        WHEN 'Slow' THEN 3
    END;

-- Result:
-- Fast deliveries (1–3 days) record 4,907 orders with a return rate of
-- 5.24%. Standard deliveries (4–7 days) account for the majority of
-- orders (28,751) and have a return rate of 5.55%. Slow deliveries
-- (8+ days) have the highest return rate at 6.06%, although they
-- represent the smallest number of orders (842).

-- Business Interpretation:
-- Return rates increase slightly as delivery times become longer,
-- rising from 5.24% for fast deliveries to 6.06% for slow deliveries.
-- This suggests a possible association between longer delivery times
-- and a higher likelihood of product returns. However, the differences
-- are relatively small, and the slow-delivery group contains
-- substantially fewer orders than the other groups. Additional analysis
-- would be needed to determine whether delivery time itself drives
-- returns or whether other factors, such as product category or
-- customer characteristics, contribute to this pattern.

-- ============================================================
-- Business Question 12:
-- Which customer age groups generate the highest revenue and profit?
-- ============================================================

WITH age_grouping AS (
    SELECT
        CASE
            WHEN customer_age <= 29 THEN 'Young Adults'
            WHEN customer_age <= 44 THEN 'Adults'
            WHEN customer_age <= 59 THEN 'Middle-aged'
            ELSE 'Seniors'
        END AS age_group,
        customer_id,
        total_amount,
        profit_margin
    FROM sales
)

SELECT
    age_group,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(
        SUM(total_amount)
        / COUNT(DISTINCT customer_id)::NUMERIC,
        2
    ) AS average_revenue_per_customer,
    ROUND(SUM(profit_margin), 2) AS total_profit
FROM age_grouping
GROUP BY age_group
ORDER BY
    CASE age_group
        WHEN 'Young Adults' THEN 1
        WHEN 'Adults' THEN 2
        WHEN 'Middle-aged' THEN 3
        WHEN 'Seniors' THEN 4
    END;

-- Result:
-- Adults represent the largest customer segment (5,712 customers) and
-- generate the highest total revenue (£1,705,257.76), the highest
-- average revenue per customer (£298.54), and the highest total profit
-- (£281,830.05). Middle-aged customers perform similarly, generating
-- £1,659,487.29 in revenue and £275,193.28 in profit. Young Adults
-- contribute £1,403,036.92 in revenue and £229,730.83 in profit,
-- while Seniors generate the lowest revenue (£1,097,511.08), the
-- lowest average revenue per customer (£242.49), and the lowest
-- total profit (£183,265.25).

-- Business Interpretation:
-- Adults are the most valuable customer segment in this dataset,
-- generating the highest revenue, profit, and average revenue per
-- customer. Middle-aged customers also make a strong contribution,
-- indicating that customers aged 30 to 59 represent the company's
-- highest-value market. In contrast, Seniors generate lower revenue
-- and profit despite representing a substantial customer base,
-- suggesting lower spending per customer. Management should consider
-- prioritising marketing campaigns, customer retention initiatives,
-- and personalised promotions for the Adult and Middle-aged segments,
-- while exploring opportunities to increase engagement and spending
-- among Senior customers.

-- ============================================================
-- Business Question 13:
-- Which product categories generate the highest average profit per order?
-- ============================================================

SELECT
    category,
    COUNT(*) AS total_orders,
    ROUND(SUM(profit_margin), 2) AS total_profit,
    ROUND(AVG(profit_margin), 2) AS average_profit_per_order
FROM sales
GROUP BY category
ORDER BY average_profit_per_order DESC;

-- Result:
-- Electronics generate the highest average profit per order (£55.72),
-- followed by Home (£47.86) and Sports (£38.49). Fashion, Beauty,
-- and Toys generate progressively lower profit per order, while
-- Grocery records a negative average profit per order (-£2.26),
-- indicating that each Grocery order results in an average loss.

-- Business Interpretation:
-- Electronics are the most profitable category on a per-order basis,
-- meaning each sale contributes more profit than any other product
-- category. Home and Sports also generate strong profits per
-- transaction, making them attractive categories for revenue growth
-- and promotional activities. In contrast, Grocery is unprofitable,
-- with each order generating an average loss. Management should
-- investigate the pricing strategy, cost structure, or discount
-- policies for Grocery products, while considering opportunities to
-- increase sales of high-profit categories such as Electronics,
-- Home, and Sports.

-- ============================================================
-- Business Question 14:
-- Which regions generate the highest profit per customer?
-- ============================================================

SELECT
    region,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(profit_margin), 2) AS total_profit,
    ROUND(
        SUM(profit_margin)
        / COUNT(DISTINCT customer_id)::NUMERIC,
        2
    ) AS average_profit_per_customer
FROM sales
GROUP BY region
ORDER BY average_profit_per_customer DESC;

-- Result:
-- The West region generates the highest average profit per customer
-- (£43.45), followed closely by North (£43.02), South (£42.86),
-- and East (£42.70). Central generates the lowest average profit
-- per customer (£39.05), despite serving 4,047 customers.

-- Business Interpretation:
-- Customers across most regions generate similar levels of profit,
-- indicating relatively consistent customer value throughout the
-- business. However, the West region achieves the highest average
-- profit per customer, suggesting it is the most valuable market
-- on a per-customer basis. In contrast, the Central region generates
-- the lowest average profit per customer, which may indicate
-- opportunities to improve customer spending, pricing strategies,
-- or product mix. Management should investigate the factors
-- contributing to the West region's stronger customer profitability
-- and assess whether similar strategies can be applied in other
-- regions.

-- ============================================================
-- Business Question 15:
-- Which product categories rank highest by total profit?
-- ============================================================

SELECT
    DENSE_RANK() OVER (
        ORDER BY SUM(profit_margin) DESC
    ) AS profit_rank,
    category,
    ROUND(SUM(profit_margin), 2) AS total_profit
FROM sales
GROUP BY category
ORDER BY profit_rank;

-- Result:
-- Electronics rank first with the highest total profit (£344,371.77),
-- followed by Home (£262,633.70) and Sports (£160,521.41).
-- Fashion ranks fourth, while Beauty and Toys generate considerably
-- lower profits. Grocery ranks last and records a total loss of
-- £9,187.96.

-- Business Interpretation:
-- Electronics are the strongest category in terms of overall profit
-- contribution, with Home and Sports also performing well. The ranking
-- provides management with a clear view of category performance and
-- helps identify which product groups contribute most to profitability.
-- Grocery requires immediate review because it is the only category
-- generating a loss, while lower-ranked categories such as Beauty and
-- Toys may need further analysis of pricing, costs, and sales volume.

-- ============================================================
-- Business Question 16:
-- Which customers contribute the most to total revenue?
-- ============================================================

WITH customer_spending AS (
    SELECT
        customer_id,
        SUM(total_amount) AS total_spending
    FROM sales
    GROUP BY customer_id
)

SELECT
    CASE
        WHEN total_spending >= 1500 THEN 'High Value'
        WHEN total_spending >= 700 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(*) AS total_customers
FROM customer_spending
GROUP BY
    CASE
        WHEN total_spending >= 1500 THEN 'High Value'
        WHEN total_spending >= 700 THEN 'Medium Value'
        ELSE 'Low Value'
    END
ORDER BY
    CASE
        WHEN
            CASE
                WHEN total_spending >= 1500 THEN 'High Value'
                WHEN total_spending >= 700 THEN 'Medium Value'
                ELSE 'Low Value'
            END = 'High Value'
        THEN 1

        WHEN
            CASE
                WHEN total_spending >= 1500 THEN 'High Value'
                WHEN total_spending >= 700 THEN 'Medium Value'
                ELSE 'Low Value'
            END = 'Medium Value'
        THEN 2

        ELSE 3
    END;

	-- Result:
-- The Low-Value segment contains the largest number of customers,
-- with 4,995 customers. The Medium-Value segment includes 1,945
-- customers, while 963 customers are classified as High Value.

-- Business Interpretation:
-- Most customers fall within the Low-Value segment, indicating that
-- a large proportion of the customer base generates relatively low
-- lifetime spending. High-Value customers represent a much smaller
-- group, but they are likely to contribute a disproportionate share
-- of total revenue. Management should consider retention and loyalty
-- strategies for High-Value customers, targeted cross-selling and
-- upselling for Medium-Value customers, and re-engagement campaigns
-- designed to increase spending among Low-Value customers.

-- ============================================================
-- Business Question 17:
-- How has cumulative revenue grown over time?
-- ============================================================

SELECT
    DATE_TRUNC('month', order_date)::DATE AS month,
    SUM(total_amount) AS monthly_revenue,
    SUM(SUM(total_amount)) OVER (
        ORDER BY DATE_TRUNC('month', order_date)
    ) AS cumulative_revenue
FROM sales
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

-- Result:
-- Cumulative revenue increased from £151,135.60 in September 2023
-- to £5,865,293.05 by September 2025.
-- December 2024 generated the highest monthly revenue at £278,154.19.
-- September 2025 recorded only £91,848.17 because it represents
-- a partial month in the dataset.

-- Business Interpretation:
-- Revenue accumulated steadily throughout the analysis period,
-- with no major interruptions in the overall growth trend.
-- Monthly revenue generally remained between approximately
-- £210,000 and £278,000 during complete months.
-- The cumulative trend indicates consistent revenue generation,
-- while the lower values in September 2023 and September 2025
-- should not be interpreted as weak performance because both
-- months contain incomplete data.

-- ============================================================
-- Business Question 18:
-- Who are the top 5 customers in each region based on total spending?
-- ============================================================

WITH customer_spending AS (
    SELECT
        region,
        customer_id,
        SUM(total_amount) AS total_spending
    FROM sales
    GROUP BY
        region,
        customer_id
),

ranked_customers AS (
    SELECT
        region,
        customer_id,
        total_spending,
        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY
                total_spending DESC,
                customer_id
        ) AS customer_rank
    FROM customer_spending
)

SELECT
    region,
    customer_id,
    ROUND(total_spending, 2) AS total_spending,
    customer_rank
FROM ranked_customers
WHERE customer_rank <= 5
ORDER BY
    region,
    customer_rank;

-- Result:
-- The query identifies the five highest-spending customers within
-- each region. The West region contains the two highest individual
-- spenders in the dataset: Customer C16655, with total spending of
-- £12,964.94, and Customer C13565, with £11,757.29.
-- The leading customers in Central, North, East, and South generated
-- £11,298.30, £6,576.51, £6,009.62, and £5,276.80 respectively.

-- Business Interpretation:
-- High-value customers are present across all regions, but the West
-- region stands out because its two leading customers spend
-- substantially more than most top customers elsewhere.
-- These customers may be suitable candidates for loyalty programmes,
-- personalised offers, and retention initiatives.
-- Management should also assess whether regional revenue is overly
-- dependent on a small number of high-spending customers.