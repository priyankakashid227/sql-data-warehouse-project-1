/* =========================================================
   QUALITY CHECKS
   =========================================================
   Script Purpose:
   This script performs various quality checks for data 
   consistency, accuracy, and standardization across the 
   'silver' schema.

   It includes checks for:
   - Nulls or duplicates primary keys
   - Unwanted spaces in string fields
   - Data standardization and consistency
   - Invalid date ranges and orders
   - Data consistency between related fields

   Usage Notes:
   - Run these checks after loading Silver Layer
   - Investigate and resolve any discrepancies found
========================================================= */


----------------------------------------------------------
-- Checking 'silver.crm_cust_info'
----------------------------------------------------------

PRINT '================ Checking silver.crm_cust_info ================';

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces
-- Expectation: No Results
SELECT *
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
   OR cst_lastname != TRIM(cst_lastname);

-- Data Standardization
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;



----------------------------------------------------------
-- Checking 'silver.crm_prd_info'
----------------------------------------------------------

PRINT '================ Checking silver.crm_prd_info ================';

-- Check for NULLs or Duplicates
-- Expectation: No Results
SELECT prd_id, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for negative cost
-- Expectation: No Results
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost < 0;

-- Check invalid date range
-- Expectation: No Results
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;



----------------------------------------------------------
-- Checking 'silver.crm_sales_details'
----------------------------------------------------------

PRINT '================ Checking silver.crm_sales_details ================';

-- Check NULL keys
-- Expectation: No Results
SELECT *
FROM silver.crm_sales_details
WHERE sls_ord_num IS NULL
   OR sls_prd_key IS NULL
   OR sls_cust_id IS NULL;

-- Check invalid date order
-- Expectation: No Results
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Check data consistency (Sales = Qty * Price)
-- Expectation: No Results
SELECT *
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0;



----------------------------------------------------------
-- Checking 'silver.erp_cust_aZ12'
----------------------------------------------------------

PRINT '================ Checking silver.erp_cust_aZ12 ================';

-- Check NULLs
-- Expectation: No Results
SELECT *
FROM silver.erp_cust_aZ12
WHERE cid IS NULL;

-- Data Standardization
SELECT DISTINCT gen
FROM silver.erp_cust_aZ12;



----------------------------------------------------------
-- Checking 'silver.erp_loc_a101'
----------------------------------------------------------

PRINT '================ Checking silver.erp_loc_a101 ================';

-- Check NULLs
-- Expectation: No Results
SELECT *
FROM silver.erp_loc_a101
WHERE cid IS NULL;

-- Data Standardization
SELECT DISTINCT cntry
FROM silver.erp_loc_a101;



----------------------------------------------------------
-- Checking 'silver.erp_px_cat_g1v2'
----------------------------------------------------------

PRINT '================ Checking silver.erp_px_cat_g1v2 ================';

-- Check NULLs
-- Expectation: No Results
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat IS NULL;

-- Data Standardization
SELECT DISTINCT cat, subcat, maintenance
FROM silver.erp_px_cat_g1v2;
