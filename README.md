# E-commerce SQL Data Warehouse & Power BI Dashboard

An end-to-end E-commerce Data Warehouse built in **SQL Server** using the **Medallion Architecture (Bronze, Silver, Gold)** and **Star Schema** data modeling, connected to an interactive 3-page **Power BI** analytics dashboard.

---

## 🏗️ Project Architecture & Pipeline

1. **Database & Schema Setup (`01_init_database_and_schemas.sql`)**
   - Initializes the `Commerce` database and creates the `Bronze`, `Silver`, and `Gold` schemas.
   - Transfers raw source tables (`Customers`, `Merchants`, `Transactions`) into the `Bronze` layer.

2. **Bronze Layer & Data Quality Checks (`nulls,duplicates&Bronze.sql`)**
   - Performs initial data profiling, null checks, and duplicate detection across raw tables.

3. **Silver Layer (`Silver Layer.sql`)**
   - Cleans, standardizes, and transforms raw data into structured, validated tables ready for analytical modeling.

4. **Gold Layer — Star Schema (`Gold Layer.sql`)**
   - Builds the dimensional model (`FactTransactions`, `DimCustomers`, `DimMerchants`, `DimDate`) optimized for BI reporting.

5. **Power BI Dashboard (`Sprint 3 dashboard.pbix`)**
   - **Executive Overview:** Tracks Total Sales ($3.18M), Net Sales ($3.03M), Total Discounts ($158.09K), Avg Transaction Value ($63.69), monthly sales trends, category performance, and payment method splits.
   - **Customers & Merchants:** Analyzes Active Customers (1K), Active Merchants (400), Avg Spend Per Customer ($3.18K), Discount Rate (4.96%), regional sales distribution, loyalty tiers, and top merchants.
   - **Fraud & Risk:** Monitors Fraud Transactions (310), Fraud Rate (0.62%), Avg Fraud Value ($257.19), fraud rates by category, monthly fraud trends, and high-risk merchant transactions.

---

## 🛠️ Tools & Technologies
- **SQL Server (T-SQL):** Data Warehousing, ETL transformations, Medallion Architecture, Star Schema modeling.
- **Power BI:** Data modeling, DAX measures, and Bento-grid dark-mode dashboard design.
