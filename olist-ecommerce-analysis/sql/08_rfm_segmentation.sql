-- ============================================================
-- Query 08: RFM Customer Segmentation (Pure SQL)
-- Business Question: Who are our Champions, Loyalists,
--                    At-Risk and Churned customers?
-- ============================================================

WITH rfm_base AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        CAST(
            JULIANDAY('2018-10-18') -
            JULIANDAY(MAX(o.order_purchase_timestamp))
        AS INTEGER)                                  AS recency_days,
        COUNT(DISTINCT o.order_id)                   AS frequency,
        ROUND(SUM(p.payment_value), 2)               AS monetary
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN payments  p ON o.order_id    = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
),
rfm_scored AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency  ASC)   AS f_score,
        NTILE(5) OVER (ORDER BY monetary   ASC)   AS m_score
    FROM rfm_base
),
rfm_segmented AS (
    SELECT *,
        CASE
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
                THEN 'Champions'
            WHEN r_score >= 3 AND f_score >= 3
                THEN 'Loyal Customers'
            WHEN r_score >= 4 AND f_score <= 2
                THEN 'Recent Customers'
            WHEN r_score >= 3 AND f_score <= 2 AND m_score >= 3
                THEN 'Potential Loyalists'
            WHEN r_score <= 2 AND f_score >= 3
                THEN 'At Risk'
            WHEN r_score <= 2 AND f_score <= 2
                THEN 'Churned'
            ELSE 'Others'
        END AS segment
    FROM rfm_scored
)
SELECT
    segment,
    COUNT(*)                          AS customer_count,
    ROUND(AVG(recency_days), 1)       AS avg_recency_days,
    ROUND(AVG(frequency), 2)          AS avg_frequency,
    ROUND(AVG(monetary), 2)           AS avg_monetary,
    ROUND(SUM(monetary), 2)           AS total_revenue,
    ROUND(
        SUM(monetary) * 100.0 /
        SUM(SUM(monetary)) OVER (), 1
    )                                 AS revenue_pct
FROM rfm_segmented
GROUP BY segment
ORDER BY total_revenue DESC;
