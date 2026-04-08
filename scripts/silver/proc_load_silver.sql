/* 
=========================================================
   Stored Procedure: Load Silver Layer (Bronze => Silver)
=========================================================
   Script Purpose:
   This stored procedure performs the ETL (Extract, Transform, Load)
   process to populate the 'silver' schema tables from the bronze schema.

   Actions Performed:
   - Truncate Silver tables.
   - Insert transformed and cleaned data from Bronze into Silver tables.

   Parameters:
   None.
   This stored procedure does not accept any parameters or return any values.

   Usage Example:
   EXEC silver.load_silver;
=========================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN

DECLARE @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

BEGIN TRY

-- =========================================
SET @batch_start_time = GETDATE();

PRINT '========================================';
PRINT 'Loading Silver Layer';
PRINT '========================================';

PRINT '----------------------------------------';
PRINT 'Loading CRM Tables';
PRINT '----------------------------------------';

------------------------------------------------
-- crm_cust_info
------------------------------------------------
SET @start_time = GETDATE();

PRINT '>> Truncating Table: silver.crm_cust_info';
TRUNCATE TABLE silver.crm_cust_info;

PRINT '>> Inserting Data Into: silver.crm_cust_info';
INSERT INTO silver.crm_cust_info(
    cst_id, cst_key, cst_firstname, cst_lastname,
    cst_marital_status, cst_gndr, cst_create_date
)
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname),
    TRIM(cst_lastname),
    CASE 
        WHEN UPPER(TRIM(cst_material_status))='S' THEN 'Single'
        WHEN UPPER(TRIM(cst_material_status))='M' THEN 'Married'
        ELSE 'n/a'
    END,
    CASE 
        WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'
        ELSE 'n/a'
    END,
    TRY_CONVERT(DATE,cst_create_date,105)
FROM (
    SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY cst_id 
        ORDER BY TRY_CONVERT(DATE,cst_create_date,105) DESC
    ) flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1;

SET @end_time = GETDATE();
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '----------------------------------------';


------------------------------------------------
-- crm_prd_info
------------------------------------------------
SET @start_time = GETDATE();

PRINT '>> Truncating Table: silver.crm_prd_info';
TRUNCATE TABLE silver.crm_prd_info;

PRINT '>> Inserting Data Into: silver.crm_prd_info';
INSERT INTO silver.crm_prd_info(
    prd_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt
)
SELECT
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    TRY_CONVERT(DATE,prd_start_dt,105),
    TRY_CONVERT(DATE,prd_end_dt,105)
FROM bronze.crm_prd_info;

SET @end_time = GETDATE();
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '----------------------------------------';


------------------------------------------------
-- crm_sales_details
------------------------------------------------
SET @start_time = GETDATE();

PRINT '>> Truncating Table: silver.crm_sales_details';
TRUNCATE TABLE silver.crm_sales_details;

PRINT '>> Inserting Data Into: silver.crm_sales_details';
INSERT INTO silver.crm_sales_details(
    sls_ord_num, sls_prd_key, sls_cust_id,
    sls_order_dt, sls_ship_dt, sls_due_dt,
    sls_sales, sls_quantity, sls_price
)
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,

    CASE 
        WHEN sls_order_dt = 0 OR LEN(CAST(sls_order_dt AS VARCHAR)) != 8 THEN NULL
        ELSE TRY_CONVERT(DATE, CAST(sls_order_dt AS VARCHAR))
    END,

    CASE 
        WHEN sls_ship_dt = 0 OR LEN(CAST(sls_ship_dt AS VARCHAR)) != 8 THEN NULL
        ELSE TRY_CONVERT(DATE, CAST(sls_ship_dt AS VARCHAR))
    END,

    CASE 
        WHEN sls_due_dt = 0 OR LEN(CAST(sls_due_dt AS VARCHAR)) != 8 THEN NULL
        ELSE TRY_CONVERT(DATE, CAST(sls_due_dt AS VARCHAR))
    END,

    CASE 
        WHEN sls_sales IS NULL OR sls_sales <= 0 
             OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END,

    sls_quantity,

    CASE 
        WHEN sls_price IS NULL OR sls_price <= 0
        THEN sls_sales / NULLIF(sls_quantity,0)
        ELSE sls_price
    END

FROM bronze.crm_sales_details;

SET @end_time = GETDATE();
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '----------------------------------------';


PRINT '----------------------------------------';
PRINT 'Loading ERP Tables';
PRINT '----------------------------------------';


------------------------------------------------
-- erp_cust_aZ12
------------------------------------------------
SET @start_time = GETDATE();

PRINT '>> Truncating Table: silver.erp_cust_aZ12';
TRUNCATE TABLE silver.erp_cust_aZ12;

PRINT '>> Inserting Data Into: silver.erp_cust_aZ12';
INSERT INTO silver.erp_cust_aZ12(cid, bdate, gen)
SELECT
    cid,
    TRY_CONVERT(DATE,bdate,105),
    gen
FROM bronze.erp_cust_aZ12;

SET @end_time = GETDATE();
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '----------------------------------------';


------------------------------------------------
-- erp_loc_a101
------------------------------------------------
SET @start_time = GETDATE();

PRINT '>> Truncating Table: silver.erp_loc_a101';
TRUNCATE TABLE silver.erp_loc_a101;

PRINT '>> Inserting Data Into: silver.erp_loc_a101';
INSERT INTO silver.erp_loc_a101(cid, cntry)
SELECT cid, cntry
FROM bronze.erp_loc_a101;

SET @end_time = GETDATE();
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '----------------------------------------';


------------------------------------------------
-- erp_px_cat_g1v2
------------------------------------------------
SET @start_time = GETDATE();

PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
TRUNCATE TABLE silver.erp_px_cat_g1v2;

PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';
INSERT INTO silver.erp_px_cat_g1v2(cat, subcat, maintenance)
SELECT cat, subcat, maintenance
FROM bronze.erp_px_cat_g1v2;

SET @end_time = GETDATE();
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '----------------------------------------';


-- FINAL
SET @batch_end_time = GETDATE();

PRINT '========================================';
PRINT 'Loading Silver Layer is Completed';
PRINT 'Total Load Duration: ' 
+ CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds';
PRINT '========================================';

END TRY

BEGIN CATCH

PRINT '========================================';
PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER';

PRINT 'Error Message: ' + ERROR_MESSAGE();
PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);

PRINT '========================================';

END CATCH

END
GO

EXEC silver.load_silver;
