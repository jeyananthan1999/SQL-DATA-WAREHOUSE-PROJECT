/*
=============================================================
Create Schemas
=============================================================
Script Purpose:
    -> This script sets up or creates three schemas, 'bronze', 'silver', and 'gold'. 
    -> If those three schemas exists already, it drops and creates new one.
	
WARNING:
    -> Running this script will drop the schemas if it exists already. 
    -> All data in the databases will be permanently deleted. Proceed with caution 
    -> Ensure you have proper backups before running this script.
*/

-- Drop databases if they already exist
DROP DATABASE IF EXISTS bronze;
DROP DATABASE IF EXISTS silver;
DROP DATABASE IF EXISTS gold;

-- Create databases (schemas)
CREATE DATABASE bronze;
CREATE DATABASE silver;
CREATE DATABASE gold;
