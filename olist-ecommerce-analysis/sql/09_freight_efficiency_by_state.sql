-- ============================================================
-- Query 09: Freight Cost Efficiency by Seller State
-- Business Question: Which seller locations have the worst
--                    freight costs and impact on margins?
-- ============================================================

SELECT
    s.seller_state,
    COUNT(DISTINCT oi.seller_id)                             AS seller_count,
    COUNT(DISTINCT o.order_id)                               AS total_orders,
    ROUND(SUM(oi.price), 2)                                  AS total_revenue,
    ROUND(SUM(oi.freight_value), 2)                          AS total_freight,
    ROUND(SUM(oi.price - oi.freight_value), 2)               AS profit_proxy,
    ROUND(AVG(oi.freight_value), 2)                          AS avg_freight_per_item,
    ROUND(
        SUM(oi.freight_value) / SUM(oi.price) * 100, 1
    )                                                        AS freight_pct,
    ROUND(
        AVG(
            JULIANDAY(o.order_delivered_customer_date) -
            JULIANDAY(o.order_purchase_timestamp)
        ), 1
    )                                                        AS avg_delivery_days,
    ROUND(AVG(r.review_score), 2)                            AS avg_review_score
FROM orders o
JOIN order_items oi ON o.order_id    = oi.order_id
JOIN sellers     s  ON oi.seller_id  = s.seller_id
LEFT JOIN reviews r ON o.order_id    = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY s.seller_state
ORDER BY freight_pct DESC;
