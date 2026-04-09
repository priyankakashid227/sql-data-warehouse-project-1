/*============================================================
DDL Script : Create Gold Views
============================================================

Script Purpose:
This script creates views for the Gold layer in the Data Warehouse.
The Gold layer represents the final dimension and fact tables (Star Schema).

Each view performs transformations and combines data from the Silver layer
to produce a clean, enriched, and business-ready dataset.

Usage:
These views can be queried directly for analytical and reporting purposes.
============================================================*/

/*========================
Create Gold Customer Dimension
=========================*/
CREATE OR REPLACE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY c.customer_id) AS customer_key,
    c.customer_id,
    c.customer_number,
    c.first_name,
    c.last_name,
    c.country,
    c.marital_status,
    c.gender,
    c.birthdate,
    c.create_date
FROM silver.crm_customers c;

/*========================
Create Gold Product Dimension
=========================*/
CREATE OR REPLACE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY p.start_date, p.product_number) AS products_key,
    p.product_id,
    p.product_number,
    p.product_name,
    p.category_id,
    p.category,
    p.subcategory,
    p.maintenance_required,
    p.cost,
    p.product_line,
    p.start_date
FROM silver.crm_prd_info p
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON p.category_id = pc.id
WHERE p.prd_end_dt IS NULL;

/*========================
Create Gold Sales Fact Table (dact_sales)
=========================*/
CREATE OR REPLACE VIEW gold.dact_sales AS
SELECT
    s.sls_ord_num AS order_number,
    pr.products_key,
    cu.customer_key,
    s.sls_order_dt AS order_date,
    s.sls_ship_dt AS shipping_date,
    s.sls_due_dt AS due_date,
    s.sls_sales AS sales_amount,
    s.sls_quantity AS quantity,
    s.sls_price AS price
FROM silver.crm_sales_details s
LEFT JOIN gold.dim_products pr
    ON s.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON s.sls_cust_id = cu.customer_id;

/*========================
Create Gold Sales Fact Table (fact_sales)
=========================*/
CREATE OR REPLACE VIEW gold.fact_sales AS
SELECT
    s.sls_ord_num AS order_number,
    pr.products_key,
    cu.customer_key,
    s.sls_order_dt AS order_date,
    s.sls_ship_dt AS shipping_date,
    s.sls_due_dt AS due_date,
    s.sls_sales AS sales_amount,
    s.sls_quantity AS quantity,
    s.sls_price AS price
FROM silver.crm_sales_details s
LEFT JOIN gold.dim_products pr
    ON s.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON s.sls_cust_id = cu.customer_id;
