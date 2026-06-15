/*

DDL Script: Creation of 'Bronze' Tables

Script Purpose:
    This script defines the DDL for all tables in the 'bronze' schema.
    Each table is dropped and recreated to ensure a clean structure.

WARNING:
    Running this script will DROP and recreate all 'bronze' tables,
    permanently deleting any existing data within them.
    This action is IRREVERSIBLE. Ensure you have a backup before proceeding.

*/

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
	cst_id             INT,
	cst_key            NVARCHAR(40),
	cst_firstname      NVARCHAR(40),
	cst_lastname	   NVARCHAR(40),
	cst_marital_status NVARCHAR(40),
	cst_gndr		   NVARCHAR(40),
	cst_create_date    DATE
);
GO

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
	prd_id       INT,
	prd_key      NVARCHAR(40),
	prd_nm       NVARCHAR(40), 
	prd_cost     INT,
	prd_line     NVARCHAR(40),
	prd_start_dt DATETIME,
	prd_end_dt   DATETIME
);
GO

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
	sls_ord_num  NVARCHAR(40),
	sls_prd_key  NVARCHAR(40),
	sls_cust_id  INT,
	sls_order_dt INT,
	sls_ship_dt  INT,
	sls_due_dt   INT,
	sls_sales    INT,
	sls_quantity INT,
	sls_price    INT
);
GO

IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid    NVARCHAR(40),
    cntry  NVARCHAR(40)
);
GO

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
	cid	   NVARCHAR(40),
	bdate  DATE,
	gen	   NVARCHAR(40)
);
GO

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(40),
    cat          NVARCHAR(40),
    subcat       NVARCHAR(40),
    maintenance  NVARCHAR(40)
);
GO