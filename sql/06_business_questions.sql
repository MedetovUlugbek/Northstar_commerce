/*
==========================================================
SECTION 1: EXECUTIVE KPIS
==========================================================
*/

-- 1.1 Total orders
SELECT COUNT(*) AS total_orders
FROM orders;
-- Helps us understand the overall scale of order activity.


-- 1.2 Delivered orders
SELECT COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'delivered';
-- Helps us measure how many orders reached successful completion.


-- 1.3 Total merchandise value
SELECT ROUND(SUM(price), 2) AS total_merchandise_value
FROM order_items;
-- Helps us measure total product sales before shipping charges.


-- 1.4 Total freight value
SELECT ROUND(SUM(freight_value), 2) AS total_freight_value
FROM order_items;
-- Helps us quantify the shipping charges paid across all order items.


-- 1.5 Average merchandise value per order
WITH order_values AS (
    SELECT
        order_id,
        SUM(price) AS merchandise_value
    FROM order_items
    GROUP BY order_id
)
SELECT ROUND(AVG(merchandise_value), 2) AS avg_merchandise_value_per_order
FROM order_values;
-- Helps us understand the typical product value of an order.


-- 1.6 Unique actual customers who placed an order
SELECT COUNT(DISTINCT c.customer_unique_id) AS unique_actual_customers
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id;
-- Helps us measure the size of the actual customer base.


/*
==========================================================
SECTION 2: SALES PERFORMANCE
==========================================================
*/

-- 2.1 Monthly merchandise value
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp)::date AS order_month,
    ROUND(SUM(oi.price), 2) AS merchandise_value
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY 1
ORDER BY 1;
-- Helps us track sales value and seasonality over time.


-- 2.2 Month-over-month merchandise-value growth
WITH monthly_values AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS order_month,
        SUM(oi.price) AS merchandise_value
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY 1
),
values_with_prior_month AS (
    SELECT
        order_month,
        merchandise_value,
        LAG(merchandise_value) OVER (ORDER BY order_month) AS prior_month_value
    FROM monthly_values
)
SELECT
    order_month,
    ROUND(merchandise_value, 2) AS merchandise_value,
    ROUND(prior_month_value, 2) AS prior_month_value,
    ROUND(
        100.0 * (merchandise_value - prior_month_value)
        / NULLIF(prior_month_value, 0),
        2
    ) AS month_over_month_growth_pct
FROM values_with_prior_month
ORDER BY order_month;
-- Helps us identify whether sales are growing or declining month to month.


-- 2.3 Highest and lowest performing months
WITH monthly_values AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS order_month,
        SUM(oi.price) AS merchandise_value
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY 1
),
ranked_months AS (
    SELECT
        order_month,
        merchandise_value,
        RANK() OVER (ORDER BY merchandise_value DESC) AS highest_rank,
        RANK() OVER (ORDER BY merchandise_value) AS lowest_rank
    FROM monthly_values
)
SELECT
    CASE WHEN highest_rank = 1 THEN 'Highest' ELSE 'Lowest' END AS performance,
    order_month,
    ROUND(merchandise_value, 2) AS merchandise_value
FROM ranked_months
WHERE highest_rank = 1 OR lowest_rank = 1
ORDER BY merchandise_value DESC;
-- Helps us identify the strongest and weakest sales months.


/*
==========================================================
SECTION 3: CUSTOMER ANALYSIS
==========================================================
*/

-- Reusable customer definition: aggregate orders by actual customer.

-- 3.1 One-time customers
WITH customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT COUNT(*) AS one_time_customers
FROM customer_order_counts
WHERE order_count = 1;
-- Helps us measure how much of the customer base purchased only once.


-- 3.2 Repeat customers
WITH customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT COUNT(*) AS repeat_customers
FROM customer_order_counts
WHERE order_count > 1;
-- Helps us measure the number of customers who returned to purchase again.


-- 3.3 Repeat customer rate
WITH customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT ROUND(
    100.0 * COUNT(*) FILTER (WHERE order_count > 1)
    / NULLIF(COUNT(*), 0),
    2
) AS repeat_customer_rate_pct
FROM customer_order_counts;
-- Helps us evaluate customer retention and loyalty.


