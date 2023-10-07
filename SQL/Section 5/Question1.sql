-- Compute daily product revenue considering only complete or closed orders.

-- BASIC QUERIES
SELECT * FROM orders;

SELECT DISTINCT order_status FROM orders ORDER BY 1;

SELECT DISTINCT order_status FROM orders;

SELECT COUNT(DISTINCT order_status) FROM orders;

SELECT order_status ,COUNT(*) AS order_count FROM orders GROUP BY order_status;
SELECT order_status, COUNT(*) AS order_count FROM orders GROUP BY 1 ORDER BY 2 DESC;

SELECT order_date, COUNT(*) AS order_count FROM orders GROUP BY 1 ORDER BY 2 DESC;

SELECT to_char(order_date, 'yyyy-mm') AS order_year_month, COUNT(*) AS order_count 
FROM orders 
GROUP BY 1 
ORDER BY 2 DESC;

SELECT order_item_order_id,
	round(sum(order_item_subtotal)::numeric) AS order_revenue
FROM order_items
GROUP BY 1
ORDER BY 1;


SELECT order_item_order_id,
	round(sum(order_item_subtotal)::numeric, 2) AS order_revenue
FROM order_items
GROUP BY 1
ORDER BY 1;

SELECT * FROM orders WHERE order_status = 'COMPLETE' OR order_status = 'CLOSED';

SELECT * FROM orders WHERE order_status IN ('COMPLETE', 'CLOSED');

SELECT * FROM order_items;

SELECT sum(order_item_subtotal) FROM order_items WHERE order_item_order_id = 2;  


SELECT order_date, COUNT(*) AS order_count
FROM orders 
WHERE order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1
ORDER BY 2 DESC;
-- ABOVE QUERY EXECUTEION FLOW

-- 1) FROM -> it will reade the orders data into menory
-- 2) WHERE -> then condition will get applied and new data will get stored in memory
-- 3) GROUP BY -> then group by and gets its count and get stored in memory
-- 4) SELECT
-- 5) ORDER BY

-- HAVING IS USED TO FILTER AGGRIGATED RESULTS
SELECT order_date, COUNT(*) AS order_count
FROM orders 
WHERE order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1
HAVING COUNT(*) >= 120
ORDER BY 2 DESC;

SELECT order_item_order_id,
	round(sum(order_item_subtotal)::numeric) AS order_revenue
FROM order_items
GROUP BY 1
HAVING round(sum(order_item_subtotal)::numeric, 2) >= 2000
ORDER BY 1;
