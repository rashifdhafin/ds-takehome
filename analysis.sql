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