-- 3.4 Highest number of orders placed by an actual customer
WITH customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    order_count
FROM customer_order_counts
WHERE order_count = (SELECT MAX(order_count) FROM customer_order_counts);
-- Helps us identify the most active customers by order frequency.


-- 3.5 Merchandise value by customer state
SELECT
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS merchandise_value
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_state
ORDER BY merchandise_value DESC, c.customer_state;
-- Helps us identify the states contributing the most product sales value.


/*
==========================================================
SECTION 4: PRODUCT AND CATEGORY PERFORMANCE
==========================================================
*/

-- 4.1 Categories by units sold
SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Uncategorized'
    ) AS product_category,
    COUNT(*) AS units_sold
FROM order_items oi
JOIN products p
    ON p.product_id = oi.product_id
LEFT JOIN category_translation ct
    ON ct.product_category_name = p.product_category_name
GROUP BY 1
ORDER BY units_sold DESC, product_category;
-- Helps us identify the product categories with the highest sales volume.


-- 4.2 Categories by merchandise value
SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Uncategorized'
    ) AS product_category,
    ROUND(SUM(oi.price), 2) AS merchandise_value
FROM order_items oi
JOIN products p
    ON p.product_id = oi.product_id
LEFT JOIN category_translation ct
    ON ct.product_category_name = p.product_category_name
GROUP BY 1
ORDER BY merchandise_value DESC, product_category;
-- Helps us identify the categories contributing the most sales value.


-- 4.3 Categories by number of orders
SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Uncategorized'
    ) AS product_category,
    COUNT(DISTINCT oi.order_id) AS order_count
FROM order_items oi
JOIN products p
    ON p.product_id = oi.product_id
LEFT JOIN category_translation ct
    ON ct.product_category_name = p.product_category_name
GROUP BY 1
ORDER BY order_count DESC, product_category;
-- Helps us understand how frequently each category appears in customer orders.


-- 4.4 Average item price by category
SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Uncategorized'
    ) AS product_category,
    ROUND(AVG(oi.price), 2) AS avg_item_price,
    COUNT(*) AS units_sold
FROM order_items oi
JOIN products p
    ON p.product_id = oi.product_id
LEFT JOIN category_translation ct
    ON ct.product_category_name = p.product_category_name
GROUP BY 1
ORDER BY avg_item_price DESC, product_category;
-- Helps us distinguish premium-priced categories from lower-priced categories.


-- 4.5 Top products by units sold
SELECT
    oi.product_id,
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Uncategorized'
    ) AS product_category,
    COUNT(*) AS units_sold
FROM order_items oi
JOIN products p
    ON p.product_id = oi.product_id
LEFT JOIN category_translation ct
    ON ct.product_category_name = p.product_category_name
GROUP BY oi.product_id, product_category
ORDER BY units_sold DESC, oi.product_id
LIMIT 20;
-- Helps us identify the individual products with the greatest demand.


-- 4.6 Top products by merchandise value
SELECT
    oi.product_id,
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Uncategorized'
    ) AS product_category,
    ROUND(SUM(oi.price), 2) AS merchandise_value
FROM order_items oi
JOIN products p
    ON p.product_id = oi.product_id
LEFT JOIN category_translation ct
    ON ct.product_category_name = p.product_category_name
GROUP BY oi.product_id, product_category
ORDER BY merchandise_value DESC, oi.product_id
LIMIT 20;
-- Helps us identify the individual products contributing the most sales value.


-- 4.7 Unsold products
SELECT COUNT(*) AS unsold_products
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.product_id
);
-- Helps us identify products with no recorded sales activity.


-- 4.8 Freight-to-price ratio by category
SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Uncategorized'
    ) AS product_category,
    ROUND(
        SUM(oi.freight_value) / NULLIF(SUM(oi.price), 0),
        4
    ) AS freight_to_price_ratio,
    ROUND(
        100.0 * SUM(oi.freight_value) / NULLIF(SUM(oi.price), 0),
        2
    ) AS freight_to_price_pct
