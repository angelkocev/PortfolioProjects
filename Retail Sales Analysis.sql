# MySQL Retail Sales Analysis

USE retail_db;

SELECT *
FROM retail_sales;

# Counting the number of rows

SELECT COUNT(*)
FROM retail_sales;

# Checking for Null Values 

SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
    
SELECT
    SUM(CASE WHEN transactions_id IS NULL THEN 1 ELSE 0 END) AS transactions_id_nulls,
    SUM(CASE WHEN sale_date IS NULL THEN 1 ELSE 0 END) AS sale_date_nulls,
    SUM(CASE WHEN sale_time IS NULL THEN 1 ELSE 0 END) AS sale_time_nulls,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_nulls,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_nulls,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS category_nulls,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_nulls,
    SUM(CASE WHEN price_per_unit IS NULL THEN 1 ELSE 0 END) AS price_per_unit_nulls,
    SUM(CASE WHEN cogs IS NULL THEN 1 ELSE 0 END) AS cogs_nulls,
    SUM(CASE WHEN total_sale IS NULL THEN 1 ELSE 0 END) AS total_sale_nulls
FROM retail_sales;

# Data Cleaning

# Standardizing Column Names

ALTER TABLE retail_sales
RENAME COLUMN `п»їtransactions_id` TO `transactions_id`;

ALTER TABLE retail_sales
RENAME COLUMN `quantiy` TO `quantity`;

# Changing data types

UPDATE retail_sales
SET age = NULL
WHERE age IS NOT NULL 
	AND age NOT REGEXP "^[0-9]+$";
    
ALTER TABLE retail_sales
MODIFY age INT;

UPDATE retail_sales
SET quantity = NULL
WHERE quantity IS NOT NULL 
	AND quantity NOT REGEXP "^[0-9]+$";

ALTER TABLE retail_sales
MODIFY quantity INT;

UPDATE retail_sales
SET price_per_unit = NULL
WHERE price_per_unit IS NOT NULL 
	AND price_per_unit NOT REGEXP "^[0-9]+$";
    
ALTER TABLE retail_sales
MODIFY price_per_unit INT;

UPDATE retail_sales
SET cogs = NULL
WHERE cogs IS NOT NULL 
	AND cogs NOT REGEXP "[0-9]*\.?[0-9]+$";

ALTER TABLE retail_sales
MODIFY cogs FLOAT;

UPDATE retail_sales
SET total_sale = NULL
WHERE total_sale IS NOT NULL 
	AND total_sale NOT REGEXP "^[0-9]+$";
    
ALTER TABLE retail_sales
MODIFY total_sale FLOAT;

UPDATE retail_sales
SET sale_date = STR_TO_DATE(sale_date, "%m/%d/%Y");

ALTER TABLE retail_sales
MODIFY sale_date DATE;

ALTER TABLE retail_sales
MODIFY sale_time TIME;

-- Deleting columns with Null values

DELETE FROM retail_sales
WHERE quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

# Data Exploration

-- 1. How many sales we have?

SELECT COUNT(*) AS total_sales
FROM retail_sales;

-- 2. How many unique customers we have?

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;

-- 3. What product categories we have?

SELECT DISTINCT category
FROM retail_sales;

# Data Analysis and Business Key Problems & Answers

-- 1. Write a SQL query to retrieve all columns for sales made on "2022-11-05".
-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of November 2022.
-- 3. Write a SQL query to calculate the total orders and total sales for each category.
-- 4. Write a SQL query to find the average age of customers who purchased items from the "Beauty" category.
-- 5. Write a SQL query to find all transactions where the total sale is greater than 1000.
-- 6. Write a SQL query to find the total number of transactions made by each gender in each category.
-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
-- 8. Write a SQL query to find the top 5 customers based on the highest total sales.
-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.
-- 10. Write a SQL query to find the customers who purchased items from all three categories.
-- 11. Write a SQL query to create each shift and number of orders (Example: Morning before 12 PM, Afternoon between 12 PM and 17 PM, and Evening after 17 PM).

-- 1. Write a SQL query to retrieve all columns for sales made on "2022-11-05".

SELECT *
FROM retail_sales
WHERE sale_date = "2022-11-05";

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of November 2022.

SELECT transactions_id
FROM retail_sales
WHERE category = "Clothing"
	AND MONTH(sale_date) = 11
	AND YEAR(sale_date) = "2022"
    AND quantity > 3;
    
-- 3. Write a SQL query to calculate the total orders and total sales for each category.

SELECT category, 
	COUNT(*) AS total_orders,
	SUM(total_sale) AS net_sale
FROM retail_sales
GROUP BY category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the "Beauty" category.

SELECT ROUND(AVG(age),2) AS average_age
FROM retail_sales
WHERE category = "Beauty";

-- 5. Write a SQL query to find all transactions where the total sale is greater than 1000.

SELECT transactions_id
FROM retail_sales
WHERE total_sale > 1000; 

