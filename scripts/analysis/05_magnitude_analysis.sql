/*====================================================
 Script Name: 05_magnitude_analysis.sql

 Purpose:
 - Compare business metrics across different dimensions

 Description:
 - Helps understand which categories/customers/countries
   contribute the most to the business

 Key Analysis:
 1. Customers by country
 2. Customers by gender
 3. Products by category
 4. Average cost per category
====================================================*/

-- Total customers by country
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-----------------------------------------------------

-- Total customers by gender
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-----------------------------------------------------

-- Total products by category
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-----------------------------------------------------

-- Average cost per category
SELECT
    category,
    AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;
