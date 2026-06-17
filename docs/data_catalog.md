# Gold Layer — Data Catalog

## Overview
The Gold Layer represents the business-ready tier of the data warehouse, structured
as a **Star Schema** to support analytical queries, reporting, and business intelligence
consumption. It consists of two dimension tables and one central fact table.

---

## Dimension Tables

---

### `gold.dim_customers`
**Purpose:** Unified customer profile combining CRM and ERP data sources, enriched
with demographic and geographic attributes for segmentation and reporting.

| Column Name     | Data Type       | Description                                                                 |
|-----------------|-----------------|-----------------------------------------------------------------------------|
| customer_key    | INT             | Surrogate key — system-generated unique identifier for each customer record |
| customer_id     | INT             | Source system numerical identifier assigned to the customer                 |
| customer_number | NVARCHAR(40)    | Alphanumeric customer code used for tracking and cross-system referencing   |
| first_name      | NVARCHAR(40)    | Customer's first name as recorded in the source CRM system                  |
| last_name       | NVARCHAR(40)    | Customer's last name or family name                                         |
| country         | NVARCHAR(40)    | Country of residence (e.g., 'Australia', 'United States', 'Germany')        |
| marital_status  | NVARCHAR(40)    | Standardised marital status (e.g., 'Married', 'Single', 'Unknown')          |
| gender          | NVARCHAR(40)    | Resolved gender value, defaulting to ERP source if CRM is unknown           |
| birthdate       | DATE            | Date of birth formatted as YYYY-MM-DD (e.g., 1971-10-06)                   |
| create_date     | DATE            | Date the customer record was originally created in the source system         |

---

### `gold.dim_products`
**Purpose:** Comprehensive product reference combining product details and category
classifications, filtered to active products only (no historical end-dated records).

| Column Name    | Data Type       | Description                                                                       |
|----------------|-----------------|-----------------------------------------------------------------------------------|
| product_key    | INT             | Surrogate key — system-generated unique identifier for each product record        |
| product_id     | INT             | Source system numerical identifier assigned to the product                        |
| product_number | NVARCHAR(40)    | Structured alphanumeric product code used for inventory and categorization        |
| product_name   | NVARCHAR(40)    | Descriptive product name including type, color, and size details                  |
| category_id    | NVARCHAR(40)    | Identifier linking the product to its high-level category classification          |
| category       | NVARCHAR(40)    | Broad product classification grouping related items (e.g., 'Bikes', 'Components') |
| subcategory    | NVARCHAR(40)    | Granular product classification within the category (e.g., 'Road Bikes')          |
| maintenance    | NVARCHAR(40)    | Indicates whether the product requires maintenance ('Yes' / 'No')                 |
| cost           | INT             | Base cost of the product in whole monetary units                                  |
| product_line   | NVARCHAR(40)    | Product line or series the product belongs to (e.g., 'Road', 'Mountain')          |
| start_date     | DATE            | Date the product became available for sale, formatted as YYYY-MM-DD               |

---

## Fact Tables

---

### `gold.fact_sales`
**Purpose:** Central fact table capturing transactional sales data at the line-item
level. Links to both dimension tables via surrogate keys to enable slicing and
aggregation across customers and products.

| Column Name   | Data Type       | Description                                                                        |
|---------------|-----------------|------------------------------------------------------------------------------------|
| order_number  | NVARCHAR(40)    | Unique alphanumeric identifier for each sales order (e.g., 'SO54496')             |
| product_key   | INT             | Foreign key referencing `gold.dim_products` — links the sale to a product          |
| customer_key  | INT             | Foreign key referencing `gold.dim_customers` — links the sale to a customer        |
| order_date    | DATE            | Date the order was placed by the customer                                          |
| shipping_date | DATE            | Date the order was dispatched to the customer                                      |
| due_date      | DATE            | Date the order payment was due                                                     |
| sales_amount  | INT             | Total monetary value of the line item in whole currency units (e.g., 25)           |
| quantity      | INT             | Number of product units ordered for the line item (e.g., 1)                        |
| price         | INT             | Per-unit price of the product at the time of the order in whole currency units     |