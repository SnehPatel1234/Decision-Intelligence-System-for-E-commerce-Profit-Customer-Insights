-- ============================================================
-- Query 03: Delivery Delay Analysis by Customer State
-- Business Question: Which states have the worst delivery
--                    performance and highest late order rates?
-- ============================================================

SELECT
    c.customer_state                                         AS state,
    COUNT(DISTINCT o.order_id)                               AS total_orders,
    ROUND(
        AVG(
            JULIANDAY(o.order_delivered_customer_date) -
            JULIANDAY(o.order_estimated_delivery_date)
        ), 2
    )                                                        AS avg_delay_days,
    ROUND(
        AVG(
            JULIANDAY(o.order_delivered_customer_date) -
            JULIANDAY(o.order_purchase_timestamp)
        ), 2
    )                                                        AS avg_actual_delivery_days,
    SUM(
        CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN 1 ELSE 0
        END
    )                                                        AS late_orders,
    ROUND(
        SUM(
            CASE
                WHEN o.order_delivered_customer_date >
                     o.order_estimated_delivery_date
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(DISTINCT o.order_id), 1
    )                                                        AS late_order_pct,
    ROUND(AVG(r.review_score), 2)                            AS avg_review_score
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delay_days DESC;
