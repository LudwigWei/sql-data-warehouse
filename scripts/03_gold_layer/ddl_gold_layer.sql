/*

Script Purpose:
    This script creates the views that define the Gold Layer of the data
    warehouse, modelled as a Star Schema optimised for analytical queries
    and reporting. It includes the following objects:

    - gold.dim_customers : Customer dimension combining CRM and ERP data,
                           resolving gender conflicts and enriching with
                           location and demographic attributes
    - gold.dim_products  : Product dimension joining product info with
                           category data, filtered to active products only
    - gold.fact_sales    : Central fact table linking sales transactions
                           to their respective customer and product keys

Usage Notes:
    - Run this script after silver.load_silver has been executed successfully
    - Views are dropped and recreated on each run; no data is persisted here
    - The fact table references gold dimension views; ensure dimensions are
      created before running gold.fact_sales

*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER () OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE
		WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr
			ELSE COALESCE(ca.gen, 'Unknown')
		END AS gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM 
	silver.crm_cust_info AS ci
LEFT JOIN
	silver.erp_cust_az12 AS ca
ON
	ci.cst_key = ca.cid
LEFT JOIN
	silver.erp_loc_a101 AS la
ON
	ci.cst_key = la.cid
GO


-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pd.prd_start_dt, pd.prd_key) AS product_key,
	pd.prd_id AS product_id,
	pd.prd_key AS product_number,
	pd.prd_nm AS product_name,
	pd.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pd.prd_cost AS cost,
	pd.prd_line AS product_line,
	pd.prd_start_dt AS start_date
FROM
	silver.crm_prd_info AS pd
LEFT JOIN
	silver.erp_px_cat_g1v2 AS pc
ON
	pd.cat_id = pc.id
WHERE
	pd.prd_end_dt IS NULL;
GO


-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM
	silver.crm_sales_details sd
LEFT JOIN
	gold.dim_products AS pr
ON 
	sd.sls_prd_key = pr.product_number
LEFT JOIN
	gold.dim_customers AS cu
ON 
	sd.sls_cust_id = cu.customer_id

GO
