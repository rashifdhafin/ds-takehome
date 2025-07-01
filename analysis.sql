-- Query 1: Create E_COMMERCE_TRANSACTIONS table from CSV file
-- '../data/e_commerce_transactions.csv'
DROP TABLE IF EXISTS E_COMMERCE_TRANSACTIONS;
CREATE TABLE E_COMMERCE_TRANSACTIONS AS SELECT * FROM read_csv_auto('../data/e_commerce_transactions.csv');

-- Query 2: Display first 5 rows of E_COMMERCE_TRANSACTIONS table
SELECT * FROM E_COMMERCE_TRANSACTIONS LIMIT 5;