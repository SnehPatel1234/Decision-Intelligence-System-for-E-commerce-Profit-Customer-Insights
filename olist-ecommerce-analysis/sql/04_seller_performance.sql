-- ============================================================
-- Query 04: Seller Performance Scorecard
-- Business Question: Who are the top sellers by revenue,
--                    review score and on-time delivery rate?
-- ============================================================

SELECT
    oi.seller_id                                             AS seller_id,
    s.seller_state                                           AS seller_state,
    s.seller_city                                            AS seller_city,
    COUNT(DISTINCT o.order_id)                               AS total_orders,
    COUNT(DISTINCT oi.product_id)                            AS unique_products,
    ROUND(SUM(oi.price), 2)                                  AS total_revenue,
    ROUND(SUM(oi.price - oi.freight_value), 2)               AS profit_proxy,
    ROUND(AVG(oi.price), 2)                                  AS avg_price,
    ROUND(AVG(r.review_score), 2)                            AS avg_review_score,
    ROUND(
        SUM(
            CASE
                WHEN o.order_delivered_customer_date <=
                     o.order_estimated_delivery_date
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(DISTINCT o.order_id), 1
    )                                                        AS on_time_pct,
    ROUND(
        SUM(oi.freight_value) / SUM(oi.price) * 100, 1
    )                                                        AS freight_ratio_pct
FROM orders o
JOIN order_items oi ON o.order_id    = oi.order_id
JOIN sellers     s  ON oi.seller_id  = s.seller_id
LEFT JOIN reviews r ON o.order_id    = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id, s.seller_state, s.seller_city
HAVING total_orders >= 10
ORDER BY total_revenue DESC;
