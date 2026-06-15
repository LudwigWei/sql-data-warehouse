/*

Script Purpose:
    Creates the 'DataWarehouse' database and initialises the three schema
    layers of the Medallion Architecture:
        - bronze : raw ingestion zone, data stored as-is from source systems
        - silver : cleansed, standardised, and normalised data
        - gold   : business-ready data modelled into a star schema for analytics

WARNING:
    Running this script will DROP the 'DataWarehouse' database if it already
    exists, permanently deleting ALL data, tables, and objects within it.
    This action is IRREVERSIBLE. Ensure you have a backup before proceeding.

*/

USE master;
GO

-- Drop and recreate the database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Bronze schema
CREATE SCHEMA bronze;
GO

-- Silver schema
CREATE SCHEMA silver;
GO

-- Gold schema
CREATE SCHEMA gold;
GO