/*====================================================
 Script Name: 08_cumulative_analysis.sql

 Purpose:
 - Analyze cumulative growth and trends over time

 Description:
 - This script calculates:
   1. Monthly total sales
   2. Running total (cumulative sales)
   3. Moving average of price

 Why this is important:
 - Helps track business growth over time
 - Useful for dashboards and trend analysis

 Key KPIs:
 - Monthly Sales
 - Running Total Sales
 - Moving Average Price
====================================================*/


-- Step 1: Monthly Aggregation
WITH monthly_sales AS (
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)

-- Step 2: Cumulative + Moving Analysis
SELECT
    order_month,
    total_sales,

    -- Running Total (Cumulative Sales)
    SUM(total_sales) OVER (ORDER BY order_month) AS running_total_sales,

    -- Moving Average Price
    AVG(avg_price) OVER (ORDER BY order_month) AS moving_avg_price

FROM monthly_sales
ORDER BY order_month;
