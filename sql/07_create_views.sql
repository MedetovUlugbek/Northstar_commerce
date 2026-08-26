CREATE OR REPLACE VIEW vw_order_financials AS
WITH item_totals AS (
    SELECT
        order_id,
        COUNT(*) AS item_count,
        SUM(price) AS merchandise_value,
        SUM(freight_value) AS freight_value
    FROM order_items
    GROUP BY order_id
),
payment_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS payment_value
    FROM payments
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    COALESCE(i.item_count, 0) AS item_count,
    COALESCE(i.merchandise_value, 0) AS merchandise_value,
    COALESCE(i.freight_value, 0) AS freight_value,
    COALESCE(p.payment_value, 0) AS payment_value
FROM orders o
LEFT JOIN item_totals i
    ON i.order_id = o.order_id
LEFT JOIN payment_totals p
    ON p.order_id = o.order_id;


CREATE OR REPLACE VIEW vw_delivery_performance AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_state,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    EXTRACT(EPOCH FROM (
        o.order_delivered_customer_date - o.order_purchase_timestamp
    )) / 86400.0 AS delivery_days,
    EXTRACT(EPOCH FROM (
        o.order_delivered_customer_date - o.order_estimated_delivery_date
    )) / 86400.0 AS days_from_estimate,
    o.order_delivered_customer_date <= o.order_estimated_delivery_date AS is_on_time
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp IS NOT NULL
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
  AND o.order_delivered_customer_date >= o.order_purchase_timestamp;


CREATE OR REPLACE VIEW vw_category_sales AS
SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Uncategorized'
    ) AS category,
    COUNT(*) AS units,
    COUNT(DISTINCT oi.order_id) AS orders,
    SUM(oi.price) AS merchandise_value
FROM order_items oi
JOIN products p
    ON p.product_id = oi.product_id
LEFT JOIN category_translation ct
    ON ct.product_category_name = p.product_category_name
GROUP BY 1;


CREATE OR REPLACE VIEW vw_customer_state_performance AS
SELECT
    c.customer_state AS state,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT c.customer_unique_id) AS customers,
    SUM(oi.price) AS merchandise_value
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_state;

CREATE OR REPLACE VIEW vw_executive_kpis AS
WITH order_metrics AS (
    SELECT
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT c.customer_unique_id) AS unique_customers
    FROM orders o
    JOIN customers c
        ON c.customer_id = o.customer_id
),
financial_metrics AS (
    SELECT
        SUM(price) AS merchandise_value,
        SUM(freight_value) AS freight_value
    FROM order_items
),
customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
repeat_metric AS (
    SELECT
        100.0 * COUNT(*) FILTER (WHERE order_count > 1)
        / COUNT(*) AS repeat_customer_rate
    FROM customer_order_counts
)
SELECT
    o.total_orders,
    o.unique_customers,
    f.merchandise_value,
    f.freight_value,
    r.repeat_customer_rate
FROM order_metrics o
CROSS JOIN financial_metrics f
CROSS JOIN repeat_metric r;