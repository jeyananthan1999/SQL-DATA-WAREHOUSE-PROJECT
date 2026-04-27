-- --> DATA LOADING INTO SILVER LAYER CRM_SALES_DETAILS TABLE <-- --
Truncate Table silver.crm_sales_details;

Insert into silver.crm_sales_details (
sls_ord_num, 
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)
 
with sales_price as (select 
	sls_ord_num, 
	sls_prd_key, 
	sls_cust_id,
	Case
		when sls_order_dt = 0 or length(sls_order_dt) != 8 then null
		else cast(sls_order_dt as date)                                   -- HANDLING INVALID DATE and DATA TYPECASTING --
	end as sls_order_dt,
    Case
		when sls_ship_dt = 0 or length(sls_ship_dt) != 8 then null
		else cast(sls_ship_dt as date)                                    -- HANDLING INVALID DATE and DATA TYPECASTING --
	end as sls_ship_dt,
     Case
		when sls_due_dt = 0 or length(sls_due_dt) != 8 then null
		else cast(sls_due_dt as date)                                     -- HANDLING INVALID DATE and DATA TYPECASTING --
	end as sls_due_dt,
	sls_sales as old_sls_sales,
	sls_quantity,
	  Case
		when sls_price is NULL or sls_price <= 0 then sls_sales/NULLIF(sls_quantity,0)
        else sls_price
    end as sls_price                                                    -- DERIVE PRICE IF ORIGINAL VALUE IS MISSING --
from bronze.crm_sales_details),

CTE as (select *,
Case
		when old_sls_sales is NULL or old_sls_sales <= 0 or old_sls_sales != sls_quantity * abs(sls_price) then sls_quantity * abs(sls_price)
        else old_sls_sales
end as sls_sales                                                       -- RECALCULATE SALES IF ORIGINAL VALUE IS MISSING OR INCORRECT --
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

-- -- > DATA QUALITY CHECKS < -- --

-- Invalid Date Orders --
select * from silver.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;  -- No invalid date orders -- 

-- Data consistency Check: Between Sales, Quantity and Price
-- >> SALES = QUANTITY * PRICE
-- >> Values must not be NULL, Zero or negative
select distinct 
	sls_sales,
	sls_quantity,
	sls_price
from silver.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is NULL or sls_price is NULL or sls_quantity is NULL
or sls_sales <= 0 or sls_price <= 0 or sls_quantity <=0
order by sls_sales, sls_quantity, sls_price;                           -- NO ERROR --

select * from silver.crm_sales_details;
