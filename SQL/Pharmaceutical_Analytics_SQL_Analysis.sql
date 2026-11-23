USE pharma_analytics;

SELECT COUNT(*) AS total_records
FROM pharmaceutical_data;
SELECT *
FROM pharmaceutical_data
LIMIT 5;
SELECT
    SUM(revenue) AS total_revenue,
    SUM(total_cost) AS total_cost,
    SUM(profit) AS total_profit
FROM pharmaceutical_data;
SELECT
    COUNT(*) AS total_records,
    SUM(stock_on_hand IS NULL) AS missing_stock
FROM pharmaceutical_data;
SELECT *
FROM pharmaceutical_data
WHERE stock_on_hand IS NULL
LIMIT 10;
SELECT COUNT(*) AS total_records
FROM pharmaceutical_data;

SET SQL_SAFE_UPDATES = 0;
UPDATE pharmaceutical_data
SET stock_on_hand = NULL
WHERE stock_on_hand = -1;
SET SQL_SAFE_UPDATES = 1;
SELECT
    COUNT(*) AS total_records,
    SUM(stock_on_hand IS NULL) AS missing_stock
FROM pharmaceutical_data;
SELECT
    COUNT(*) AS total_orders,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(total_cost), 2) AS total_cost,
    ROUND(SUM(profit), 2) AS total_profit
FROM pharmaceutical_data;
USE pharma_analytics;
SELECT DATABASE();
SELECT
    ROUND(
        SUM(profit) / SUM(revenue) * 100,
        2
    ) AS profit_margin_percentage
FROM pharmaceutical_data;
ORDER BY total_units_sold DESC
SELECT
    product_name,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM pharma_analytics.pharmaceutical_data
GROUP BY product_name
ORDER BY SUM(units_sold) DESC
LIMIT 10;
SELECT
    manufacturer,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM pharma_analytics.pharmaceutical_data
GROUP BY manufacturer
ORDER BY total_revenue DESC;
SELECT
    inventory_status,
    COUNT(*) AS total_records,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) 
                            FROM pharma_analytics.pharmaceutical_data),
        2
    ) AS percentage
FROM pharma_analytics.pharmaceutical_data
GROUP BY inventory_status
ORDER BY total_records DESC;
SELECT
    expiry_status,
    COUNT(*) AS total_records,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM pharma_analytics.pharmaceutical_data),
        2
    ) AS percentage
FROM pharma_analytics.pharmaceutical_data
GROUP BY expiry_status
ORDER BY total_records DESC;
SELECT
    quality_status,
    COUNT(*) AS total_records,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM pharma_analytics.pharmaceutical_data),
        2
    ) AS percentage
FROM pharma_analytics.pharmaceutical_data
GROUP BY quality_status
ORDER BY total_records DESC;
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    COUNT(*) AS total_orders,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM pharma_analytics.pharmaceutical_data
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM pharma_analytics.pharmaceutical_data
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY total_revenue DESC
LIMIT 1;
DESCRIBE pharma_analytics.pharmaceutical_data;
SELECT
    manufacturer_id,
    manufacturer,
    COUNT(*) AS total_records
FROM pharma_analytics.pharmaceutical_data
GROUP BY manufacturer_id, manufacturer
ORDER BY manufacturer;
CREATE TABLE pharma_analytics.manufacturers (
    manufacturer_id VARCHAR(10) PRIMARY KEY,
    manufacturer_name VARCHAR(100) NOT NULL
);
INSERT INTO pharma_analytics.manufacturers
(manufacturer_id, manufacturer_name)
VALUES
('M001', 'Apex Pharma'),
('M002', 'NovaMed Labs'),
('M003', 'CureWell Pharma'),
('M004', 'HealthBridge'),
('M005', 'BioCare Ltd');
SELECT *
FROM pharma_analytics.manufacturers;
SELECT
    p.manufacturer_id,
    m.manufacturer_name,
    COUNT(*) AS total_records,
    SUM(p.units_sold) AS total_units_sold,
    ROUND(SUM(p.revenue), 2) AS total_revenue,
    ROUND(SUM(p.profit), 2) AS total_profit
FROM pharma_analytics.pharmaceutical_data AS p
INNER JOIN pharma_analytics.manufacturers AS m
    ON p.manufacturer_id = m.manufacturer_id
GROUP BY
    p.manufacturer_id,
    m.manufacturer_name
ORDER BY total_revenue DESC;
SELECT
    p.manufacturer_id,
    p.manufacturer,
    COUNT(*) AS total_records
FROM pharma_analytics.pharmaceutical_data AS p
LEFT JOIN pharma_analytics.manufacturers AS m
    ON p.manufacturer_id = m.manufacturer_id
WHERE m.manufacturer_id IS NULL
GROUP BY
    p.manufacturer_id,
    p.manufacturer;
    SELECT
    m.manufacturer_id,
    m.manufacturer_name,
    COUNT(p.order_id) AS total_records,
    COALESCE(SUM(p.units_sold), 0) AS total_units_sold,
    ROUND(COALESCE(SUM(p.revenue), 0), 2) AS total_revenue
FROM pharma_analytics.manufacturers AS m
LEFT JOIN pharma_analytics.pharmaceutical_data AS p
    ON m.manufacturer_id = p.manufacturer_id
GROUP BY
    m.manufacturer_id,
    m.manufacturer_name
ORDER BY total_revenue DESC;
SELECT
    m.manufacturer_id,
    m.manufacturer_name,
    COUNT(p.order_id) AS total_records
FROM pharma_analytics.pharmaceutical_data AS p
RIGHT JOIN pharma_analytics.manufacturers AS m
    ON p.manufacturer_id = m.manufacturer_id
GROUP BY
    m.manufacturer_id,
    m.manufacturer_name
ORDER BY m.manufacturer_id;
SELECT
    m.manufacturer_id,
    m.manufacturer_name
FROM pharma_analytics.pharmaceutical_data AS p
RIGHT JOIN pharma_analytics.manufacturers AS m
    ON p.manufacturer_id = m.manufacturer_id
WHERE p.order_id IS NULL;