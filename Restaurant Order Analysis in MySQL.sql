# Restaurant Order Analysis

USE restaurant_db;

# 1. View the menu_items table

SELECT *
FROM menu_items;

# 2. Find the number of items on the menu

SELECT COUNT(item_name) AS number_of_items
FROM menu_items;

SELECT COUNT(*) AS number_of_items
FROM menu_items;

# 3. What are the least and most expensive items on the menu?

SELECT *
FROM menu_items
ORDER BY price ASC;

SELECT *
FROM menu_items
ORDER BY price DESC;

SELECT *
FROM menu_items
ORDER BY price DESC
LIMIT 1;

SELECT *
FROM menu_items
ORDER BY price ASC
LIMIT 1;

# 4. How many Italian dishes are on the menu?

SELECT COUNT(item_name) AS number_of_italian_dishes
FROM menu_items
WHERE category = "Italian";

# 5. What are the least and most expensive Italian dishes on the menu?

SELECT *
FROM menu_items
WHERE category = "Italian"
ORDER BY price ASC
LIMIT 1;

SELECT *
FROM menu_items
WHERE category = "Italian"
ORDER BY price ASC;

SELECT *
FROM menu_items
WHERE category = "Italian"
ORDER BY price DESC
LIMIT 1;

SELECT *
FROM menu_items
WHERE category = "Italian"
ORDER BY price DESC;

# 6. How many dishes are in each category?

SELECT category, COUNT(item_name) AS number_of_dishes
FROM menu_items
GROUP BY category;

# 7. What is the average dish price within each category?

SELECT category, ROUND(AVG(price),2) AS average_price
FROM menu_items
GROUP BY category; 

# 8. View the order_details table

SELECT *
FROM order_details;

# 9. What is the date range of the table?

SELECT MIN(order_date) AS start_date, MAX(order_date) AS end_date
FROM order_details;

# 10. How many orders were made within this date range?

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM order_details;

# 11. How many items were ordered within this date range?

SELECT COUNT(order_details_id) AS total_items_ordered
FROM order_details;

# 12. Which orders had the most number of items?

SELECT order_id, COUNT(item_id) AS number_of_items
FROM order_details
GROUP BY order_id
ORDER BY number_of_items DESC;

# 13. How many orders had more than 12 items?

SELECT COUNT(order_id) AS total_orders
FROM (
	SELECT order_id, COUNT(item_id) AS number_of_items
	FROM order_details
	GROUP BY order_id) AS big_orders
WHERE number_of_items > 12;

SELECT COUNT(order_id) AS total_orders
FROM (
    SELECT order_id, COUNT(item_id) AS number_of_items
	FROM order_details
	GROUP BY order_id
	HAVING number_of_items > 12) AS big_orders;

# 14. Combine the menu_items and order_details tables into a single table.

SELECT *
FROM order_details AS od
INNER JOIN menu_items AS mi
	ON od.item_id = mi.menu_item_id;

# 15. What were the least and most ordered items? What categories were they in?

SELECT item_name, category, COUNT(order_details_id) AS total_purchases
FROM order_details AS od
LEFT JOIN menu_items AS mi
	ON od.item_id  = mi.menu_item_id
GROUP BY item_name, category
ORDER BY total_purchases DESC;

SELECT item_name, category, COUNT(order_details_id) AS total_purchases
FROM order_details AS od
LEFT JOIN menu_items AS mi
	ON od.item_id  = mi.menu_item_id 
GROUP BY item_name, category
ORDER BY total_purchases DESC
LIMIT 1;

SELECT item_name, category, COUNT(order_details_id) AS total_purchases
FROM order_details AS od
LEFT JOIN menu_items AS mi
	ON od.item_id  = mi.menu_item_id 
GROUP BY item_name, category
ORDER BY total_purchases ASC;

SELECT item_name, category, COUNT(order_details_id) AS total_purchases
FROM order_details AS od
LEFT JOIN menu_items AS mi
	ON od.item_id  = mi.menu_item_id 
GROUP BY item_name, category
ORDER BY total_purchases ASC
LIMIT 1;

# 16. What were the top 5 orders that spent the most money?

SELECT order_id, SUM(price) AS total_spend
FROM order_details AS od
LEFT JOIN menu_items AS mi
	ON od.item_id  = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5;

# 17. View the details of the highest spent order.

SELECT category, 
	COUNT(order_details_id) AS number_of_items,
    SUM(price) AS total_spend
FROM order_details AS od
LEFT JOIN menu_items AS mi
	ON od.item_id  = mi.menu_item_id
WHERE order_id = 440
GROUP BY category
ORDER BY total_spend DESC;

# 18. View the details of the top 5 highest spend orders.

SELECT category, 
	COUNT(order_details_id) AS number_of_items,
    SUM(price) AS total_spend
FROM order_details AS od
LEFT JOIN menu_items AS mi
	ON od.item_id  = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY category
ORDER BY total_spend DESC;

SELECT order_id,
	category, 
	COUNT(order_details_id) AS number_of_items,
    SUM(price) AS total_spend
FROM order_details AS od
LEFT JOIN menu_items AS mi
	ON od.item_id  = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category
ORDER BY order_id ASC, total_spend DESC;

SELECT order_id,
	category, 
	COUNT(order_details_id) AS number_of_items,
    SUM(price) AS total_spend
FROM order_details AS od
LEFT JOIN menu_items AS mi
	ON od.item_id  = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category
ORDER BY total_spend DESC;