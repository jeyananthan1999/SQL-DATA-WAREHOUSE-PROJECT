-- DATA standardization and Consistency
/* 
-- CSV imports may introduce hidden characters like carriage returns(\r) and line breaks (\n), 
so I use TRIM and REPLACE to standardize text values before applying transformations --
*/
SELECT DISTINCT 
cntry as old_cntry,
CASE
        WHEN TRIM(REPLACE(REPLACE(cntry, '\r', ''), '\n', '')) = 'DE' 
            THEN 'Germany'
        WHEN TRIM(REPLACE(REPLACE(cntry, '\r', ''), '\n', '')) IN ('US', 'USA') 
            THEN 'United States'
        WHEN TRIM(REPLACE(REPLACE(cntry, '\r', ''), '\n', '')) = '' 
             OR cntry IS NULL
            THEN 'Not Available'
        ELSE TRIM(REPLACE(REPLACE(cntry, '\r', ''), '\n', ''))
END AS cntry
FROM bronze.erp_loc_a101
ORDER BY cntry;

-- DATA TRANSFORMATION - FIXING customerID and cntry standardization--
/* 
-- CSV imports may introduce hidden characters like carriage returns(\r) and line breaks (\n), 
so I use TRIM and REPLACE to standardize text values before applying transformations --
*/
select
Replace(cid, "-","") as cid,
CASE
        WHEN TRIM(REPLACE(REPLACE(cntry, '\r', ''), '\n', '')) = 'DE' 
            THEN 'Germany'
        WHEN TRIM(REPLACE(REPLACE(cntry, '\r', ''), '\n', '')) IN ('US', 'USA') 
            THEN 'United States'
        WHEN TRIM(REPLACE(REPLACE(cntry, '\r', ''), '\n', '')) = '' 
             OR cntry IS NULL
            THEN 'Not Available'
        ELSE TRIM(REPLACE(REPLACE(cntry, '\r', ''), '\n', ''))
END AS cntry                                                                      
from bronze.erp_loc_a101;