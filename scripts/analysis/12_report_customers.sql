/*====================================================
 Script: Customer Report
====================================================*/

CREATE VIEW gold.report_customers AS

SELECT
    c.customer_key,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    COUNT(DISTINCT f.order_number) AS total_orders,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.quantity) AS total_quantity,
    MAX(f.order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name;
