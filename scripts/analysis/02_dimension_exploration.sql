/*====================================================
 Script Name: 02_dimension_exploration.sql

 Purpose:
 - Explore dimension data

 Description:
 - Identify unique categories and grouping fields
 - Helps in segmentation and reporting
====================================================*/

-- Countries
SELECT DISTINCT country FROM gold.dim_customers;

-- Categories
SELECT DISTINCT category FROM gold.dim_products;

-- Category + Subcategory
SELECT DISTINCT category, subcategory 
FROM gold.dim_products;

-- Full hierarchy
SELECT DISTINCT category, subcategory, product_name
FROM gold.dim_products
ORDER BY 1,2,3;