-- 6. Write a SQL query to find the total number of transactions made by each gender in each category.

SELECT gender, category,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY gender, category
ORDER BY category ASC, gender ASC;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

WITH month_by_month AS (
	SELECT MONTH(sale_date) AS month,
		YEAR(sale_date) AS year,
		ROUND(AVG(total_sale),2) AS average_sales,
        DENSE_RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale),2) DESC) AS ranking
	FROM retail_sales
	GROUP BY month, year)
SELECT month, year, average_sales
FROM month_by_month
WHERE ranking = 1;

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category,
	COUNT(DISTINCT customer_id) AS total_unique_customers 
FROM retail_sales
GROUP BY category;

-- 10. Write a SQL query to find the customers who purchased items from all three categories.

WITH CTE_1 AS (
	SELECT DISTINCT customer_id 
	FROM retail_sales
	WHERE category = "Beauty"),
CTE_2 AS (
	SELECT DISTINCT customer_id 
	FROM retail_sales
	WHERE category = "Electronics"),
CTE_3 AS (
	SELECT DISTINCT customer_id 
	FROM retail_sales
	WHERE category = "Clothing")
SELECT a.customer_id
FROM CTE_1 AS a
INNER JOIN CTE_2 AS b
	ON a.customer_id = b.customer_id
INNER JOIN CTE_3 AS c
	ON b.customer_id = c.customer_id;
    
-- 11. Write a SQL query to create each shift and number of orders (Example: Morning before 12 PM, Afternoon between 12 PM and 17 PM, and Evening after 17 PM).

SELECT 
	CASE
		WHEN sale_time < "12:00:00" THEN "Morning"
        WHEN sale_time BETWEEN "12:00:00" AND "17:00:00" THEN "Afternoon"
        ELSE "Evening"
	END AS shift,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY shift;

-- 12. Write a SQL query to find the top 10 customers who have made the most purchases in terms of quantity.

SELECT customer_id,
	SUM(quantity) AS total_quantity_purchased
FROM retail_sales
GROUP BY customer_id
ORDER BY total_quantity_purchased DESC
LIMIT 10;

-- 13. Write a SQL query to find the average time between purchases for each customer.

WITH prev_next_purchase AS (
	SELECT customer_id, sale_date,
		LEAD(sale_date) OVER(PARTITION BY customer_id ORDER BY sale_date ASC) AS next_purchase
	FROM retail_sales)
SELECT customer_id,
	ABS(ROUND(AVG(DATEDIFF(sale_date, next_purchase)), 2)) AS time_difference
FROM prev_next_purchase
WHERE next_purchase IS NOT NULL
GROUP BY customer_id;

-- 14. Write a SQL query to find the day of the week with the highest total sales.

WITH week_day AS (
	SELECT WEEKDAY(sale_date) AS day_of_the_week, total_sale
	FROM retail_sales)
SELECT day_of_the_week,
	CASE 
		WHEN day_of_the_week = 0 THEN "Monday"
        WHEN day_of_the_week = 1 THEN "Tuesday"
        WHEN day_of_the_week = 2 THEN "Wednesday"
        WHEN day_of_the_week = 3 THEN "Thursday"
        WHEN day_of_the_week = 4 THEN "Friday"
        WHEN day_of_the_week = 5 THEN "Saturday"
        WHEN day_of_the_week = 6 THEN "Sunday"
	END AS days_of_week_name,
    COUNT(*) AS total_transactions,
    SUM(total_sale) AS total_sales
FROM week_day
GROUP BY day_of_the_week, days_of_week_name
ORDER BY day_of_the_week ASC;

SELECT DAYNAME(sale_date) AS days_of_week_name,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY days_of_week_name
ORDER BY total_sales DESC;

SELECT DAYNAME(sale_date) AS days_of_week_name,
	COUNT(*) AS total_transactions,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY days_of_week_name
ORDER BY total_sales DESC
LIMIT 1;

-- 15. Write a SQL query to find the average transaction value for each day of the week.

SELECT DAYNAME(sale_date) AS days_of_week_name,
	ROUND(AVG(total_sale),2) AS average_transaction_value
FROM retail_sales
GROUP BY days_of_week_name
ORDER BY average_transaction_value DESC;

-- 16. Write a SQL query to find the top 3 hours of the day with the highest number of transactions.

SELECT HOUR(sale_time) AS hour_of_the_day,
	COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY hour_of_the_day
ORDER BY total_transactions DESC
LIMIT 3;

-- 17. Write a SQL query to find the total number of transactions and total sales for each hour of the day.

SELECT HOUR(sale_time) AS hour_of_day,
	COUNT(*) AS total_transactions,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY hour_of_day
ORDER BY hour_of_day ASC;

-- Write a SQL query to find the distribution of customers by age group. 

SELECT DISTINCT age
FROM retail_sales;

# End of project