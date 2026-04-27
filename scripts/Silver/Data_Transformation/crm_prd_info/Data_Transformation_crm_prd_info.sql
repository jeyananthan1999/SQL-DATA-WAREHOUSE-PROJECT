-- Check for Nulls and Duplicates in Primary key --
SELECT 
prd_id,
count(*) as id_count
FROM bronze.crm_prd_info
group by prd_id 
having count(*) > 1 or prd_id is null;  -- --> NO DUPLICATES IN PRIMARY KEY <-- --

-- Check for unwanted spaces in prd_nm --
select prd_nm from bronze.crm_prd_info
where prd_nm != trim(prd_nm);     -- --> There is no unwanted spaces in prd_nm <-- --

-- Check for NULLs or Negative numbers in prd_cost column --
select prd_cost from bronze.crm_prd_info
where prd_cost < 0 or prd_cost is NULL ;   -- --> There is no negative numbers or NULLs in prd_cost <-- --

-- Data standardization and consistency -- 
select distinct prd_line from bronze.crm_prd_info;   -- M,S,T,R, blank  

-- Check for Invalid Date Orders -- 
select * from bronze.crm_prd_info
where prd_end_dt < prd_start_dt;  -- --> The end date is less than start date <-- --


----- > DATA TRANFORMATION <------
-- --> splitting prd_key into cat_id and n_prd_key <-- --
SELECT 
	prd_id,
	prd_key,
	REPLACE(SUBSTRING( prd_key , 1,5),'-','_') as cat_id,
	SUBSTRING( prd_key , 7 , length(prd_key)) as n_prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info;

-- --> Abbreviating prd_line column <-- --
SELECT 
	prd_id,
	prd_key,
	REPLACE(SUBSTRING( prd_key , 1,5),'-','_') as cat_id,
	SUBSTRING( prd_key , 7 , length(prd_key)) as n_prd_key,
	prd_nm,
	prd_cost,
	CASE 
		when UPPER(TRIM(prd_line)) = "M" THEN "Mountain"
        when UPPER(TRIM(prd_line)) = "S" THEN "Other Sales"
        when UPPER(TRIM(prd_line)) = "T" THEN "Touring"
        when UPPER(TRIM(prd_line)) = "R" THEN "Road"
        else "Unknown"
    END as prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info;

-- --> restructuring the start date and end date <-- --
SELECT 
	prd_id,
	REPLACE(SUBSTRING( prd_key , 1,5),'-','_') as cat_id,
	SUBSTRING( prd_key , 7 , length(prd_key)) as prd_key,
	prd_nm,
	prd_cost,
	CASE 
		when UPPER(TRIM(prd_line)) = "M" THEN "Mountain"
        when UPPER(TRIM(prd_line)) = "S" THEN "Other Sales"
        when UPPER(TRIM(prd_line)) = "T" THEN "Touring"
        when UPPER(TRIM(prd_line)) = "R" THEN "Road"
        else "Unknown"
    END as prd_line,
	Date(prd_start_dt) as prd_start_dt,
	Date(date_sub(
		Lead(prd_start_dt) over(partition by prd_key order by prd_start_dt),
        interval 1 Day 
        )) as prd_end_dt
FROM bronze.crm_prd_info;




