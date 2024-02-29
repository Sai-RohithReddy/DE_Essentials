SELECT o.order_date,
	round(sum(oi.order_item_subtotal)::numeric, 2) AS order_revenue
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1
ORDER BY 1;


SELECT o.order_date,
	oi.order_item_product_id,
	round(sum(oi.order_item_subtotal)::numeric, 2) AS order_revenue
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- CTAS (Create Table As Select)

CREATE TABLE order_count_status AS
SELECT order_status, COUNT(*) AS order_count
FROM orders
GROUP BY 1;

SELECT * FROM order_count_status;

-- TO CRATE EMPTY TABLE BASED ON EXISTING TABLE COLOMS AND DATA TYPES AS REFERENCE
CREATE TABLE orders_stg
AS 
SELECT * FROM orders WHERE false;

SELECT * FROM orders_stg;

CREATE TABLE daily_revenue AS
SELECT o.order_date,
	round(sum(oi.order_item_subtotal)::numeric, 2) AS order_revenue
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1;

SELECT * FROM daily_revenue;

CREATE TABLE daily_product_revenue AS
SELECT o.order_date,
	oi.order_item_product_id,
	round(sum(oi.order_item_subtotal)::numeric, 2) AS order_revenue
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1, 2;

SELECT * FROM daily_product_revenue;

-- OVER and PARTITION BY

SELECT * FROM daily_revenue
ORDER BY 1;

SELECT to_char(dr.order_date::timestamp, 'yyyy-MM') AS order_month,
SUM(order_revenue) AS order_revenue
FROM daily_revenue AS dr
GROUP BY 1
ORDER BY 1;

SELECT to_char(dr.order_date::timestamp, 'yyyy-MM') AS order_month,
dr.order_date,
dr.order_revenue,
SUM(order_revenue) OVER (PARTITION BY to_char(dr.order_date::timestamp, 'yyyy-MM')) AS monthly_order_revenue
FROM daily_revenue AS dr
ORDER BY 2;

SELECT dr.*,
SUM(order_revenue) OVER (PARTITION BY 1) AS total_order_revenue
FROM daily_revenue AS dr
ORDER BY 1;

-- RANKING

SELECT COUNT(*) FROM daily_product_revenue;

SELECT * FROM daily_product_revenue
ORDER BY order_date, order_revenue DESC;

-- rand()
-- dense_rank()
-- They are nothing but windowing or analytic functions.

-- Global Ranking rank() OVER (ORDER BY col1 DESC)
-- Ranking based on key or partition key rank() OVER (PARTITION BY col2 ORDER BY col1 DESC)

SELECT *
FROM daily_product_revenue
WHERE order_date = '2014-01-01 00:00:00.0'
ORDER BY order_revenue DESC;

SELECT order_date,
order_item_product_id,
order_revenue,
RANK() OVER (ORDER BY order_revenue DESC) AS rnk,
DENSE_RANK() OVER (ORDER BY order_revenue DESC) AS drnk
FROM daily_product_revenue
WHERE order_date = '2014-01-01 00:00:00.0'
ORDER BY order_revenue DESC;


SELECT order_date,
order_item_product_id,
order_revenue,
RANK() OVER (PARTITION BY order_date ORDER BY order_revenue DESC) AS rnk,
DENSE_RANK() OVER (PARTITION BY order_date ORDER BY order_revenue DESC) AS drnk
FROM daily_product_revenue
WHERE to_char(order_date::date, 'yyyy-MM') = '2014-01'
ORDER BY order_date, order_revenue DESC;

-- Filtering using sub-queries

SELECT * FROM (
SELECT order_date,
order_item_product_id,
order_revenue,
RANK() OVER (PARTITION BY order_date ORDER BY order_revenue DESC) AS rnk,
DENSE_RANK() OVER (PARTITION BY order_date ORDER BY order_revenue DESC) AS drnk
FROM daily_product_revenue
WHERE order_date = '2014-01-01 00:00:00.0'
) AS q
WHERE drnk <= 5
ORDER BY order_revenue DESC;

-- Filtering with CTA
WITH daily_product_revenue_ranks AS (
SELECT order_date,
order_item_product_id,
order_revenue,
RANK() OVER (PARTITION BY order_date ORDER BY order_revenue DESC) AS rnk,
DENSE_RANK() OVER (PARTITION BY order_date ORDER BY order_revenue DESC) AS drnk
FROM daily_product_revenue
WHERE order_date = '2014-01-01 00:00:00.0'
) SELECT * FROM daily_product_revenue_ranks
WHERE drnk <= 5
ORDER BY order_revenue DESC;

SELECT * FROM (
SELECT order_date,
order_item_product_id,
order_revenue,
RANK() OVER (PARTITION BY order_date ORDER BY order_revenue DESC) AS rnk,
DENSE_RANK() OVER (PARTITION BY order_date ORDER BY order_revenue DESC) AS drnk
FROM daily_product_revenue
WHERE to_char(order_date::date, 'yyyy-MM') = '2014-01'
) AS q
WHERE drnk <= 5
ORDER BY order_date, order_revenue DESC;

WITH daily_product_revenue_ranks AS (
SELECT order_date,
order_item_product_id,
order_revenue,
RANK() OVER (PARTITION BY order_date ORDER BY order_revenue DESC) AS rnk,
DENSE_RANK() OVER (PARTITION BY order_date ORDER BY order_revenue DESC) AS drnk
FROM daily_product_revenue
WHERE to_char(order_date::date, 'yyyy-MM') = '2014-01'
) SELECT * FROM daily_product_revenue_ranks
WHERE drnk <= 5
ORDER BY order_date, order_revenue DESC;

-- DIFFERENCE B/W RANK AND DENSRANK

CREATE TABLE student_scores (
	student_id INT PRIMARY KEY,
	student_score INT
);

INSERT INTO student_scores VALUES 
(1, 980),
(2, 960),
(3, 960),
(4, 990),
(5, 920),
(6, 960),
(7, 980),
(8, 960),
(9, 940),
(10, 940);

SELECT * FROM student_scores
ORDER BY student_score DESC;

SELECT *,
RANK() OVER (ORDER BY student_score DESC) AS student_rank,
DENSE_RANK() OVER (ORDER BY student_score DESC) AS student_drank
FROM student_scores
ORDER BY student_score DESC;

-- In RANK numbers may skipp, where as in DENS RANK numbers will not skip