EXPLAIN
SELECT * FROM orders WHERE order_id = 2;

EXPLAIN
SELECT o.*,
round(SUM(oi.order_item_subtotal)::numeric, 2) AS revenue
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_item_order_id
WHERE o.order_id = 2
GROUP BY o.order_id, o.order_date, o.order_customer_id, o.order_status;

-- Setting up stage to practice performance tuning

DROP INDEX orders_order_date_idx;
DROP INDEX order_items_oid_idx;

COMMIT;

ALTER TABLE order_items ADD
FOREIGN KEY (order_item_order_id) REFERENCES orders (order_id);

-- Interpriting Explain Plan
SELECT * FROM orders WHERE order_id = 2;
SELECT COUNT(*) FROM orders WHERE order_id = 2;

SELECT * FROM order_items WHERE order_item_order_id = 2;
SELECT COUNT(*) FROM order_items WHERE order_item_order_id = 2;

SELECT * FROM customers LIMIT 10;,

SELECT o.*, oi.* 
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_item_order_id
WHERE order_customer_id = 5;
-- time taken to exencut query is around: 129

-- Creating stored procedures to analise qurey performance
CREATE OR REPLACE PROCEDURE perfdemo()
LANGUAGE plpgsql
AS $$
DECLARE
cur_order_details CURSOR (a_customer_id INT) FOR
SELECT count(*)
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_item_order_id
WHERE o.order_customer_id = a_customer_id;
v_customer_id INT := 0;
v_order_item_count INT;
BEGIN
LOOP
EXIT WHEN v_customer_id >= 1000;
OPEN cur_order_details(v_customer_id);
FETCH cur_order_details INTO v_order_item_count;
v_customer_id = v_customer_id + 1;
CLOSE cur_order_details;
END LOOP;
END;
$$;

-- To invoke the Stored procedures
DO $$
BEGIN 
	CALL perfdemo();
END;
$$;
-- time take before enhansment is around: 49s.
-- time take after enhansment is around: 177msec.

-- Enhansing Query

ALTER TABLE orders
ADD FOREIGN KEY (order_customer_id) REFERENCES customers(customer_id);

CREATE INDEX orders_order_customer_id_idx
ON orders (order_customer_id);

CREATE INDEX order_items_order_item_order_id_idx
ON order_items (order_item_order_id);