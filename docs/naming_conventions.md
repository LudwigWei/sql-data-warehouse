# Naming Conventions

This document outlines the naming conventions used for schemas, tables, views,
columns, and other objects in the data warehouse.

---

## Table of Contents
1. [General Principles](#general-principles)
2. [Table Naming Conventions](#table-naming-conventions)
   - [Bronze Rules](#bronze-rules)
   - [Silver Rules](#silver-rules)
   - [Gold Rules](#gold-rules)
3. [Column Naming Conventions](#column-naming-conventions)
   - [Surrogate Keys](#surrogate-keys)
   - [Technical Columns](#technical-columns)
4. [Stored Procedures](#stored-procedure-naming-conventions)

---

## General Principles

| Principle          | Description                                                             |
|--------------------|-------------------------------------------------------------------------|
| **Naming Style**   | Use `snake_case` — lowercase letters with underscores to separate words |
| **Language**       | All object names must be written in English                             |
| **Reserved Words** | Do not use SQL reserved words as object names                           |

---

## Table Naming Conventions

### Bronze Rules

Tables in the Bronze layer must preserve the source system name and original
table name exactly, without any renaming or transformation.

**Pattern:** `<sourcesystem>_<entity>`

| Component          | Description                                              |
|--------------------|----------------------------------------------------------|
| `<sourcesystem>`   | Name of the source system (e.g., `crm`, `erp`)          |
| `<entity>`         | Exact table name as it appears in the source system      |

**Example:**

| Table Name            | Description                                    |
|-----------------------|------------------------------------------------|
| `crm_customer_info`   | Customer information sourced from the CRM system |
| `erp_loc_a101`        | Location data sourced from the ERP system        |

---

### Silver Rules

Tables in the Silver layer follow the same naming pattern as Bronze — source
system name preserved, original entity name unchanged.

**Pattern:** `<sourcesystem>_<entity>`

| Component          | Description                                              |
|--------------------|----------------------------------------------------------|
| `<sourcesystem>`   | Name of the source system (e.g., `crm`, `erp`)          |
| `<entity>`         | Exact table name as it appears in the source system      |

**Example:**

| Table Name            | Description                                          |
|-----------------------|------------------------------------------------------|
| `crm_customer_info`   | Cleansed customer information from the CRM system    |
| `erp_cust_az12`       | Standardised customer demographics from the ERP system |

---

### Gold Rules

Tables in the Gold layer must use meaningful, business-aligned names prefixed
by the table's role in the data model.

**Pattern:** `<category>_<entity>`

| Component        | Description                                                                  |
|------------------|------------------------------------------------------------------------------|
| `<category>`     | Describes the role of the table (e.g., `dim`, `fact`, `report`)             |
| `<entity>`       | Business-aligned descriptive name (e.g., `customers`, `products`, `sales`)  |

**Example:**

| Table Name              | Description                                        |
|-------------------------|----------------------------------------------------|
| `dim_customers`         | Dimension table for customer data                  |
| `dim_products`          | Dimension table for product data                   |
| `fact_sales`            | Fact table containing sales transactions           |
| `report_sales_monthly`  | Report table for monthly sales aggregations        |

#### Category Prefix Glossary

| Prefix      | Role             | Examples                                     |
|-------------|------------------|----------------------------------------------|
| `dim_`      | Dimension table  | `dim_customers`, `dim_products`              |
| `fact_`     | Fact table       | `fact_sales`                                 |
| `report_`   | Report table     | `report_customers`, `report_sales_monthly`   |

---

## Column Naming Conventions

### Surrogate Keys

All primary keys in dimension tables must use the `_key` suffix.

**Pattern:** `<table_name>_key`

| Component        | Description                                                         |
|------------------|---------------------------------------------------------------------|
| `<table_name>`   | Name of the table or entity the key belongs to                      |
| `_key`           | Suffix indicating this column is a surrogate key                    |

**Example:**

| Column Name      | Description                                          |
|------------------|------------------------------------------------------|
| `customer_key`   | Surrogate key in the `dim_customers` table           |
| `product_key`    | Surrogate key in the `dim_products` table            |

---

### Technical Columns

All system-generated metadata columns must use the `dwh_` prefix.

**Pattern:** `dwh_<column_name>`

| Component          | Description                                                       |
|--------------------|-------------------------------------------------------------------|
| `dwh_`             | Prefix reserved exclusively for system-generated metadata         |
| `<column_name>`    | Descriptive name indicating the column's purpose                  |

**Example:**

| Column Name        | Description                                                        |
|--------------------|--------------------------------------------------------------------|
| `dwh_load_date`    | Stores the date the record was loaded into the data warehouse      |
| `dwh_source`       | Tracks the source system from which the record originated          |

---

## Stored Procedures

All stored procedures used for loading data must follow the pattern below.

**Pattern:** `load_<layer>`

| Component    | Description                                                    |
|--------------|----------------------------------------------------------------|
| `<layer>`    | The target layer being loaded (`bronze`, `silver`, or `gold`)  |

**Example:**

| Procedure Name   | Description                                           |
|------------------|-------------------------------------------------------|
| `load_bronze`    | Loads raw data from source CSV files into Bronze      |
| `load_silver`    | Transforms and loads cleansed data into Silver        |
| `load_gold`      | Builds business-ready views in the Gold layer         |