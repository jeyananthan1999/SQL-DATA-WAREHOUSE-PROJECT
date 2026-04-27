-- DATA LOADING INTO SILVER LAYER OF ERP_PX_CAT_G1v2 --

Truncate Table silver.erp_px_cat_g1v2;
Insert into silver.erp_px_cat_g1v2 (
id, 
cat,
subcat,
maintenance
)

Select
id,
cat,
subcat,
maintenance from bronze.erp_px_cat_g1v2;

-- ================================================================ --

-- DATA QUALITY CHECKS --

select * from silver.erp_px_cat_g1v2;
