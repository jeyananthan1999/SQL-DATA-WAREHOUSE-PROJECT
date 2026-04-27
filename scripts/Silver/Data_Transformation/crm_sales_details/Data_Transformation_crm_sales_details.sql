select * from bronze.crm_sales_details;

-- Unwanted spaces check in sls_ord_num --
select * from bronze.crm_sales_details
where sls_ord_num != trim(sls_ord_num);      -- No unwanted spaces in sls_ord_num --

-- Intergrity check for columns sls_prd_key and sls_cust_id --
select * from bronze.crm_sales_details
where sls_prd_key NOT IN (select prd_key from silver.crm_prd_info);     -- prd_key from cust_sales_details can be used to connect to cust_prd_info --

select * from bronze.crm_sales_details
where sls_cust_id NOT IN (select cst_id from silver.crm_cust_info);    -- cust_id from cust_sales_details can be used to connect to cust_cust_info --


-- check for Invalid dates in sls_order_dt -- 
select
NULLIF(sls_order_dt,0) as sls_order_dt   --  zeros in order date replaced with NULL --
from bronze.crm_sales_details
where sls_order_dt <= 0     
or length(sls_order_dt) != 8            -- two invalid date values 32154 and 5489 --
or sls_order_dt > 20500101
or sls_order_dt < 19000101;      

-- check for Invalid dates in sls_ship_dt -- 
select
NULLIF(sls_ship_dt,0) as sls_ship_dt   --  zeros in ship date will be replaced with NULL --
from bronze.crm_sales_details
where sls_ship_dt <= 0     
or length(sls_ship_dt) != 8           
or sls_ship_dt > 20500101
or sls_ship_dt < 19000101;            -- no invalid dates in sls_ship_dt -- 

-- check for Invalid dates in sls_due_dt -- 
select
NULLIF(sls_due_dt,0) as sls_due_dt   --  zeros in due date will be replaced with NULL --
from bronze.crm_sales_details
where sls_due_dt <= 0     
or length(sls_due_dt) != 8           
or sls_due_dt > 20500101
or sls_due_dt < 19000101;            -- no invalid dates in sls_due_dt -- 

-- Invalid Date Orders --
select * from bronze.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;  -- No invalid date orders -- 

-- Data consistency Check: Between Sales, Quantity and Price
-- >> SALES = QUANTITY * PRICE
-- >> Values must not be NULL, Zero or negative

select distinct 
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is NULL or sls_price is NULL or sls_quantity is NULL
or sls_sales <= 0 or sls_price <= 0 or sls_quantity <=0
order by sls_sales, sls_quantity, sls_price;

 -- RULES 
-- If sales is negative, zero or null, derive it using Quantity and Price.
-- If Price is zero or null, calculate it using Sales and Quantity.
-- If Price is negative, convert to positive.     
with sales_price as (select
	sls_sales as old_sls_sales,
	sls_quantity,
	sls_price as old_sls_price,
    Case
		when sls_price is NULL or sls_price <= 0 then sls_sales/NULLIF(sls_quantity,0)
        else sls_price
    end as sls_price
from bronze.crm_sales_details)
select 
	old_sls_sales,
	sls_quantity,
	sls_price,
	Case
			when old_sls_sales is NULL or old_sls_sales <= 0 or old_sls_sales != sls_quantity * abs(sls_price) then sls_quantity * abs(sls_price)
			else old_sls_sales
	end as sls_sales
from sales_price 
where old_sls_sales != sls_quantity * old_sls_price
or old_sls_sales is NULL or old_sls_price is NULL or sls_quantity is NULL
or old_sls_sales <= 0 or old_sls_price <= 0 or sls_quantity <=0
order by old_sls_sales, sls_quantity, old_sls_price;


-- DATA TRANSFORMATION OF DATE COLUMNS --
select 
	sls_ord_num, 
	sls_prd_key, 
	sls_cust_id,
	Case
		when sls_order_dt = 0 or length(sls_order_dt) != 8 then null
		else cast(sls_order_dt as date)
	end as sls_order_dt,
    Case
		when sls_ship_dt = 0 or length(sls_ship_dt) != 8 then null
		else cast(sls_ship_dt as date)
	end as sls_ship_dt,
     Case
		when sls_due_dt = 0 or length(sls_due_dt) != 8 then null
		else cast(sls_due_dt as date)
	end as sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
from bronze.crm_sales_details;

-- DATA TRANSFORMATION OF DATE, Sales, Quantity and Price Columns --
 with sales_price as (select 
	sls_ord_num, 
	sls_prd_key, 
	sls_cust_id,
	Case
		when sls_order_dt = 0 or length(sls_order_dt) != 8 then null
		else cast(sls_order_dt as date)
	end as sls_order_dt,
    Case
		when sls_ship_dt = 0 or length(sls_ship_dt) != 8 then null
		else cast(sls_ship_dt as date)
	end as sls_ship_dt,
     Case
		when sls_due_dt = 0 or length(sls_due_dt) != 8 then null
		else cast(sls_due_dt as date)
	end as sls_due_dt,
	sls_sales as old_sls_sales,
	sls_quantity,
	  Case
		when sls_price is NULL or sls_price <= 0 then sls_sales/NULLIF(sls_quantity,0)
        else sls_price
    end as sls_price
from bronze.crm_sales_details),

CTE as (select *,
Case
		when old_sls_sales is NULL or old_sls_sales <= 0 or old_sls_sales != sls_quantity * abs(sls_price) then sls_quantity * abs(sls_price)
        else old_sls_sales
end as sls_sales
from sales_price)

select
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt, 
sls_sales,
sls_quantity,
sls_price
from CTE;










