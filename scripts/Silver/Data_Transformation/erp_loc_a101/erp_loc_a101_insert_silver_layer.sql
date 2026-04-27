-- DATA LOADING INTO SILVER LAYER OF ERP_LOC_A101 --

Truncate Table silver.erp_loc_a101;
Insert into silver.erp_loc_a101 (
cid,
cntry
)

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
END AS cntry                                                               -- Normalize and Handle missing or blank country information       
from bronze.erp_loc_a101;


-- DATA QUALITY CHECKS --
-- DATA standardization and Consistency
SELECT DISTINCT 
cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

select * from silver.erp_loc_a101;
