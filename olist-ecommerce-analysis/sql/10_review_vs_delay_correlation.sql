-- ============================================================
-- Query 10: Review Score vs Delivery Delay Correlation
-- Business Question: How much does being late hurt our
--                    review scores? Prove it with data.
-- ============================================================

WITH order_delays AS (
    SELECT
        o.order_id,
        CAST(
            JULIANDAY(o.order_delivered_customer_date) -
            JULIANDAY(o.order_estimated_delivery_date)
        AS INTEGER)                                          AS delay_days,
        CAST(
            JULIANDAY(o.order_delivered_customer_date) -
            JULIANDAY(o.order_purchase_timestamp)
        AS INTEGER)                                          AS actual_days,
        r.review_score,
        CASE
            WHEN JULIANDAY(o.order_delivered_customer_date) -
                 JULIANDAY(o.order_estimated_delivery_date) < -7
                THEN '1. More than 7 days early'
            WHEN JULIANDAY(o.order_delivered_customer_date) -
                 JULIANDAY(o.order_estimated_delivery_date) < 0
                THEN '2. Early (1-7 days)'
            WHEN JULIANDAY(o.order_delivered_customer_date) -
                 JULIANDAY(o.order_estimated_delivery_date) = 0
                THEN '3. Exactly on time'
            WHEN JULIANDAY(o.order_delivered_customer_date) -
                 JULIANDAY(o.order_estimated_delivery_date) <= 3
                THEN '4. Late 1-3 days'
            WHEN JULIANDAY(o.order_delivered_customer_date) -
                 JULIANDAY(o.order_estimated_delivery_date) <= 7
                THEN '5. Late 4-7 days'
            ELSE '6. Very late (>7 days)'
        END AS delay_bucket
    FROM orders o
    JOIN reviews r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
)
SELECT
    delay_bucket,
    COUNT(*)                                AS order_count,
    ROUND(AVG(review_score), 3)             AS avg_review_score,
    ROUND(AVG(delay_days), 1)               AS avg_delay_days,
    SUM(CASE WHEN review_score <= 2
             THEN 1 ELSE 0 END)             AS bad_reviews,
    ROUND(
        SUM(CASE WHEN review_score <= 2
                 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 1
    )                                       AS bad_review_pct,
    SUM(CASE WHEN review_score = 5
             THEN 1 ELSE 0 END)             AS five_star_reviews,
    ROUND(
        SUM(CASE WHEN review_score = 5
                 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 1
    )                                       AS five_star_pct
FROM order_delays
GROUP BY delay_bucket
ORDER BY delay_bucket;
