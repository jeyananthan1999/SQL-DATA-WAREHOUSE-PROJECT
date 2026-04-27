-- Inserting into silver crm_cust_info --
Truncate Table silver.crm_cust_info;
insert into silver.crm_cust_info (
	cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)

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

-- ---> DATA QUALITY CHECKS <--- -- 
-- Check for Nulls and Duplicates in Primary key --
SELECT 
cst_id,
count(*) as id_count
FROM silver.crm_cust_info
group by cst_id 
having count(*) > 1 or cst_id is null;

-- Check for unwanted spaces in firstname --
select cst_firstname from silver.crm_cust_info
where cst_firstname != trim(cst_firstname);

-- Check for unwanted spaces in lastname --
select cst_lastname from silver.crm_cust_info
where cst_lastname != trim(cst_lastname);

-- Check for unwanted spaces in gender --
select cst_gndr from silver.crm_cust_info
where cst_gndr != trim(cst_gndr);            

-- Check for unwanted spaces in marital_status --
select cst_marital_status from silver.crm_cust_info
where cst_marital_status != trim(cst_marital_status);             

-- Data standardization and consistency -- 
select distinct cst_gndr from silver.crm_cust_info;              
select distinct cst_marital_status from silver.crm_cust_info;    

SELECT * FROM silver.crm_cust_info;  -- viewing table --
