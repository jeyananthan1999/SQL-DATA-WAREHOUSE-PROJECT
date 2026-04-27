-- Check for Unwanted spaces --
select * from bronze.erp_px_cat_g1v2
where cat != Trim(cat) or subcat != Trim(subcat) or maintenance != Trim(maintenance);  -- No unwanted Spaces

-- Data Standardization and Consistency
select distinct cat from bronze.erp_px_cat_g1v2;         -- No issues found 
select distinct subcat from bronze.erp_px_cat_g1v2;      -- No issues found
select distinct maintenance from bronze.erp_px_cat_g1v2; -- No issues found

-- THIS TABLE IS PERFECT, NO DATA QUALITY ISSUES, SO LOAD DIRECTLY INTO SILVER LAYER