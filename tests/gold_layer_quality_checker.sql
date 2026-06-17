/*

Script Purpose:
    This script validates the integrity, consistency, and accuracy of the
    Gold Layer. A series of targeted checks are run across all gold objects
    to ensure the data model is fit for analytical consumption, including:
    - Surrogate key uniqueness across all dimension tables
    - Referential integrity between the fact table and its dimensions
    - Detection of orphaned records that would break analytical joins

Usage Notes:
    - Execute after every run of the gold layer view definitions
    - Any query returning results indicates a data model issue that
      must be investigated and resolved before exposing to reporting tools

*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================

-- Surrogate Key Uniqueness: Ensure No Customer Key Appears More Than Once
-- Expectation: No Results
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM 
    gold.dim_customers
GROUP BY 
    customer_key
HAVING 
    COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================

-- Surrogate Key Uniqueness: Ensure No Product Key Appears More Than Once
-- Expectation: No Results
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM 
    gold.dim_products
GROUP BY 
    product_key
HAVING 
    COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================

-- Referential Integrity: Detect Orphaned Records with No Matching Dimension
-- Expectation: No Results
SELECT * 
FROM 
    gold.fact_sales f
LEFT JOIN 
    gold.dim_customers c
ON 
    c.customer_key = f.customer_key
LEFT JOIN 
    gold.dim_products p
ON 
    p.product_key = f.product_key
WHERE 
    p.product_key IS NULL 
    OR c.customer_key IS NULL;