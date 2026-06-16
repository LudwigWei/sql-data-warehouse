/*

Script Purpose:
    This script validates the integrity, consistency, and standardization of
    data loaded into the 'silver' layer. A series of targeted checks are run
    across all silver tables to surface any issues that may have been
    introduced during the bronze-to-silver transformation, including:
    - Primary key violations (NULLs and duplicates)
    - Untrimmed or dirty string values
    - Non-standardized categorical fields
    - Out-of-range or logically inconsistent date values
    - Broken business rules between related numeric fields

Usage Notes:
    - Execute after every run of silver.load_silver
    - Any query returning results indicates a data quality issue that
      must be investigated and resolved before proceeding to the gold layer

*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================

-- Primary Key Integrity: Detect NULLs and Duplicate Records
-- Expectation: No Results
SELECT 
    cst_id,
    COUNT(*) AS null_or_dupes
FROM 
    silver.crm_cust_info
GROUP BY 
    cst_id
HAVING 
    COUNT(*) > 1 OR cst_id IS NULL;

-- String Cleanliness: Flag Records with Leading or Trailing Spaces
-- Expectation: No Results
SELECT 
    cst_key 
FROM 
    silver.crm_cust_info
WHERE 
    cst_key != TRIM(cst_key);

-- Value Distribution: Verify Marital Status Standardization
SELECT DISTINCT 
    cst_marital_status 
FROM 
    silver.crm_cust_info;

-- ====================================================================
-- Checking 'silver.crm_prd_info'
-- ====================================================================

-- Primary Key Integrity: Detect NULLs and Duplicate Records
-- Expectation: No Results
SELECT 
    prd_id,
    COUNT(*) AS null_or_dupes 
FROM 
    silver.crm_prd_info
GROUP BY 
    prd_id
HAVING  
    COUNT(*) > 1 OR prd_id IS NULL;

-- String Cleanliness: Flag Product Names with Leading or Trailing Spaces
-- Expectation: No Results
SELECT 
    prd_nm 
FROM 
    silver.crm_prd_info
WHERE 
    prd_nm != TRIM(prd_nm);

-- Numeric Integrity: Detect Negative or Missing Cost Values
-- Expectation: No Results
SELECT 
    prd_cost 
FROM 
    silver.crm_prd_info
WHERE 
    prd_cost < 0 OR prd_cost IS NULL;

-- Value Distribution: Verify Product Line Standardization
SELECT DISTINCT 
    prd_line 
FROM 
    silver.crm_prd_info;

-- Date Logic: Ensure Start Date Does Not Exceed End Date
-- Expectation: No Results
SELECT 
    * 
FROM 
    silver.crm_prd_info
WHERE 
    prd_end_dt < prd_start_dt;

-- ====================================================================
-- Checking 'silver.crm_sales_details'
-- ====================================================================

-- Date Validity: Identify Out-of-Range or Malformed Date Values
-- Expectation: No Results
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM 
    bronze.crm_sales_details
WHERE 
    sls_due_dt <= 0 
    OR LEN(sls_due_dt) != 8 
    OR sls_due_dt > 20500101 
    OR sls_due_dt < 19000101;

-- Date Logic: Ensure Order Date Does Not Exceed Ship or Due Dates
-- Expectation: No Results
SELECT 
    * 
FROM 
    silver.crm_sales_details
WHERE 
    sls_order_dt > sls_ship_dt 
    OR sls_order_dt > sls_due_dt;

-- Business Rule: Confirm Sales Equals Quantity Multiplied by Price
-- Expectation: No Results
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM 
    silver.crm_sales_details
WHERE 
    sls_sales != sls_quantity * sls_price
    OR sls_sales IS NULL 
    OR sls_quantity IS NULL 
    OR sls_price IS NULL
    OR sls_sales <= 0 
    OR sls_quantity <= 0 
    OR sls_price <= 0
ORDER BY 
    sls_sales, 
    sls_quantity, 
    sls_price;

-- ====================================================================
-- Checking 'silver.erp_cust_az12'
-- ====================================================================

-- Date Validity: Flag Birthdates Outside Acceptable Range
-- Expectation: No Results
SELECT DISTINCT 
    bdate 
FROM    
    silver.erp_cust_az12
WHERE 
    bdate < '1924-01-01' 
    OR bdate > GETDATE();

-- Value Distribution: Verify Gender Standardization
SELECT DISTINCT 
    gen 
FROM 
    silver.erp_cust_az12;

-- ====================================================================
-- Checking 'silver.erp_loc_a101'
-- ====================================================================

-- Value Distribution: Verify Country Name Standardization
SELECT DISTINCT 
    cntry 
FROM 
    silver.erp_loc_a101
ORDER BY 
    cntry;

-- ====================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ====================================================================

-- String Cleanliness: Flag Category Fields with Leading or Trailing Spaces
-- Expectation: No Results
SELECT 
    * 
FROM    
    silver.erp_px_cat_g1v2
WHERE 
    cat != TRIM(cat) 
    OR subcat != TRIM(subcat) 
    OR maintenance != TRIM(maintenance);

-- Value Distribution: Verify Maintenance Flag Standardization
SELECT DISTINCT 
    maintenance 
FROM 
    silver.erp_px_cat_g1v2;