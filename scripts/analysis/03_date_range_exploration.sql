/*====================================================
 Script Name: 03_date_range_exploration.sql

 Purpose:
 - Analyze data time range

 Description:
 - Find earliest and latest dates
 - Understand data coverage
====================================================*/

SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;
