-- ============================================================
-- Query 05: Customer Repeat Purchase Rate
-- Business Question: How loyal are Olist customers?
--                    What % buy more than once?
-- ============================================================

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        COUNT(DISTINCT o.order_id)      AS total_orders,
        ROUND(SUM(p.payment_value), 2)  AS total_spend,
        MIN(o.order_purchase_timestamp) AS first_order,
        MAX(o.order_purchase_timestamp) AS last_order
    FROM orders o
    JOIN customers c  ON o.customer_id = c.customer_id
    JOIN payments  p  ON o.order_id    = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
)
SELECT
    customer_state,
    COUNT(*)                                          AS total_customers,
    SUM(CASE WHEN total_orders = 1 THEN 1 ELSE 0 END) AS one_time_buyers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)  AS repeat_buyers,
    ROUND(
        SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    )                                                  AS repeat_rate_pct,
    ROUND(AVG(total_spend), 2)                         AS avg_total_spend,
    ROUND(AVG(total_orders), 2)                        AS avg_orders_per_customer
FROM customer_orders
GROUP BY customer_state
ORDER BY repeat_rate_pct DESC;
