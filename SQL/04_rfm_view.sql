USE customerSegmenation;
GO

-- one row per customer with score, segment, group and country (Power BI reads this)
CREATE OR ALTER VIEW vw_rfm_customers AS
SELECT
    s.CustomerKey,
    CASE s.territory_key
        WHEN 6 THEN 'Canada'
        WHEN 7 THEN 'France'
        WHEN 8 THEN 'Germany'
        WHEN 9 THEN 'Australia'
        WHEN 10 THEN 'United Kingdom'
        ELSE 'United States'
    END AS country,
    s.last_order_date,
    s.recency_days,
    s.frequency,
    s.monetary,
    s.R, s.F, s.M,
    s.R * 100 + s.F * 10 + s.M AS rfm_score,
    l.segment,
    a.customer_group
FROM rfm_scores s
LEFT JOIN rfm_lookup l ON l.rfm_score = s.R * 100 + s.F * 10 + s.M
LEFT JOIN segment_actions a ON a.segment = l.segment;
GO

SELECT COUNT(*) AS no_segment FROM vw_rfm_customers WHERE segment IS NULL;

SELECT segment, COUNT(*) AS customers
FROM vw_rfm_customers
GROUP BY segment
ORDER BY customers DESC;

SELECT
    customer_group,
    COUNT(*) AS customers,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,1)) AS customer_pct,
    CAST(SUM(monetary) * 100.0 / SUM(SUM(monetary)) OVER () AS DECIMAL(5,1)) AS revenue_pct,
    AVG(recency_days) AS avg_days_since_order
FROM vw_rfm_customers
GROUP BY customer_group
ORDER BY revenue_pct DESC;
