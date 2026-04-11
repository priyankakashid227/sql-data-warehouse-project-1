/*====================================================
 Script: Part to Whole Analysis
====================================================*/

WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)

SELECT
    category,
    total_sales,
    ROUND(total_sales * 100.0 / SUM(total_sales) OVER (), 2) AS percentage
FROM category_sales
ORDER BY total_sales DESC;
