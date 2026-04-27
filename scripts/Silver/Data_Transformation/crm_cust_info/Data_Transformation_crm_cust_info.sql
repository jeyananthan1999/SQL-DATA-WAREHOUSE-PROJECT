-- Check for Nulls and Duplicates in Primary key --
SELECT 
cst_id,
count(*) as id_count
FROM bronze.crm_cust_info
group by cst_id 
having count(*) > 1 or cst_id is null;

-- Check for unwanted spaces in firstname --
select cst_firstname from bronze.crm_cust_info
where cst_firstname != trim(cst_firstname);

-- Check for unwanted spaces in lastname --
select cst_lastname from bronze.crm_cust_info
where cst_lastname != trim(cst_lastname);

-- Check for unwanted spaces in gender --
select cst_gndr from bronze.crm_cust_info
where cst_gndr != trim(cst_gndr);            -- The gender column does not have any unwanted space -- 

-- Check for unwanted spaces in marital_status --
select cst_marital_status from bronze.crm_cust_info
where cst_marital_status != trim(cst_marital_status);            -- The marital status column does not have any unwanted space -- 

-- Data standardization and consistency -- 
select distinct cst_gndr from bronze.crm_cust_info;              -- M,F, blank
select distinct cst_marital_status from bronze.crm_cust_info;    -- M,S, balnk

-- Removing Duplicates from crm_cust_info --

with rank_flag as (
select *,
row_number() over( partition by cst_id order by cst_create_date desc) as rank_flag
from bronze.crm_cust_info)

select * from rank_flag
where rank_flag = 1;

-- Deleting the record for cst_id = 0 because it does not have any entries in firstname, lastname, gender --
SET SQL_SAFE_UPDATES = 0;

Delete from bronze.crm_cust_info
where cst_id = 0 ;

-- Removing unwanted spaces from firstname and lastname -- 
with rank_flag as (
select *,
row_number() over( partition by cst_id order by cst_create_date desc) as rank_flag
from bronze.crm_cust_info )

select 
	cst_id, 
	cst_key,
	Trim(cst_firstname)  as cst_firstname,
	Trim(cst_lastname) as cst_lastname, 
	cst_marital_status,
	cst_gndr, 
	cst_create_date
from rank_flag
where rank_flag = 1;

-- Abbreviating gender and marital status and assigning unknown for blank entries  -- 
with rank_flag as (
select *,
row_number() over( partition by cst_id order by cst_create_date desc) as rank_flag
from bronze.crm_cust_info )

select 
	cst_id, 
	cst_key,
	Trim(cst_firstname)  as cst_firstname,
	Trim(cst_lastname) as cst_lastname, 
	case
		when upper(trim(cst_marital_status)) = "S" Then "Single"
        when upper(trim(cst_marital_status)) = "M" Then "Married"
        else "Unknown"
    end as cst_marital_status,
	case
		when upper(trim(cst_gndr)) = "F" Then "Female"
        when upper(trim(cst_gndr)) = "M" Then "Male"
        else "Unknown"
    end as cst_gndr,
	cst_create_date
from rank_flag
where rank_flag = 1;


