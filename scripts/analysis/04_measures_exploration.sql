/*====================================================
 Script Name: 04_measures_exploration.sql

 Purpose:
 - Calculate key business metrics

 Description:
 - Provides high-level KPIs for business understanding
====================================================*/

-- Total Quantity
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales;

-- Average Price
SELECT AVG(price) AS avg_price FROM gold.fact_sales;

-- Total Orders
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

-- Total Products
SELECT COUNT(DISTINCT product_name) AS total_products FROM gold.dim_products;

-- Total Customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- KPI Summary
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales;
