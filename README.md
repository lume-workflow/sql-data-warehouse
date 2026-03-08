# 🏗️ SQL Data Warehouse Project

A modern Data Warehouse built with **SQL Server**, covering the full data pipeline — from raw ingestion to analytics-ready models — following the **Medallion Architecture** (Bronze → Silver → Gold).

---

## 📖 Project Overview

This project consolidates sales data from two source systems — **ERP** and **CRM** — into a unified, query-optimized data warehouse. The goal is to enable reliable analytical reporting and data-driven decision making.

**Key highlights:**
- End-to-end ETL pipeline implemented in **T-SQL**
- Three-layer Medallion Architecture for data quality and traceability
- Dimensional modeling (Star Schema) in the Gold layer
- Stored procedures for automated, repeatable data loading
- Full documentation with architecture diagrams and a data catalog

---

## 🏛️ Architecture

The warehouse follows the Medallion Architecture, splitting the data journey into three well-defined layers:

| Layer | Description |
|-------|-------------|
| 🥉 **Bronze** | Raw data ingested as-is from CSV files (ERP & CRM). No transformations applied — this is the immutable source of truth. |
| 🥈 **Silver** | Cleaned, standardized, and normalized data. Handles deduplication, type casting, null handling, and key integration across sources. |
| 🥇 **Gold** | Business-ready dimensional model (Star Schema). Optimized for analytical queries, dashboards, and reporting. Implemented as **views** for performance. |

---

## 📊 Diagrams

### Data Flow
End-to-end flow of data from CRM and ERP sources through the Bronze, Silver, and Gold layers:

![Data Flow Diagram](https://raw.githubusercontent.com/lume-workflow/sql-data-warehouse/main/docs/DataFlow%20Diagram.drawio.png)

---

### Data Warehouse Architecture
Data types and transformations applied at each layer:

![Data Warehouse Diagram](https://raw.githubusercontent.com/lume-workflow/sql-data-warehouse/main/docs/Data_Warehouse_Diagram.drawio.png)

---

### Table Relations (Bronze & Silver)
Key relationships between tables across the Bronze and Silver layers:

![Tables Relations](https://raw.githubusercontent.com/lume-workflow/sql-data-warehouse/main/docs/Tables%20Relations.drawio.png)

---

### Sales Data Mart — Star Schema (Gold)
Dimensional model of the Gold layer, connecting fact and dimension tables via primary and foreign keys:

![Sales Data Mart](https://raw.githubusercontent.com/lume-workflow/sql-data-warehouse/main/docs/Sales%20Data%20Mart.drawio.png)

---

## 🗂️ Repository Structure

```
sql-data-warehouse/
│
├── datasets/                    # Source CSV files (ERP and CRM)
│
├── docs/                        # Documentation and architecture diagrams
│   ├── DataFlow Diagram.drawio.png
│   ├── Data_Warehouse_Diagram.drawio.png
│   ├── Sales Data Mart.drawio.png
│   ├── Tables Relations.drawio.png
│   └── data_catalog.md          # Gold layer data catalog
│
├── scripts/
│   ├── bronze/
│   │   ├── ddl_bronze.sql       # Creates Bronze tables
│   │   └── proc_load_bronze.sql # Stored procedure: BULK INSERT from CSV
│   ├── silver/
│   │   ├── ddl_silver.sql       # Creates Silver tables
│   │   └── proc_load_silver.sql # Stored procedure: cleanse & transform
│   └── gold/
│       └── ddl_gold.sql         # Creates Gold views (Star Schema)
│
├── LICENSE
└── README.md
```

---

## ⚙️ ETL Pipeline

### 🥉 Bronze — Raw Ingestion
The `proc_load_bronze` stored procedure loads all CSV files into the Bronze schema using `BULK INSERT`. Each run truncates and fully reloads the tables. Load duration is logged for monitoring.

**Tables loaded:**
- `bronze.crm_cust_info` — Customer master data (CRM)
- `bronze.crm_prd_info` — Product information (CRM)
- `bronze.crm_sales_details` — Sales transactions (CRM)
- `bronze.erp_cust_az12` — Customer details (ERP)
- `bronze.erp_loc_a101` — Customer location data (ERP)
- `bronze.erp_px_cat_g1v2` — Product category data (ERP)

### 🥈 Silver — Cleanse & Transform
The `proc_load_silver` stored procedure applies transformation rules and loads cleaned data into the Silver schema. Uses `TRY/CATCH` for error handling and tracks execution time per table.

**Key transformations:**
- `TRIM()` and `REPLACE()` to clean string fields
- `CASE` statements to standardize categorical values (e.g., gender, marital status)
- Date format normalization and derived column calculation
- `ROW_NUMBER()` for deduplication
- `LEAD()` for computing end dates in slowly changing dimensions
- Cross-source key integration (CRM ↔ ERP)

### 🥇 Gold — Dimensional Model
The Gold layer is implemented as **SQL Views**, avoiding data duplication while providing a clean, analytics-ready interface.

**Views:**
- `gold.dim_customers` — Customer dimension (integrated from CRM + ERP)
- `gold.dim_products` — Product dimension (integrated from CRM + ERP)
- `gold.fact_sales` — Sales fact table

> 📖 Full column descriptions and business definitions are available in [`docs/data_catalog.md`](docs/data_catalog.md).

---

## 🚀 How to Run

**Prerequisites:**
- SQL Server 2016 or later
- SQL Server Management Studio (SSMS) or Azure Data Studio

**Steps:**

1. Clone this repository:
   ```bash
   git clone https://github.com/lume-workflow/sql-data-warehouse.git
   ```

2. Create the database and schemas:
   ```sql
   CREATE DATABASE DataWarehouse;
   GO
   USE DataWarehouse;
   CREATE SCHEMA bronze;
   CREATE SCHEMA silver;
   CREATE SCHEMA gold;
   ```

3. Run the DDL scripts to create the tables and views:
   ```
   scripts/bronze/ddl_bronze.sql
   scripts/silver/ddl_silver.sql
   scripts/gold/ddl_gold.sql
   ```

4. Update the file paths inside `proc_load_bronze.sql` to match your local `datasets/` directory.

5. Execute the stored procedures in order:
   ```sql
   EXEC bronze.load_bronze;
   EXEC silver.load_silver;
   ```
   The Gold layer views are populated automatically from Silver.

6. Query the Gold layer for analysis:
   ```sql
   SELECT * FROM gold.fact_sales;
   SELECT * FROM gold.dim_customers;
   SELECT * FROM gold.dim_products;
   ```

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| **SQL Server** | Database engine and data processing |
| **T-SQL** | ETL logic, transformations, and modeling |
| **Draw.io** | Architecture and data model diagrams |
| **SSMS** | Query execution and development |

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 👤 Author

**Thiago Furtado Barbosa**

Data Architecture student with a background in both Data Engineering and Data Analysis. This project is part of an ongoing journey to build production-grade data solutions from the ground up.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/lume-workflow/)

