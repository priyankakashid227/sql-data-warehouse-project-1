/*============================================================
Quality Checks for Gold Layer
============================================================

Script Purpose:
This script performs quality checks to validate the integrity, consistency, 
and accuracy of the Gold layer. These checks ensure:
-- Uniqueness of surrogate keys in dimension tables
-- Referential integrity between fact and dimension tables
-- Validation of relationships in the data model for analytical purposes

Usage Notes:
- Run these checks after loading data into the Silver layer.
- Investigate and resolve any discrepancies found during the checks.
============================================================*/

/*========================
Check Uniqueness of Surrogate Keys in dim_customers
Expected Result: No rows returned
=========================*/
SELECT customer_key, COUNT(*) AS cnt
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;
GO

/*========================
Check Uniqueness of Surrogate Keys in dim_products
Expected Result: No rows returned
=========================*/
SELECT products_key, COUNT(*) AS cnt
FROM gold.dim_products
GROUP BY products_key
HAVING COUNT(*) > 1;
GO

/*========================
Check Referential Integrity: dact_sales → dim_customers
Expected Result: No rows returned
=========================*/
SELECT f.customer_key
FROM gold.dact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;
GO

/*========================
Check Referential Integrity: dact_sales → dim_products
Expected Result: No rows returned
=========================*/
SELECT f.products_key
FROM gold.dact_sales f
LEFT JOIN gold.dim_products p
    ON f.products_key = p.products_key
WHERE p.products_key IS NULL;
GO

/*========================
Check Referential Integrity: fact_sales → dim_customers
Expected Result: No rows returned
=========================*/
SELECT f.customer_key
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;
GO

/*========================
Check Referential Integrity: fact_sales → dim_products
Expected Result: No rows returned
=========================*/
SELECT f.products_key
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.products_key = p.products_key
WHERE p.products_key IS NULL;
GO

/*========================
Additional Checks (Optional)
=========================*/
/* Check for NULLs in critical columns */
SELECT *
FROM gold.dim_customers
WHERE customer_id IS NULL
   OR customer_number IS NULL;
GO

SELECT *
FROM gold.dim_products
WHERE product_id IS NULL
   OR product_number IS NULL;
GO

/* Check for negative or zero sales_amount or quantity in dact_sales and fact_sales */
SELECT *
FROM gold.dact_sales
WHERE sales_amount <= 0
   OR quantity <= 0;
GO

SELECT *
FROM gold.fact_sales
WHERE sales_amount <= 0
   OR quantity <= 0;
GO