FROM order_items oi
JOIN products p
    ON p.product_id = oi.product_id
LEFT JOIN category_translation ct
    ON ct.product_category_name = p.product_category_name
GROUP BY 1
ORDER BY freight_to_price_ratio DESC NULLS LAST, product_category;
-- Helps us identify categories where shipping is costly relative to item price.


/*
==========================================================
SECTION 5: PAYMENT ANALYSIS
==========================================================
*/

-- 5.1 Payment type share
SELECT
    payment_type,
    COUNT(*) AS payment_record_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS payment_record_share_pct
FROM payments
GROUP BY payment_type
ORDER BY payment_record_share_pct DESC, payment_type;
-- Helps us understand customer payment-method preferences.


-- 5.2 Total and average payment value by type
SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC, payment_type;
-- Helps us compare payment methods by both total value and typical transaction size.


-- 5.3 Orders with multiple payment records
WITH payment_records_per_order AS (
    SELECT
        order_id,
        COUNT(*) AS payment_record_count
    FROM payments
    GROUP BY order_id
)
SELECT COUNT(*) AS orders_with_multiple_payment_records
FROM payment_records_per_order
WHERE payment_record_count > 1;
-- Helps us measure how often an order is split across multiple payment records.


-- 5.4 Orders with multiple payment types
WITH payment_types_per_order AS (
    SELECT
        order_id,
        COUNT(DISTINCT payment_type) AS payment_type_count
    FROM payments
    GROUP BY order_id
)
SELECT COUNT(*) AS orders_with_multiple_payment_types
FROM payment_types_per_order
WHERE payment_type_count > 1;
-- Helps us identify orders that combine different payment methods.


-- 5.5 Average valid credit-card installments
SELECT ROUND(AVG(payment_installments), 2) AS avg_credit_card_installments
FROM payments
WHERE payment_type = 'credit_card'
  AND payment_installments > 0;
-- Helps us understand typical credit-card financing behavior.


-- 5.6 Valid credit-card installment distribution
SELECT
    payment_installments,
    COUNT(*) AS payment_record_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS payment_record_share_pct
FROM payments
WHERE payment_type = 'credit_card'
  AND payment_installments > 0
GROUP BY payment_installments
ORDER BY payment_record_count DESC, payment_installments;
-- Helps us identify the installment plans customers use most frequently.


/*
==========================================================
SECTION 6: ORDER STATUS AND CANCELLATION
==========================================================
*/

-- 6.1 Delivered, canceled, unavailable, and incomplete percentages
WITH status_groups AS (
    SELECT
        CASE
            WHEN order_status = 'delivered' THEN 'delivered'
            WHEN order_status = 'canceled' THEN 'canceled'
            WHEN order_status = 'unavailable' THEN 'unavailable'
            ELSE 'incomplete'
        END AS status_group
    FROM orders
)
SELECT
    status_group,
    COUNT(*) AS order_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS order_share_pct
FROM status_groups
GROUP BY status_group
ORDER BY order_count DESC, status_group;
-- Helps us compare successful orders with cancellations and other incomplete outcomes.


-- 6.2 Monthly cancellation rate
SELECT
    DATE_TRUNC('month', order_purchase_timestamp)::date AS order_month,
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE order_status = 'canceled') AS canceled_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_status = 'canceled')
        / NULLIF(COUNT(*), 0),
        2
    ) AS cancellation_rate_pct
FROM orders
GROUP BY 1
ORDER BY 1;
-- Helps us detect months with unusually high order cancellation levels.


-- 6.3 Cancellation rate by state (minimum 100 orders)
SELECT
    c.customer_state,
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE o.order_status = 'canceled') AS canceled_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE o.order_status = 'canceled')
        / NULLIF(COUNT(*), 0),
        2
    ) AS cancellation_rate_pct
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
GROUP BY c.customer_state
HAVING COUNT(*) >= 100
ORDER BY cancellation_rate_pct DESC, total_orders DESC, c.customer_state;
-- Helps us identify states with meaningful cancellation problems.


