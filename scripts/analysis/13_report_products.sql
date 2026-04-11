/*====================================================
 Script: Product Report
====================================================*/

CREATE VIEW gold.report_products AS

SELECT
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    SUM(f.sales_amount) AS total_sales,
    COUNT(DISTINCT f.order_number) AS total_orders,
    SUM(f.quantity) AS total_quantity
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_key, p.product_name, p.category, p.subcategory;
