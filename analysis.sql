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