/*
==========================================================
SECTION 7: DELIVERY AND OPERATIONS
==========================================================
*/

-- 7.1 Average purchase-to-approval time
SELECT ROUND(
    AVG(EXTRACT(EPOCH FROM (order_approved_at - order_purchase_timestamp)) / 3600.0),
    2
) AS avg_purchase_to_approval_hours
FROM orders
WHERE order_purchase_timestamp IS NOT NULL
  AND order_approved_at IS NOT NULL
  AND order_approved_at >= order_purchase_timestamp;
-- Helps us measure payment approval and initial processing speed.


-- 7.2 Average purchase-to-carrier time
SELECT ROUND(
    AVG(
        EXTRACT(EPOCH FROM (order_delivered_carrier_date - order_purchase_timestamp))
        / 3600.0
    ),
    2
) AS avg_purchase_to_carrier_hours
FROM orders
WHERE order_purchase_timestamp IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date >= order_purchase_timestamp;
-- Helps us measure how quickly orders are prepared and handed to carriers.


-- 7.3 Average carrier-to-customer time
SELECT ROUND(
    AVG(
        EXTRACT(EPOCH FROM (
            order_delivered_customer_date - order_delivered_carrier_date
        )) / 86400.0
    ),
    2
) AS avg_carrier_to_customer_days
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date >= order_delivered_carrier_date;
-- Helps us measure the carrier's average transit time to the customer.


-- 7.4 Average and median total delivery time
WITH valid_delivery_times AS (
    SELECT
        EXTRACT(EPOCH FROM (
            order_delivered_customer_date - order_purchase_timestamp
        )) / 86400.0 AS delivery_days
    FROM orders
    WHERE order_status = 'delivered'
      AND order_purchase_timestamp IS NOT NULL
      AND order_delivered_customer_date IS NOT NULL
      AND order_delivered_customer_date >= order_purchase_timestamp
)
SELECT
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY delivery_days)::numeric,
        2
    ) AS median_delivery_days
FROM valid_delivery_times;
-- Helps us compare typical delivery speed with the average affected by outliers.


-- 7.5 On-time delivery rate
SELECT
    COUNT(*) AS eligible_orders,
    COUNT(*) FILTER (
        WHERE order_delivered_customer_date <= order_estimated_delivery_date
    ) AS on_time_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE order_delivered_customer_date <= order_estimated_delivery_date
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS on_time_delivery_rate_pct
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
-- Helps us evaluate how reliably delivery promises are met.


-- 7.6 Late orders
SELECT COUNT(*) AS late_orders
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date > order_estimated_delivery_date;
-- Helps us quantify orders that missed their promised delivery date.


-- 7.7 Average days early and average days late
-- Separate averages prevent early and late deliveries from canceling each other out.
SELECT
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM (
                order_estimated_delivery_date - order_delivered_customer_date
            )) / 86400.0
        ) FILTER (
            WHERE order_delivered_customer_date < order_estimated_delivery_date
        ),
        2
    ) AS avg_days_early,
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM (
                order_delivered_customer_date - order_estimated_delivery_date
            )) / 86400.0
        ) FILTER (
            WHERE order_delivered_customer_date > order_estimated_delivery_date
        ),
        2
    ) AS avg_days_late
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
-- Helps us quantify early-delivery cushion and late-delivery severity independently.


-- 7.8 Average delivery time by state
SELECT
    c.customer_state,
    COUNT(*) AS delivered_orders,
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM (
                o.order_delivered_customer_date - o.order_purchase_timestamp
            )) / 86400.0
        ),
        2
    ) AS avg_delivery_days
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
WHERE o.order_purchase_timestamp IS NOT NULL
  AND o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_delivered_customer_date >= o.order_purchase_timestamp
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC, c.customer_state;
-- Helps us identify states where customers experience slower delivery.


