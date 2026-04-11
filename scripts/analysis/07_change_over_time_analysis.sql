/*====================================================
 Script Name: 07_change_over_time_analysis.sql

 Purpose:
 - Analyze sales trends over time

 Description:
 - Helps track growth patterns
====================================================*/

SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;
