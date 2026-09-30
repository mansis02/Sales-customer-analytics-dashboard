-- Sales & Customer Analytics Dashboard — 2025
-- MySQL analysis queries
-- Database: sales_analytics

USE sales_analytics;

-- 1. Total orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM sales;

-- 2. Total quantity sold
SELECT SUM(quantity) AS total_quantity
FROM sales;

-- 3. Gross sales before discount
SELECT ROUND(SUM(quantity * unit_price), 2) AS gross_sales
FROM sales;

-- 4. Total discount amount
SELECT ROUND(SUM(quantity * unit_price * discount), 2) AS discount_amount
FROM sales;

-- 5. Net sales after discount
SELECT ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS net_sales
FROM sales;

-- 6. Sales by city
SELECT city,
       ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS net_sales
FROM sales
GROUP BY city
ORDER BY net_sales DESC;

-- 7. Sales by product category
SELECT p.category,
       ROUND(SUM(s.quantity * s.unit_price * (1 - s.discount)), 2) AS net_sales
FROM sales s
JOIN products p ON s.product = p.product
GROUP BY p.category
ORDER BY net_sales DESC;

-- 8. Top 10 products by net sales
SELECT product,
       ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS net_sales
FROM sales
GROUP BY product
ORDER BY net_sales DESC
LIMIT 10;

-- 9. Monthly sales trend
SELECT DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
       ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS net_sales
FROM sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;

-- 10. Sales by payment mode
SELECT payment_mode,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS net_sales
FROM sales
GROUP BY payment_mode
ORDER BY net_sales DESC;

-- 11. Average Order Value
SELECT ROUND(
           SUM(quantity * unit_price * (1 - discount)) /
           COUNT(DISTINCT order_id), 2
       ) AS average_order_value
FROM sales;

-- 12. Unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM sales;

-- 13. Top 10 customers by net sales
SELECT customer_name,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS net_sales
FROM sales
GROUP BY customer_name
ORDER BY net_sales DESC
LIMIT 10;

-- 14. Profit by category
SELECT p.category,
       ROUND(SUM(s.quantity * s.unit_price * (1 - s.discount)), 2) AS net_sales,
       ROUND(SUM(s.quantity * p.unit_cost), 2) AS total_cost,
       ROUND(
           SUM(s.quantity * s.unit_price * (1 - s.discount)) -
           SUM(s.quantity * p.unit_cost), 2
       ) AS profit
FROM sales s
JOIN products p ON s.product = p.product
GROUP BY p.category
ORDER BY profit DESC;

-- 15. Overall profit
SELECT ROUND(
           SUM(s.quantity * s.unit_price * (1 - s.discount)) -
           SUM(s.quantity * p.unit_cost), 2
       ) AS total_profit
FROM sales s
JOIN products p ON s.product = p.product;

-- 16. Check for products in sales without a matching product master record
SELECT DISTINCT s.product
FROM sales s
LEFT JOIN products p ON s.product = p.product
WHERE p.product IS NULL;

-- 17. Basic data-quality check: duplicate order IDs
SELECT order_id, COUNT(*) AS duplicate_count
FROM sales
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 18. Date range in the dataset
SELECT MIN(order_date) AS start_date,
       MAX(order_date) AS end_date
FROM sales;
