-- ============================================================
-- Query 02: Monthly Revenue, Orders & Average Order Value
-- Business Question: How has the business grown month by month?
--                    When are the peaks and dips?
-- ============================================================

SELECT
    STRFTIME('%Y-%m', o.order_purchase_timestamp)   AS order_month,
    COUNT(DISTINCT o.order_id)                       AS total_orders,
    COUNT(DISTINCT o.customer_id)                    AS unique_customers,
    ROUND(SUM(p.payment_value), 2)                   AS total_revenue,
    ROUND(AVG(p.payment_value), 2)                   AS avg_order_value,
    ROUND(SUM(oi.price - oi.freight_value), 2)       AS profit_proxy,
    ROUND(
        SUM(oi.freight_value) / SUM(oi.price) * 100, 1
    )                                                AS freight_pct
FROM orders o
JOIN payments   p  ON o.order_id = p.order_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp IS NOT NULL
GROUP BY STRFTIME('%Y-%m', o.order_purchase_timestamp)
ORDER BY order_month;
