-- ============================================================
-- Query 07: Cancellation & Problem Rate by Category
-- Business Question: Which product categories have the most
--                    cancelled or problematic orders?
-- ============================================================

SELECT
    p.product_category_name_english                AS category,
    COUNT(DISTINCT o.order_id)                     AS total_orders,
    SUM(CASE WHEN o.order_status = 'delivered'
             THEN 1 ELSE 0 END)                    AS delivered,
    SUM(CASE WHEN o.order_status = 'canceled'
             THEN 1 ELSE 0 END)                    AS cancelled,
    SUM(CASE WHEN o.order_status NOT IN
             ('delivered','shipped','processing',
              'approved','invoiced','created')
             THEN 1 ELSE 0 END)                    AS problematic,
    ROUND(
        SUM(CASE WHEN o.order_status = 'canceled'
                 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(DISTINCT o.order_id), 2
    )                                              AS cancel_rate_pct,
    ROUND(AVG(oi.price), 2)                        AS avg_price,
    ROUND(AVG(r.review_score), 2)                  AS avg_review_score
FROM orders o
JOIN order_items oi ON o.order_id    = oi.order_id
JOIN products    p  ON oi.product_id = p.product_id
LEFT JOIN reviews r ON o.order_id    = r.order_id
WHERE p.product_category_name_english IS NOT NULL
GROUP BY p.product_category_name_english
HAVING total_orders >= 50
ORDER BY cancel_rate_pct DESC;
