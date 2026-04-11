/*====================================================
 Script: Performance Analysis
====================================================*/

WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY YEAR(f.order_date), p.product_name
)

SELECT
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS prev_year_sales
FROM yearly_product_sales
ORDER BY product_name, order_year;
