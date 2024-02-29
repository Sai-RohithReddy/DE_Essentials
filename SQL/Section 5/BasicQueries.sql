-- Compute daily product revenue considering only complete or closed orders.

-- BASIC QUERIES
SELECT * FROM orders;

SELECT DISTINCT order_status FROM orders ORDER BY 1;

SELECT DISTINCT order_status FROM orders;

SELECT * FROM orders WHERE order_status = 'COMPLETE';

SELECT * FROM orders WHERE order_status = 'CLOSED';

SELECT * FROM orders WHERE order_status = 'COMPLETE' OR order_status = 'CLOSED';
SELECT * FROM orders WHERE order_status IN ('COMPLETE', 'CLOSED');

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
	round(sum(order_item_subtotal)::numeric, 2) AS order_revenue
FROM order_items
GROUP BY 1
HAVING round(sum(order_item_subtotal)::numeric, 2) >= 2000
ORDER BY 1;

-- INNER JOIN, OUTER JOIN, LEFT OUTE JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN, CARTESIAN PRODUCT OR CROSS JOIN.
-- INNER JOIN

SELECT * FROM orders AS o
	INNER JOIN order_items AS oi
		ON o.order_id = oi.order_item_order_id;
		
SELECT o.* FROM orders AS o
	JOIN order_items AS oi
		ON o.order_id = oi.order_item_order_id;
		
SELECT o.order_date, 
	oi.order_item_product_id, 
	oi.order_item_subtotal 
FROM orders AS o
	INNER JOIN order_items AS oi
		ON o.order_id = oi.order_item_order_id;
		
-- OUTER JOIN 
-- LEFT OUTER JOIN

SELECT COUNT(DISTINCT order_id) FROM orders;
SELECT COUNT(DISTINCT order_item_order_id) FROM order_items;

SELECT o.order_id,
	oi.order_item_id,
	o.order_date, 
	oi.order_item_product_id, 
	oi.order_item_subtotal 
FROM orders AS o
	LEFT OUTER JOIN order_items AS oi
		ON o.order_id = oi.order_item_order_id
ORDER BY 1;

-- APPLYING FILTERS AND SGGRIGATION ON JOINS

SELECT o.order_date,
	oi.order_item_product_id,
	round(sum(oi.order_item_subtotal)::numeric, 2) AS order_revenue
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1, 2
ORDER BY 1, 2 DESC;

-- VIEWS: They are not physical structures like tables. 
-- They dosent hold any data. 
-- We create views using queries against tables. 
-- We typically create views for commonly used quereies.
-- They only have the defination in the form of queries pointhin to tables or other views.

CREATE VIEW order_details_v AS
SELECT o.*, 
	oi.order_item_product_id, 
	oi.order_item_subtotal 
FROM orders AS o
	JOIN order_items AS oi
		ON o.order_id = oi.order_item_order_id;
		
SELECT * FROM order_details_v WHERE order_id = 2;

CREATE OR REPLACE VIEW order_details_v AS
SELECT o.*, 
	oi.order_item_product_id, 
	oi.order_item_subtotal,
	oi.order_item_id
FROM orders AS o
	JOIN order_items AS oi
		ON o.order_id = oi.order_item_order_id;
		
-- CTE (Common Table Expressions), they are similar to views, but they are not views.
-- Views structure will stay permanintely in the DB, but CTE is not a premanent structure.
-- Views persist in the DB in the form of view defination, whereas CTE's dosen't persist in the DB.
-- Scope - CTE within the query, Views we can use it in multiple queries.

WITH order_details_cte AS
(SELECT o.*, 
	oi.order_item_product_id, 
	oi.order_item_subtotal,
	oi.order_item_id
FROM orders AS o
	JOIN order_items AS oi
		ON o.order_id = oi.order_item_order_id)
SELECT * FROM order_details_cte;

WITH order_details_cte AS
(SELECT o.*, 
	oi.order_item_product_id, 
	oi.order_item_subtotal,
	oi.order_item_id
FROM orders AS o
	JOIN order_items AS oi
		ON o.order_id = oi.order_item_order_id)
SELECT * FROM order_details_cte
WHERE order_id = 2;

SELECT * 
FROM products AS p
LEFT OUTER JOIN order_details_v AS odv
ON p.product_id = odv.order_item_product_id
WHERE odv.order_item_product_id IS NULL;

SELECT * 
FROM products AS p
LEFT OUTER JOIN order_details_v AS odv
ON p.product_id = odv.order_item_product_id
WHERE to_char(odv.order_date::timestamp, 'yyyy-mm') = '2014-01'
AND odv.order_item_product_id IS NULL;

-- There is a bug in the above bug, to trouble shoot it..

SELECT * FROM products AS p
WHERE NOT EXISTS (
SELECT 1 FROM order_details_v AS odv
WHERE p.product_id = odv.order_item_product_id
AND to_char(odv.order_date::timestamp, 'yyyy-mm') = '2014-01'
);

-- Fixing of above query

SELECT * 
FROM products AS p
LEFT OUTER JOIN order_details_v AS odv
ON p.product_id = odv.order_item_product_id
AND to_char(odv.order_date::timestamp, 'yyyy-MM') = '2014-01'
WHERE odv.order_item_product_id IS NULL;