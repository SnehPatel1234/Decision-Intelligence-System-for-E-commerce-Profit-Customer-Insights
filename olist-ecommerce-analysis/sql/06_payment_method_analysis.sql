-- ============================================================
-- Query 06: Payment Method Analysis by Order Value Tier
-- Business Question: Do high-value customers pay differently?
--                    Which payment method drives most revenue?
-- ============================================================

WITH order_value_tiers AS (
    SELECT
        o.order_id,
        p.payment_type,
        p.payment_installments,
        ROUND(p.payment_value, 2) AS payment_value,
        CASE
            WHEN p.payment_value < 50   THEN '1. Low (<R$50)'
            WHEN p.payment_value < 150  THEN '2. Medium (R$50-150)'
            WHEN p.payment_value < 500  THEN '3. High (R$150-500)'
            ELSE                             '4. Premium (>R$500)'
        END AS value_tier
    FROM orders o
    JOIN payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
)
SELECT
    value_tier,
    payment_type,
    COUNT(*)                             AS order_count,
    ROUND(SUM(payment_value), 2)         AS total_revenue,
    ROUND(AVG(payment_value), 2)         AS avg_order_value,
    ROUND(AVG(payment_installments), 1)  AS avg_installments
FROM order_value_tiers
GROUP BY value_tier, payment_type
ORDER BY value_tier, order_count DESC;
