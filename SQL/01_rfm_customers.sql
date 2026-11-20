USE customerSegmenation;

-- last date in the data is 2008-07-31, so recency is counted from 2008-08-01
SELECT MAX(CAST(OrderDateKey AS DATE)) AS last_date_in_data
FROM sales;

-- one row per customer with recency, frequency and monetary
DROP TABLE IF EXISTS rfm_customers;

SELECT
    CustomerKey,
    MAX(SalesTerritoryKey) AS territory_key,
    MAX(CAST(OrderDateKey AS DATE)) AS last_order_date,
    DATEDIFF(DAY, MAX(CAST(OrderDateKey AS DATE)), '2008-08-01') AS recency_days,
    COUNT(DISTINCT SalesOrderNumber) AS frequency,
    SUM(SalesAmount) AS monetary
INTO rfm_customers
FROM sales
GROUP BY CustomerKey;

SELECT COUNT(*) AS customers FROM rfm_customers;
SELECT * FROM rfm_customers WHERE CustomerKey = 11000;
