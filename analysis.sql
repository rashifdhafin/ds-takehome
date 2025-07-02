-- Query 1: Create E_COMMERCE_TRANSACTIONS table from CSV file
-- '../data/e_commerce_transactions.csv'
DROP TABLE IF EXISTS E_COMMERCE_TRANSACTIONS;
CREATE TABLE E_COMMERCE_TRANSACTIONS AS SELECT * FROM read_csv_auto('../data/e_commerce_transactions.csv');

-- Query 2: Display first 5 rows of E_COMMERCE_TRANSACTIONS table
SELECT * FROM E_COMMERCE_TRANSACTIONS LIMIT 5;

-- Query 3: Check if we have null data in E_COMMERCE_TRANSACTIONS table
SELECT COUNT(*) AS NULL_DATA
FROM E_COMMERCE_TRANSACTIONS
WHERE order_id IS NULL 
OR customer_id IS NULL
OR order_date IS NULL
OR payment_value IS NULL
OR decoy_flag IS NULL
OR decoy_noise IS NULL;

-- Query 4: Check how many unique order_id in E_COMMERCE_TRANSACTIONS table
-- to make sure we have no duplicates
SELECT COUNT(DISTINCT order_id) AS UNIQUE_ORDER_ID FROM E_COMMERCE_TRANSACTIONS;

-- Query 5: Check how many unique customer_id in E_COMMERCE_TRANSACTIONS table
SELECT COUNT(DISTINCT customer_id) AS UNIQUE_CUSTOMER_ID FROM E_COMMERCE_TRANSACTIONS;

-- Query 6: Check minimum and maximum order_date in E_COMMERCE_TRANSACTIONS table
SELECT 
    MIN(order_date) AS MIN_ORDER_DATE, 
    MAX(order_date) AS MAX_ORDER_DATE
FROM E_COMMERCE_TRANSACTIONS;

-- Query 7: Check minimum and maximum payment_value in E_COMMERCE_TRANSACTIONS table
SELECT 
    MIN(payment_value) AS MIN_PAYMENT_VALUE, 
    MAX(payment_value) AS MAX_PAYMENT_VALUE
FROM E_COMMERCE_TRANSACTIONS;

-- Query 8: Check unique value from decoy_flag column in E_COMMERCE_TRANSACTIONS table
SELECT DISTINCT decoy_flag FROM E_COMMERCE_TRANSACTIONS;

-- Query 9: Check minimum and maximum decoy_noise in E_COMMERCE_TRANSACTIONS table
SELECT 
    MIN(decoy_noise) AS MIN_DECOY_NOISE, 
    MAX(decoy_noise) AS MAX_DECOY_NOISE
FROM E_COMMERCE_TRANSACTIONS;

-- Query 10: Create RFM scores and customer segments distribution
WITH CustomerRFM AS (
    SELECT
        customer_id,
        DATE_DIFF('day', MAX(order_date), (SELECT MAX(order_date) FROM E_COMMERCE_TRANSACTIONS)) AS recency,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(payment_value) AS monetary
    FROM
        E_COMMERCE_TRANSACTIONS
    GROUP BY
        customer_id
),
RFMScores AS (
    SELECT
        customer_id,
        NTILE(5) OVER (ORDER BY recency) AS r_score,
        NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary DESC) AS m_score
    FROM
        CustomerRFM
)
SELECT
    CASE
        WHEN r_score = 5 AND f_score = 5 AND m_score = 5 THEN 'Champions'
        WHEN r_score = 5 AND f_score = 4 AND m_score IN (3,4) THEN 'Big Spenders'
        WHEN r_score IN (3,4,5) AND f_score IN (4,5) AND m_score IN (1,2,3) THEN 'Frequent Buyers'
        WHEN r_score IN (1,2) AND f_score IN (1,2,3) AND m_score IN (1,2,3) THEN 'Lost'
        WHEN r_score IN (2,3) AND f_score IN (2,3) AND m_score IN (2,3) THEN 'Average Customers'
        WHEN r_score = 1 AND f_score = 1 AND m_score = 5 THEN 'Big Wallet, Inactive'
        ELSE 'Other'
    END AS Customer_Segment,
    COUNT(*) AS Number_Of_Customers
FROM
    RFMScores
GROUP BY
    Customer_Segment
ORDER BY
    Number_Of_Customers DESC;

-- Query 11: Create query to create reports of monthly repeat purchase by customer
-- MonthlyOrders CTE: Extracts list of orders with their respective months
-- CustomerMonthlyOrderCounts CTE: Counts distinct orders per customer per month
-- MonthlyRepeatCustomers CTE: Counts unique customers with multiple orders in each month
-- TotalUniqueCustomersMonthly CTE: Counts total unique customers per month
-- Final SELECT: Combines the above CTEs to calculate the percentage of repeat purchases per month
WITH MonthlyOrders AS (
    SELECT
        customer_id,
        order_id,
        STRFTIME(order_date, '%Y-%m') AS order_month
    FROM
        E_COMMERCE_TRANSACTIONS
),
CustomerMonthlyOrderCounts AS (
    SELECT
        customer_id,
        order_month,
        COUNT(DISTINCT order_id) AS orders_in_month
    FROM
        MonthlyOrders
    GROUP BY
        customer_id,
        order_month
),
MonthlyRepeatCustomers AS (
    SELECT
        order_month,
        COUNT(customer_id) AS unique_repeat_customers_in_month
    FROM
        CustomerMonthlyOrderCounts
    WHERE
        orders_in_month > 1
    GROUP BY
        order_month
),
TotalUniqueCustomersMonthly AS (
    SELECT
        STRFTIME(order_date, '%Y-%m') AS order_month,
        COUNT(DISTINCT customer_id) AS total_unique_customers
    FROM
        E_COMMERCE_TRANSACTIONS
    GROUP BY
        order_month
)
SELECT
    tm.order_month,
    tm.total_unique_customers,
    COALESCE(mrc.unique_repeat_customers_in_month, 0) AS customers_with_multiple_orders_in_month,
    ROUND(COALESCE(mrc.unique_repeat_customers_in_month, 0) * 100.0 / tm.total_unique_customers, 2) AS percentage_repeat_purchase_in_month
FROM
    TotalUniqueCustomersMonthly AS tm
LEFT JOIN
    MonthlyRepeatCustomers AS mrc ON tm.order_month = mrc.order_month
ORDER BY
    tm.order_month;