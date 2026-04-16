-- Drop databases if they already exist
DROP DATABASE IF EXISTS bronze;
DROP DATABASE IF EXISTS silver;
DROP DATABASE IF EXISTS gold;

-- Create databases (schemas)
CREATE DATABASE bronze;
CREATE DATABASE silver;
CREATE DATABASE gold;
