-- ============================================================
-- Query 01: Revenue, Profit Proxy & Freight Ratio by Category
-- Business Question: Which product categories make the most
--                    money and which have the worst margins?
-- ============================================================

SELECT
    p.product_category_name_english                          AS category,
    COUNT(DISTINCT o.order_id)                               AS total_orders,
    ROUND(SUM(oi.price), 2)                                  AS total_revenue,
    ROUND(SUM(oi.freight_value), 2)                          AS total_freight,
    ROUND(SUM(oi.price - oi.freight_value), 2)               AS profit_proxy,
    ROUND(AVG(oi.price), 2)                                  AS avg_price,
    ROUND(AVG(oi.freight_value), 2)                          AS avg_freight,
    ROUND(SUM(oi.freight_value) / SUM(oi.price) * 100, 1)   AS freight_pct_of_revenue,
    ROUND(AVG(r.review_score), 2)                            AS avg_review_score
FROM orders o
JOIN order_items  oi ON o.order_id    = oi.order_id
JOIN products     p  ON oi.product_id = p.product_id
LEFT JOIN reviews r  ON o.order_id    = r.order_id
WHERE o.order_status = 'delivered'
  AND p.product_category_name_english IS NOT NULL
GROUP BY p.product_category_name_english
ORDER BY profit_proxy DESC;
