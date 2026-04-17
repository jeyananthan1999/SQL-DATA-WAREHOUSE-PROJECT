/*
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
===============================================================================
*/
-- ===============================
-- START: Bronze Layer Load
-- ===============================

SELECT '==========================================' AS msg;
SELECT 'Loading Bronze Layer' AS msg;
SELECT '==========================================' AS msg;

-- ================= CRM =================
SELECT 'Loading CRM Tables' AS msg;

-- crm_cust_info
SELECT 'Truncating crm_cust_info' AS msg;
TRUNCATE TABLE bronze.crm_cust_info;

SELECT 'Loading crm_cust_info' AS msg;
LOAD DATA LOCAL INFILE 'C:/Users/GOKUL/Desktop/Jeyananthan/Data Warehouse Project/datasets/source_crm/cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT 'crm_cust_info Loaded' AS msg;

-- crm_prd_info
SELECT 'Truncating crm_prd_info' AS msg;
TRUNCATE TABLE bronze.crm_prd_info;

SELECT 'Loading crm_prd_info' AS msg;
LOAD DATA LOCAL INFILE 'C:/Users/GOKUL/Desktop/Jeyananthan/Data Warehouse Project/datasets/source_crm/prd_info.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT 'crm_prd_info Loaded' AS msg;

-- crm_sales_details
SELECT 'Truncating crm_sales_details' AS msg;
TRUNCATE TABLE bronze.crm_sales_details;

SELECT 'Loading crm_sales_details' AS msg;
LOAD DATA LOCAL INFILE 'C:/Users/GOKUL/Desktop/Jeyananthan/Data Warehouse Project/datasets/source_crm/sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT 'crm_sales_details Loaded' AS msg;

-- ================= ERP =================
SELECT 'Loading ERP Tables' AS msg;

-- erp_loc_a101
SELECT 'Truncating erp_loc_a101' AS msg;
TRUNCATE TABLE bronze.erp_loc_a101;

SELECT 'Loading erp_loc_a101' AS msg;
LOAD DATA LOCAL INFILE 'C:/Users/GOKUL/Desktop/Jeyananthan/Data Warehouse Project/datasets/source_erp/loc_a101.csv'
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT 'erp_loc_a101 Loaded' AS msg;

-- erp_cust_az12
SELECT 'Truncating erp_cust_az12' AS msg;
TRUNCATE TABLE bronze.erp_cust_az12;

SELECT 'Loading erp_cust_az12' AS msg;
LOAD DATA LOCAL INFILE 'C:/Users/GOKUL/Desktop/Jeyananthan/Data Warehouse Project/datasets/source_erp/cust_az12.csv'
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT 'erp_cust_az12 Loaded' AS msg;

-- erp_px_cat_g1v2
SELECT 'Truncating erp_px_cat_g1v2' AS msg;
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

SELECT 'Loading erp_px_cat_g1v2' AS msg;
LOAD DATA LOCAL INFILE 'C:/Users/GOKUL/Desktop/Jeyananthan/Data Warehouse Project/datasets/source_erp/px_cat_g1v2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT 'erp_px_cat_g1v2 Loaded' AS msg;

-- ===============================
-- END
-- ===============================

SELECT '==========================================' AS msg;
SELECT 'Bronze Layer Loading Completed' AS msg;
SELECT '==========================================' AS msg;