-- 7.9 On-time delivery rate by state (minimum 100 eligible orders)
SELECT
    c.customer_state,
    COUNT(*) AS eligible_orders,
    COUNT(*) FILTER (
        WHERE o.order_delivered_customer_date <= o.order_estimated_delivery_date
    ) AS on_time_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE o.order_delivered_customer_date <= o.order_estimated_delivery_date
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS on_time_delivery_rate_pct
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_status = 'delivered'
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
HAVING COUNT(*) >= 100
ORDER BY on_time_delivery_rate_pct, eligible_orders DESC, c.customer_state;
-- Helps us identify states where delivery promises are least reliable.


-- 7.10 Delivery performance over time
SELECT
    DATE_TRUNC('month', order_purchase_timestamp)::date AS order_month,
    COUNT(*) AS eligible_orders,
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM (
                order_delivered_customer_date - order_purchase_timestamp
            )) / 86400.0
        ),
        2
    ) AS avg_delivery_days,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE order_delivered_customer_date <= order_estimated_delivery_date
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS on_time_delivery_rate_pct
FROM orders
WHERE order_status = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date >= order_purchase_timestamp
GROUP BY 1
ORDER BY 1;
-- Helps us determine whether delivery speed and reliability improve over time.


/*
==========================================================
SECTION 8: FINANCIAL RECONCILIATION
==========================================================
*/

-- Aggregate each financial table separately to avoid many-to-many multiplication.

-- 8.1 Total payment value versus total item price plus freight
WITH payment_total AS (
    SELECT SUM(payment_value) AS total_payment_value
    FROM payments
),
item_and_freight_total AS (
    SELECT SUM(price + freight_value) AS total_item_and_freight_value
    FROM order_items
)
SELECT
    ROUND(p.total_payment_value, 2) AS total_payment_value,
    ROUND(i.total_item_and_freight_value, 2) AS total_item_and_freight_value,
    ROUND(p.total_payment_value - i.total_item_and_freight_value, 2)
        AS payment_minus_item_and_freight
FROM payment_total p
CROSS JOIN item_and_freight_total i;
-- Helps us check whether total collected payments reconcile with order charges.


-- 8.2 Matching versus nonmatching orders (one-cent tolerance)
WITH payment_by_order AS (
    SELECT
        order_id,
        SUM(payment_value) AS payment_value
    FROM payments
    GROUP BY order_id
),
item_total_by_order AS (
    SELECT
        order_id,
        SUM(price + freight_value) AS item_and_freight_value
    FROM order_items
    GROUP BY order_id
),
comparable_orders AS (
    SELECT
        p.order_id,
        p.payment_value,
        i.item_and_freight_value
    FROM payment_by_order p
    JOIN item_total_by_order i
        ON i.order_id = p.order_id
)
SELECT
    COUNT(*) AS comparable_orders,
    COUNT(*) FILTER (
        WHERE ABS(payment_value - item_and_freight_value) <= 0.01
    ) AS matching_orders,
    COUNT(*) FILTER (
        WHERE ABS(payment_value - item_and_freight_value) > 0.01
    ) AS nonmatching_orders
FROM comparable_orders;
-- Helps us quantify the extent of order-level financial reconciliation issues.


-- 8.3 Largest order-level reconciliation differences
WITH payment_by_order AS (
    SELECT
        order_id,
        SUM(payment_value) AS payment_value
    FROM payments
    GROUP BY order_id
),
item_total_by_order AS (
    SELECT
        order_id,
        SUM(price + freight_value) AS item_and_freight_value
    FROM order_items
    GROUP BY order_id
)
SELECT
    p.order_id,
    ROUND(p.payment_value, 2) AS payment_value,
    ROUND(i.item_and_freight_value, 2) AS item_and_freight_value,
    ROUND(p.payment_value - i.item_and_freight_value, 2) AS difference,
    ROUND(ABS(p.payment_value - i.item_and_freight_value), 2) AS absolute_difference
FROM payment_by_order p
JOIN item_total_by_order i
    ON i.order_id = p.order_id
WHERE ABS(p.payment_value - i.item_and_freight_value) > 0.01
ORDER BY absolute_difference DESC, p.order_id
LIMIT 20;
-- Helps us prioritize the largest financial discrepancies for investigation.
