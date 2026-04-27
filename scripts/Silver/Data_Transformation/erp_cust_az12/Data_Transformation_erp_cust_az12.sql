-- Identify Out of Range Dates --

select distinct bdate from bronze.erp_cust_az12
where bdate < "1924-01-01" OR bdate > current_date();    

-- Data Standardization and consistency
select distinct gen as old_gen,
CASE
	when upper(gen) LIKE "M%" THEN "Male"
    when upper(gen) LIKE "F%" THEN "Female"
    else "Unknown"
END as gen
from bronze.erp_cust_az12;


-- DATA TRANSFORMATION: EXTRACTING CST_KEY FROM CID --
select 
CASE
	when cid LIKE "NAS%" THEN SUBSTRING(cid,4,length(cid))
    else cid                                                      -- Removing NAS prefix if present
END as cid,
bdate,
gen
from bronze.erp_cust_az12;

-- DATA TRANFORMATION: FIXING EXTREME OUT OF RANGE DATES --
select 
CASE
	when cid LIKE "NAS%" THEN SUBSTRING(cid,4,length(cid))
    else cid
END as cid,
CASE
	when bdate > current_date() THEN null             -- Fixing only the higher extreme or future dates
    else bdate
END as bdate,
gen
from bronze.erp_cust_az12;

-- DATA TRANSFORMATION - FIXING GENDER COLUMN INCONSISTENCIES
select 
CASE
	when cid LIKE "NAS%" THEN SUBSTRING(cid,4,length(cid))
    else cid
END as cid,
CASE
	when bdate > current_date() THEN null             
    else bdate
END as bdate,
CASE
	when upper(gen) LIKE "M%" THEN "Male"
    when upper(gen) LIKE "F%" THEN "Female"
    else "Unknown"
END as gen                                         -- Gender standardization and handling blank and NULLs in gender column
from bronze.erp_cust_az12;