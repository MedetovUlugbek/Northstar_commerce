/*
==========================================================
EXPLORATORY DATA ANALYSIS
Purpose: Describe the dataset and reveal broad patterns.
==========================================================
*/

-- 1. Dataset date range and boundary-month completeness
WITH date_bounds AS (
    SELECT
        MIN(order_purchase_timestamp) AS first_order_timestamp,
        MAX(order_purchase_timestamp) AS last_order_timestamp
    FROM orders
)
SELECT
    first_order_timestamp,
    last_order_timestamp,
    DATE_TRUNC('month', first_order_timestamp)::date AS first_order_month,
    CASE
        WHEN first_order_timestamp::date
            > DATE_TRUNC('month', first_order_timestamp)::date
            THEN 'Incomplete'
        ELSE 'Complete'
    END AS first_month_status,
    DATE_TRUNC('month', last_order_timestamp)::date AS last_order_month,
    CASE
        WHEN last_order_timestamp::date
            < (DATE_TRUNC('month', last_order_timestamp)
                + INTERVAL '1 month - 1 day')::date
            THEN 'Incomplete'
        ELSE 'Complete'
    END AS last_month_status
FROM date_bounds;


-- 2. Orders by year
SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp)::integer AS order_year,
    COUNT(*) AS order_count
FROM orders
GROUP BY 1
ORDER BY 1;


-- 3. Orders by month, with boundary months identified
WITH date_bounds AS (
    SELECT
        MIN(order_purchase_timestamp) AS first_order_timestamp,
        MAX(order_purchase_timestamp) AS last_order_timestamp
    FROM orders
),
monthly_orders AS (
    SELECT
        DATE_TRUNC('month', order_purchase_timestamp)::date AS order_month,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY 1
)
SELECT
    mo.order_month,
    mo.order_count,
    CASE
        WHEN mo.order_month = DATE_TRUNC('month', db.first_order_timestamp)::date
             AND db.first_order_timestamp::date > mo.order_month
            THEN 'Incomplete boundary month'
        WHEN mo.order_month = DATE_TRUNC('month', db.last_order_timestamp)::date
             AND db.last_order_timestamp::date
                 < (DATE_TRUNC('month', db.last_order_timestamp)
                    + INTERVAL '1 month - 1 day')::date
            THEN 'Incomplete boundary month'
        ELSE 'Complete month'
    END AS month_status
FROM monthly_orders mo
CROSS JOIN date_bounds db
ORDER BY mo.order_month;


-- 4. Orders by weekday
SELECT
    EXTRACT(ISODOW FROM order_purchase_timestamp)::integer AS weekday_number,
    TO_CHAR(order_purchase_timestamp, 'FMDay') AS weekday_name,
    COUNT(*) AS order_count
FROM orders
GROUP BY 1, 2
ORDER BY 1;


-- 5. Orders by purchase hour
SELECT
    EXTRACT(HOUR FROM order_purchase_timestamp)::integer AS purchase_hour,
    COUNT(*) AS order_count
FROM orders
GROUP BY 1
ORDER BY 1;


-- 6. Order-status distribution
SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS order_share_pct
FROM orders
GROUP BY order_status
ORDER BY order_count DESC, order_status;


-- 7. Customers and orders by state
SELECT
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS unique_customers,
    COUNT(DISTINCT o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY order_count DESC, c.customer_state;


-- 8. Top cities by orders
SELECT
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS order_count
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
GROUP BY c.customer_city, c.customer_state
ORDER BY order_count DESC, c.customer_state, c.customer_city
LIMIT 20;


-- 9. Payment-type frequency
SELECT
    payment_type,
    COUNT(*) AS payment_record_count,
    COUNT(DISTINCT order_id) AS order_count
FROM payments
GROUP BY payment_type
ORDER BY payment_record_count DESC, payment_type;


-- 10. Products per category
SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Uncategorized'
    ) AS product_category,
    COUNT(DISTINCT p.product_id) AS product_count
FROM products p
LEFT JOIN category_translation ct
    ON ct.product_category_name = p.product_category_name
GROUP BY 1
ORDER BY product_count DESC, product_category;


-- 11. Minimum, average, and maximum item price
SELECT
    ROUND(MIN(price), 2) AS min_item_price,
    ROUND(AVG(price), 2) AS avg_item_price,
    ROUND(MAX(price), 2) AS max_item_price
FROM order_items;


-- 12. Minimum, average, and maximum freight value
SELECT
    ROUND(MIN(freight_value), 2) AS min_freight_value,
    ROUND(AVG(freight_value), 2) AS avg_freight_value,
    ROUND(MAX(freight_value), 2) AS max_freight_value
FROM order_items;


-- 13. Items-per-order distribution
WITH items_per_order AS (
    SELECT
        order_id,
        COUNT(*) AS item_count
    FROM order_items
    GROUP BY order_id
)
SELECT
    item_count,
    COUNT(*) AS order_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS order_share_pct
FROM items_per_order
GROUP BY item_count
ORDER BY item_count;


-- 14. Highest-value orders by merchandise value
SELECT
    order_id,
    COUNT(*) AS item_count,
    ROUND(SUM(price), 2) AS merchandise_value
FROM order_items
GROUP BY order_id
ORDER BY merchandise_value DESC, order_id
LIMIT 20;


-- 15. Longest valid delivery times among delivered orders
SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date,
    ROUND(
        EXTRACT(EPOCH FROM (
            order_delivered_customer_date - order_purchase_timestamp
        )) / 86400.0,
        2
    ) AS delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date >= order_purchase_timestamp
ORDER BY delivery_days DESC, order_id
LIMIT 20;
