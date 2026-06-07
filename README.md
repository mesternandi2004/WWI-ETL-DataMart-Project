# WideWorldImporters Data Warehouse & Business Intelligence Project

Comprehensive end-to-end Data Warehouse (DWH) and Business Intelligence (BI) implementation based on the Microsoft WideWorldImporters OLTP database sample.

---

## Content
1. [Introduction & Use Cases](#1-introduction--use-cases)
2. [Source Data](#2-source-data)
3. [Database Architecture (RAW, STAGE, DWH, Data Mart)](#3-database-architecture)
4. [Dimensional Model (Star Schema)](#4-dimensional-model-star-schema)
5. [ETL Process Overview](#5-etl-process-overview)
6. [Data Visualization](#6-data-visualization)
7. [Scrum Log & Project Management](#7-scrum-log--project-management)

---

## 1. Introduction & Use Cases
The goal of this project is to build a data warehouse to track and analyze the sales activities of a wholesale company from various perspectives. The analysis covers sales trends over time, product and product category performance, customer and customer group purchasing habits, geographical distribution, and salesperson efficiency.

### Key Business Questions (Use Cases)
* How have sales revenues evolved over time (yearly, quarterly, monthly breakdowns)?
* Which product categories and specific products generate the highest revenue and profit?
* Which customer categories and buying groups are the most valuable in terms of revenue?
* How are sales distributed geographically (country, state, city levels)?
* Which salesperson performs the best regarding revenue and transaction count?
* What seasonal patterns can be observed in sales (strongest months/quarters, weekday vs. weekend differences)?
* Which product color and packaging type are the most popular based on quantity sold and revenue?

---

## 2. Source Data
The source is the **WideWorldImporters** database, a Microsoft-provided OLTP sample database containing operational data of an international wholesale company. Data is extracted from the `Sales`, `Purchasing`, `Warehouse`, and `Application` schemas.

### Utilized Source Tables
* `Sales.Invoices` – Invoice header data (Business Key: `InvoiceID`)
* `Sales.InvoiceLines` – Invoice line items (Business Key: `InvoiceLineID`)
* `Sales.Customers` – Customer profiles (`CustomerID`)
* `Sales.CustomerCategories` – Customer categories
* `Sales.BuyingGroups` – Buying groups
* `Application.People` – People / Salespersons (`PersonID`)
* `Warehouse.StockItems` – Products (`StockItemID`)
* `Warehouse.StockGroups` – Product categories
* `Warehouse.StockItemStockGroups` – Product-category bridge table
* `Warehouse.Colors` – Colors
* `Warehouse.PackageTypes` – Packaging types
* `Application.Cities` – Cities
* `Application.StateProvinces` – States / Provinces
* `Application.Countries` – Countries
* `Application.DeliveryMethods` – Delivery methods

---

## 3. Database Architecture

### RAW Layer
Tables from the source database are loaded with an unchanged structure. Every column is set to `NVARCHAR(256)` to ensure the fastest possible data transfer without conversion errors. The tables are truncated (`TRUNCATE TABLE`) before every load, representing a snapshot of the source.

### STAGE (STA) Layer
Data is loaded from the RAW database with the same structure, but every attribute is converted to its formally required data type (e.g., `INT`, `DATE`, `DECIMAL`). Tables are also truncated before each run.

### Data Warehouse (DWH) Layer
Responsible for **SCD (Slowly Changing Dimension)** management. Data accumulates over time rather than being truncated. Technical fields (`ValidFrom`, `ValidTo`, `LoadNumber`) are used to track historical changes. The database structure is transformed into a star schema layout using database **Views**.

### Data Mart (DM) Layer
The final destination optimized for end-user reporting. Dimensions are loaded using `MERGE` statements to maintain the cleanest state, followed by the Fact table loading via SQL `JOIN` operations.

---

## 4. Dimensional Model (Star Schema)

The core of the star schema is the `FactSales` table, connected to 6 dimension tables:

### Fact Table: FactSales
* `FactSalesID` (INT, PK - Surrogate Key)
* `InvoiceLineID`, `InvoiceID` (INT - Business Keys)
* `DimDateKey`, `DimCustomerID`, `DimProductID`, `DimSalespersonID`, `DimDeliveryMethodID`, `DimCityID` (INT - Foreign Keys)
* `Quantity` (INT)
* `UnitPrice`, `TaxAmount`, `LineProfit`, `ExtendedPrice` (DECIMAL)
* `TaxRate` (DECIMAL)

### Dimension Tables
* **DimCustomer**: Manages customer details. Uses SCD1 for buying groups and SCD2 for customer names/addresses.
* **DimProduct**: Product details. Uses SCD1 for prices/tax rates and SCD2 for product features (name, brand, size).
* **DimSalesperson**: Details of sales staff. Filtered where `IsSalesperson = 1`. Uses SCD2.
* **DimDeliveryMethod**: Delivery methods. Uses SCD1.
* **DimCity**: Geographical hierarchy (City -> State/Province -> Country -> Continent). Uses SCD1.
* **DimDate**: Automatically generated time dimension (`DateKey` format: `YYYYMMDD`).

---

## 5. ETL Process Overview

The execution is controlled by a central master package (`00_master`), which chains the modular sub-packages sequentially:
1.  **Get Next LoadNumber**: Generates a unique execution ID for log traceability across all layers.
2.  **Execute RAW Package**: Truncates and populates the RAW layer. Adds `LoadDTS` and `LoadNumber` via *Derived Column* transformation.
3.  **Stage Layer Execute**: Performs type casting, data cleaning, and NULL handling.
4.  **DWH Layer Execute**: Handles historization. Active records are flagged with a `ValidTo = '9999-12-31'` logical end date.
5.  **DM Layer Execute**: Populates the Data Mart. First, dimensions are updated using SQL `MERGE`, then `FactSales` is populated by resolving surrogate keys via SQL `JOIN`s (instead of SSIS Lookup components) based on business keys.

---

## 6. Data Visualization
Reporting was implemented in **Power BI**, based on the finalized Data Mart schema. The dashboard includes:
* **Sales Revenue over Time**: Matrix visualization with rule-based conditional formatting to instantly spot strong/weak periods across years, quarters, and months.
* **Product Performance**: Comparative bar charts and matrices showcasing the Top 10 products and categories by revenue and profit (e.g., *Packaging Materials* and *Clothing* being major drivers).
* **Customer & Buying Group Analysis**: Breakdown of revenue among client types, excluding unknown data (`N/A`) for clearer business insights.
* **Geographical Distribution**: Interactive map charts categorized by sales territories (e.g., *Great Lakes, Mideast, Far West*) with dynamic slicers.
* **Salesperson Efficiency**: Scatter plots correlating total revenue against transaction numbers, highlighting top performers (e.g., *Archer Lamble*).
* **Seasonality**: Visualizing weekday vs. weekend patterns (showing that ~91.24% of orders occur on weekdays) and tracking seasonal monthly peaks.

---

## 7. Scrum Log & Project Management

The team followed an agile **Scrum-based methodology** tailored to the project's naturally sequential workflow.

* **Sprints & Coordination:** Tasks were broken down from initial use case definitions and data modeling, through ETL development layers, up to the Power BI dashboard building. Weekly meetings and quick online syncs ensured seamless handovers since each phase heavily relied on the previous one.
* **Roles & Decisions:** Tasks were distributed based on main roles, but critical architectural and business logic decisions were made collectively.
* **Retrospective Insights:**
    * *Positives:* Regular, transparent communication worked effectively. Team members presented their own components, giving everyone a clear view of the global project state. No internal conflicts occurred.
    * *Challenges / Blockers:* The strictly sequential nature of database layers meant that a slight delay in one phase blocked subsequent tasks. Differing personal schedules also required continuous coordination. These were successfully mitigated by proactive tracking and clear communication.
