-- Create a new table by name orders_completed with orders where status is either completed or closed

CREATE TABLE orders_completed
AS 
SELECT * FROM orders
WHERE order_status IN ('complete', 'closed');

-- Check the table structure: orders_completed - PASS
-- Get the count in orders_completed - PASS
SELECT COUNT(*) FROM orders_completed; -- FAIL

SELECT COUNT(*) FROM orders; 
SELECT * FROM orders LIMIT 10;
SELECT * FROM orders WHERE order_status IN ('complete', 'closed');
SELECT * FROM orders WHERE order_status IN ('COMPLETE', 'CLOSED');
SELECT COUNT(*) FROM orders WHERE order_status IN ('COMPLETE', 'CLOSED');

DROP TABLE orders_completed;

CREATE TABLE orders_completed
AS 
SELECT * FROM orders
WHERE order_status IN ('COMPLETE', 'CLOSED');

SELECT COUNT(*) FROM orders_completed; -- PASS
-- If count is not 0, then review the data by selecting firest rows(with all columns) - PASS
SELECT * FROM orders_completed LIMIT 100;

-- ***BEST PRACTICE***

-- Understand the req
SELECT * FROM orders LIMIT 10;
SELECT DISTINCT order_status FROM orders;

-- Then come up with solution
-- Then execute all TestCases