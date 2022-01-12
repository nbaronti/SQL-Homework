-- Drop views (if necessary)
DROP VIEW customer_transactions_less_than_2;
DROP VIEW merchants_with_small_transactions;
DROP VIEW top_100_transactions_morning;
DROP VIEW top_100_transactions_rest_of_day;
DROP VIEW transaction_details;

-- Select all values from each table

SELECT * FROM cardholder;
SELECT * FROM credit_card;
SELECT * FROM merchant;
SELECT * FROM merchant_category;
SELECT * FROM transactions;

-- Select all values from each view

SELECT * FROM transaction_details;
SELECT * FROM customer_transactions_less_than_2;
SELECT * FROM merchants_with_small_transactions;
SELECT * FROM top_100_transactions_morning;
SELECT * FROM top_100_transactions_rest_of_day;

-- Create view using inner join to display transactions data with cardholder and merchant information
CREATE VIEW transaction_details AS
SELECT t.transaction_ID,
 	   t.transaction_date,
	   t.transaction_amount,
	   t.credit_card_number,
	   t.merchantID,
	   cc.cardholder_ID,
	   c.cardholder_name,
	   m.merchant_name,
	   m.merchant_category_ID,
	   mc.merchant_category_name
FROM transactions as t
INNER JOIN credit_card as cc ON t.credit_card_number = cc.credit_card_number
INNER JOIN cardholder as c on cc.cardholder_ID = c.cardholder_ID 
INNER JOIN merchant as m on t.merchantID = m.merchantID
INNER JOIN merchant_category as mc on m.merchant_category_ID = mc.merchant_category_ID
ORDER BY c.cardholder_ID;

-- Group detailed transaction data view by cardholder_ID with a count of transactions less than $2
CREATE VIEW customer_transactions_less_than_2 AS
SELECT cardholder_ID, cardholder_name, count(transaction_amount) AS transactions_less_than_$2
FROM transaction_details
WHERE transaction_amount < 2
GROUP BY cardholder_ID, cardholder_name
ORDER BY transactions_less_than_$2 DESC;

-- Group detailed transaction data view by merchantID with a count of transactions less than $2
CREATE VIEW merchants_with_small_transactions AS
SELECT merchantID, merchant_name, merchant_category_name, count(transaction_amount) AS transactions_less_than_$2
FROM transaction_details
WHERE transaction_amount < 2
GROUP BY merchantID, merchant_name, merchant_category_name
ORDER BY transactions_less_than_$2 DESC;

-- Group detailed transaction data view by top 100 transactions between 7 & 9 in the morning
CREATE VIEW top_100_transactions_morning AS
SELECT transaction_ID, transaction_date, transaction_amount, cardholder_ID, cardholder_name, merchant_name, merchant_category_name
FROM transaction_details
WHERE DATE_PART('hour', transaction_date) > 7 AND DATE_PART('hour', transaction_date) < 9
ORDER BY transaction_amount DESC
LIMIT 100;

-- Group detailed transaction data view by top 100 transactions for the remainder of day (not between 7 & 9)
CREATE VIEW top_100_transactions_rest_of_day AS
SELECT transaction_ID, transaction_date, transaction_amount, cardholder_ID, cardholder_name, merchant_name, merchant_category_name
FROM transaction_details
WHERE DATE_PART('hour', transaction_date) < 7 OR DATE_PART('hour', transaction_date) > 9
ORDER BY transaction_amount DESC
LIMIT 100;
