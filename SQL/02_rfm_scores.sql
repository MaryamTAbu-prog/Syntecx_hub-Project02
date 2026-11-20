USE customerSegmenation;

-- score each customer 1 to 5 (5 is best)
DROP TABLE IF EXISTS rfm_scores;

SELECT *,
    6 - NTILE(5) OVER (ORDER BY recency_days, CustomerKey) AS R,
    CASE WHEN frequency >= 5 THEN 5 ELSE frequency END AS F,
    NTILE(5) OVER (ORDER BY monetary, CustomerKey) AS M
INTO rfm_scores
FROM rfm_customers;

SELECT R, COUNT(*) AS customers FROM rfm_scores GROUP BY R ORDER BY R;
SELECT F, COUNT(*) AS customers FROM rfm_scores GROUP BY F ORDER BY F;
SELECT * FROM rfm_scores WHERE CustomerKey = 11000;
