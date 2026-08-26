/*
Purpose:
Add foreign-key constraints
*/

BEGIN;

ALTER TABLE orders
DROP CONSTRAINT IF EXISTS fk_orders_customer;

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);


ALTER TABLE order_items
DROP CONSTRAINT IF EXISTS fk_order_items_order;

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


ALTER TABLE order_items
DROP CONSTRAINT IF EXISTS fk_order_items_product;

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);


ALTER TABLE payments
DROP CONSTRAINT IF EXISTS fk_payments_order;

ALTER TABLE payments
ADD CONSTRAINT fk_payments_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

COMMIT;
