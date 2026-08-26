-- Validation 1: Row Count Check

SELECT 'customers' AS table_name, COUNT(*) AS row_count 
FROM customers

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'payments', COUNT(*)
FROM payments

UNION ALL

SELECT 'category_translation', COUNT(*)
FROM category_translation

ORDER BY table_name;

-- Validation 2: Primary Key and Grain Check

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids,
    COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_customer_ids
FROM customers;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_order_ids,
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_order_ids
FROM orders;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_product_ids,
    COUNT(*) - COUNT(DISTINCT product_id) AS duplicate_product_ids
FROM products;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(DISTINCT (order_id, order_item_id))
        AS duplicate_order_items
FROM order_items;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(DISTINCT (order_id, payment_sequential))
        AS duplicate_payments
FROM payments;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_category_name) AS unique_categories,
    COUNT(*) - COUNT(DISTINCT product_category_name)
        AS duplicate_categories
FROM category_translation;


--- Validation 3: Missing Value Check

SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE customer_unique_id IS NULL
    ) AS missing_unique_customer_id,
    COUNT(*) FILTER (
        WHERE customer_city IS NULL
    ) AS missing_city,
    COUNT(*) FILTER (
        WHERE customer_state IS NULL
    ) AS missing_state
FROM customers;

SELECT
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_id,
    COUNT(*) FILTER (
        WHERE order_status IS NULL
    ) AS missing_order_status,
    COUNT(*) FILTER (
        WHERE order_purchase_timestamp IS NULL
    ) AS missing_purchase_timestamp,
    COUNT(*) FILTER (
        WHERE order_delivered_customer_date IS NULL
    ) AS missing_delivery_date,
    COUNT(*) FILTER (
        WHERE order_estimated_delivery_date IS NULL
    ) AS missing_estimated_delivery_date
FROM orders;

SELECT
    COUNT(*) AS total_products,
    COUNT(*) FILTER (
        WHERE product_category_name IS NULL
    ) AS missing_category,
    COUNT(*) FILTER (
        WHERE product_weight_g IS NULL
    ) AS missing_weight,
    COUNT(*) FILTER (
        WHERE product_length_cm IS NULL
    ) AS missing_length,
    COUNT(*) FILTER (
        WHERE product_height_cm IS NULL
    ) AS missing_height,
    COUNT(*) FILTER (
        WHERE product_width_cm IS NULL
    ) AS missing_width
FROM products;

SELECT
    COUNT(*) AS total_order_items,
    COUNT(*) FILTER (
        WHERE product_id IS NULL
    ) AS missing_product_id,
    COUNT(*) FILTER (
        WHERE seller_id IS NULL
    ) AS missing_seller_id,
    COUNT(*) FILTER (
        WHERE price IS NULL
    ) AS missing_price,
    COUNT(*) FILTER (
        WHERE freight_value IS NULL
    ) AS missing_freight_value
FROM order_items;

SELECT
    COUNT(*) AS total_payments,
    COUNT(*) FILTER (
        WHERE payment_type IS NULL
    ) AS missing_payment_type,
    COUNT(*) FILTER (
        WHERE payment_installments IS NULL
    ) AS missing_installments,
    COUNT(*) FILTER (
        WHERE payment_value IS NULL
    ) AS missing_payment_value
FROM payments;


-- Validation 4: REFERENTIAL-INTEGRITY check

SELECT COUNT(*) AS orders_without_matching_customer
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS order_items_without_matching_order
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS order_items_without_matching_product
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS payments_without_matching_order
FROM payments pay
LEFT JOIN orders o
    ON pay.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Validation 5: Numeric Values Check

SELECT
    COUNT(*) FILTER (
        WHERE price < 0
    ) AS negative_prices,
    COUNT(*) FILTER (
        WHERE freight_value < 0
    ) AS negative_freight_values,
    COUNT(*) FILTER (
        WHERE price = 0
    ) AS zero_price_items
FROM order_items;

SELECT
    COUNT(*) FILTER (
        WHERE payment_value < 0
    ) AS negative_payment_values,
    COUNT(*) FILTER (
        WHERE payment_installments < 0
    ) AS negative_installments,
    COUNT(*) FILTER (
        WHERE payment_installments = 0
    ) AS zero_installment_payments
FROM payments;

SELECT
    COUNT(*) FILTER (
        WHERE product_weight_g < 0
    ) AS negative_weight,
    COUNT(*) FILTER (
        WHERE product_length_cm < 0
    ) AS negative_length,
    COUNT(*) FILTER (
        WHERE product_height_cm < 0
    ) AS negative_height,
    COUNT(*) FILTER (
        WHERE product_width_cm < 0
    ) AS negative_width
FROM products;


-- Validation 6: Date Consistency Check

-- Approval should not occur before purchase
SELECT COUNT(*) AS approval_before_purchase
FROM orders
WHERE order_approved_at < order_purchase_timestamp;

-- Carrier delivery should not occur before purchase
SELECT COUNT(*) AS carrier_date_before_purchase
FROM orders
WHERE order_delivered_carrier_date < order_purchase_timestamp;

-- Customer delivery should not occur before purchase
SELECT COUNT(*) AS delivery_before_purchase
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp;

-- Customer delivery should not occur before carrier delivery
SELECT COUNT(*) AS customer_delivery_before_carrier
FROM orders
WHERE order_delivered_customer_date < order_delivered_carrier_date;

-- Delivered orders missing an actual delivery date
SELECT COUNT(*) AS delivered_orders_missing_delivery_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;

-- Validation 7: Order Status Check

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Validation 8: Payment Type Check

SELECT
    payment_type,
    COUNT(*) AS total_payments,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payments DESC;

-- Validation 9: Category Translation Check

SELECT
    COUNT(DISTINCT p.product_category_name) AS categories_without_translation,
    COALESCE(
        ARRAY_AGG(DISTINCT p.product_category_name ORDER BY p.product_category_name),
        '{}'
    ) AS missing_category_translation
FROM products p
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND ct.product_category_name IS NULL;
