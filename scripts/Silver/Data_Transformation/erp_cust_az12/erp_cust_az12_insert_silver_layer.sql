-- DATA LOADING INTO SILVER LAYER OF ERP_CUST_AZ12 --

Truncate Table silver.erp_cust_az12;
Insert into silver.erp_cust_az12 (
cid,
bdate, 
gen
)

select 
CASE
	when cid LIKE "NAS%" THEN SUBSTRING(cid,4,length(cid))
    else cid
END as cid,                                          -- Remove NAS prefix if present
CASE
	when bdate > current_date() THEN null             
    else bdate                                           
END as bdate,                                        -- Set future bdates to NULL
CASE
	when upper(gen) LIKE "M%" THEN "Male"
    when upper(gen) LIKE "F%" THEN "Female"
    else "Unknown"
END as gen                                           -- Resolving Gender Inconsistencies and handle unknown cases
from bronze.erp_cust_az12;



-- DATA QUALITY CHECKS --

-- Identify Out of Range Dates --
select distinct bdate from silver.erp_cust_az12
where bdate < "1924-01-01" OR bdate > current_date(); 

-- Data Standardization and consistency
select distinct gen 
from silver.erp_cust_az12;

SELECT * FROM silver.erp_cust_az12;
