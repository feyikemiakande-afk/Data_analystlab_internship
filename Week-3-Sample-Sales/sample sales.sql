--  WEEK 3 SQL PROJECT — SAMPLE SALES DATA
--  AnalystLab Africa Data Analytics Internship | Batch B
--  Author : Akande Oluwafeyikemi
--  Date   : June 2025
--  Tool   : MySQL
-- ============================================================

--  SECTION 1: DATABASE SETUP & EXPLORATION

-- Creating the database
CREATE DATABASE sample_sales;

-- Loading the dataset
USE sample_sales;

-- Displaying tables
SHOW TABLES;

-- Identifying columns name and data type
DESCRIBE sample_sales_data;

-- Displaying the first few rows
SELECT* FROM sample_sales_data LIMIT 10;

--  SECTION 2: DATA CLEANING AND CORE SQL QUERIES

-- Identify missing values across all columns
SELECT
    SUM(ORDERNUMBER IS NULL) AS missing_ordernumber,
    SUM(QUANTITYORDERED IS NULL) AS missing_quantityordered,
    SUM(PRICEEACH IS NULL) AS missing_priceeach,
    SUM(ORDERLINENUMBER IS NULL) AS missing_orderlinenumber,
    SUM(SALES IS NULL) AS missing_sales,
    SUM(ORDERDATE IS NULL OR ORDERDATE = '') AS missing_orderdate,
    SUM(STATUS IS NULL OR STATUS = '') AS missing_status,
    SUM(QTR_ID IS NULL) AS missing_qtr_id,
    SUM(MONTH_ID IS NULL) AS missing_month_id,
    SUM(YEAR_ID IS NULL) AS missing_year_id,
    SUM(PRODUCTLINE IS NULL OR PRODUCTLINE = '') AS missing_productline,
    SUM(MSRP IS NULL) AS missing_msrp,
    SUM(PRODUCTCODE IS NULL OR PRODUCTCODE = '') AS missing_productcode,
    SUM(CUSTOMERNAME IS NULL OR CUSTOMERNAME = '') AS missing_customername,
    SUM(PHONE IS NULL OR PHONE = '') AS missing_phone,
    SUM(ADDRESSLINE1 IS NULL OR ADDRESSLINE1 = '') AS missing_addressline1,
    SUM(ADDRESSLINE2 IS NULL OR ADDRESSLINE2 = '') AS missing_addressline2,
    SUM(CITY IS NULL OR CITY = '') AS missing_city,
    SUM(STATE IS NULL OR STATE = '') AS missing_state,
    SUM(POSTALCODE IS NULL OR POSTALCODE = '') AS missing_postalcode,
    SUM(COUNTRY IS NULL OR COUNTRY = '') AS missing_country,
    SUM(TERRITORY IS NULL OR TERRITORY = '') AS missing_territory,
    SUM(CONTACTLASTNAME IS NULL OR CONTACTLASTNAME = '') AS missing_contactlastname,
    SUM(CONTACTFIRSTNAME IS NULL OR CONTACTFIRSTNAME = '') AS missing_contactfirstname,
    SUM(DEALSIZE IS NULL OR DEALSIZE = '') AS missing_dealsize
FROM sample_sales_data;

-- filling missing values with unkown
UPDATE sample_sales_data
SET
    ADDRESSLINE2 = CASE
        WHEN ADDRESSLINE2 IS NULL OR ADDRESSLINE2 = '' THEN 'Unknown'
        ELSE ADDRESSLINE2
    END,
    STATE = CASE
        WHEN STATE IS NULL OR STATE = '' THEN 'Unknown'
        ELSE STATE
    END,
    POSTALCODE = CASE
        WHEN POSTALCODE IS NULL OR POSTALCODE = '' THEN 'Unknown'
        ELSE POSTALCODE
    END;
    
    -- checking for duplicates rows
  SELECT*,
    COUNT(*) AS duplicate_count
FROM sample_sales_data
GROUP BY
    ORDERNUMBER,
    QUANTITYORDERED,
    PRICEEACH,
    ORDERLINENUMBER,
    SALES,
    ORDERDATE,
    STATUS,
    QTR_ID,
    MONTH_ID,
    YEAR_ID,
    PRODUCTLINE,
    MSRP,
    PRODUCTCODE,
    CUSTOMERNAME,
    PHONE,
    ADDRESSLINE1,
    ADDRESSLINE2,
    CITY,
    STATE,
    POSTALCODE,
    COUNTRY,
    TERRITORY,
    CONTACTLASTNAME,
    CONTACTFIRSTNAME,
    DEALSIZE
HAVING COUNT(*) > 1;

-- Standarizing decimal points of Sales Column
UPDATE sample_sales_data
SET SALES = ROUND(SALES, 0);

-- Verifying SALES is standardized to 2 decimal places
SELECT
    CUSTOMERNAME,
    SALES
FROM sample_sales_data
LIMIT 10;

-- Selecting name of customers and item purchased from dataset
SELECT 
CUSTOMERNAME, 
PRODUCTLINE,
 SALES
FROM sample_sales_data
ORDER BY SALES ASC;

-- 2. EXPLORATION
--  Selecting customer name and item purchased
SELECT
    CUSTOMERNAME,
    PRODUCTLINE,
    SALES
FROM sample_sales_data
ORDER BY SALES ASC;

-- Selecting name of customers and items, purchased in America
SELECT
CUSTOMERNAME,
PRODUCTLINE,
SALES,
COUNTRY
FROM sample_sales_data
WHERE COUNTRY = 'USA';

-- Selecting customers with sales greater than 2000
SELECT
CUSTOMERNAME,
PRODUCTLINE,
SALES,
COUNTRY
FROM sample_sales_data
WHERE COUNTRY = 'USA'
AND SALES > 2000;

-- Selecting rows where the customer is from the USA or the sale is greater than 3000:
SELECT
    CUSTOMERNAME,
    PRODUCTLINE,
    SALES,
    COUNTRY
FROM sample_sales_data
WHERE COUNTRY = 'USA'
OR SALES > 3000
ORDER BY SALES DESC;

-- Total amount spent per customer.
SELECT
    CUSTOMERNAME,
    SUM(SALES) AS TotalSales
FROM sample_sales_data
GROUP BY CUSTOMERNAME
ORDER BY TotalSales DESC;

-- Total Sales by Product Line
SELECT
    PRODUCTLINE,
    SUM(SALES) AS TotalSales
FROM sample_sales_data
GROUP BY PRODUCTLINE
ORDER BY TotalSales DESC;

-- Total sales per year
SELECT
    YEAR_ID,
    SUM(SALES) AS TotalSales
FROM sample_sales_data
GROUP BY YEAR_ID
ORDER BY YEAR_ID;

-- Total sales by city
SELECT
    CITY,
    SUM(SALES) AS TotalSales
FROM sample_sales_data
GROUP BY CITY
ORDER BY TotalSales DESC;

-- Customers who spent more than 50,000
SELECT
    CUSTOMERNAME,
    SUM(SALES) AS TotalSpent
FROM sample_sales_data
GROUP BY CUSTOMERNAME
HAVING SUM(SALES) > 50000
ORDER BY TotalSpent DESC;

-- Total revenue across all orders
SELECT
    SUM(SALES) AS TotalRevenue
FROM sample_sales_data;

-- Average sales value
SELECT
    AVG(SALES) AS AverageSale
FROM sample_sales_data;

SELECT
    COUNT(*) AS TotalOrders
FROM sample_sales_data;

 -- SECTION 3: ADVANCED SQL — SUBQUERIES & WINDOW FUNCTIONS
-- Joins not applicable as it is just one table in the dataset

-- Ranking sales from highest to lowest.
SELECT
   CUSTOMERNAME,
    SALES,
    RANK() 
    OVER 
    (ORDER BY SALES DESC) AS SalesRank
FROM sample_sales_data;

-- Ranking sales within each country
SELECT
    COUNTRY,
    CUSTOMERNAME,
    SALES,
    RANK() 
    OVER
    ( PARTITION BY COUNTRY
        ORDER BY SALES DESC
    ) AS CountryRank
FROM sample_sales_data;

--  4. Business Problem Solving

-- 1. Top-Performing Products
SELECT
    PRODUCTLINE,
    SUM(SALES) AS TotalSales
FROM sample_sales_data
GROUP BY PRODUCTLINE
ORDER BY TotalSales DESC
LIMIT 5;

-- Top 5 Performing customer
SELECT
    CUSTOMERNAME,
    SUM(SALES) AS TotalSales
FROM sample_sales_data
GROUP BY CUSTOMERNAME
ORDER BY TotalSales DESC
LIMIT 5;

-- Revenue Trends Over Time (Yearly)
SELECT
    YEAR_ID,
    SUM(SALES) AS TotalRevenue
FROM sample_sales_data
GROUP BY YEAR_ID
ORDER BY YEAR_ID;

-- Customer Purchasing Behaviour
SELECT
    CUSTOMERNAME,
    COUNT(ORDERNUMBER) AS TotalOrders,
    SUM(SALES) AS TotalSpent,
    AVG(SALES) AS AverageOrderValue
FROM sample_sales_dat
GROUP BY CUSTOMERNAME
ORDER BY TotalSpent DESC
LIMIT 5;


--  SECTION 7: Query Optimization

-- Converting TEXT columns to VARCHAR to avoid key length errors
ALTER TABLE sample_sales_data
MODIFY COLUMN COUNTRY VARCHAR(50),
MODIFY COLUMN YEAR_ID VARCHAR(10),
MODIFY COLUMN CUSTOMERNAME VARCHAR(100),
MODIFY COLUMN PRODUCTLINE VARCHAR(50),
MODIFY COLUMN STATUS VARCHAR(20),
MODIFY COLUMN DEALSIZE VARCHAR(20),
MODIFY COLUMN CITY VARCHAR(50),
MODIFY COLUMN STATE VARCHAR(50),
MODIFY COLUMN TERRITORY VARCHAR(50);

--  Checking execution plan BEFORE index 
EXPLAIN
SELECT CUSTOMERNAME, SALES
FROM sample_sales_data
WHERE COUNTRY = 'USA';

-- Creating index on COUNTRY column
CREATE INDEX idx_country ON sample_sales_data(COUNTRY(50));

-- STEP 3: Check execution plan AFTER index (expect type = ref)
EXPLAIN
SELECT CUSTOMERNAME, SALES
FROM sample_sales_data
WHERE COUNTRY = 'USA';

 -- Remaining indexes created for every column used in WHERE, GROUP BY, ORDER BY, or PARTITION BY across all queries.
-- The same optimization principle demonstrated above applies to all.
CREATE INDEX idx_year ON sample_sales_data(YEAR_ID);
CREATE INDEX idx_customername ON sample_sales_data(CUSTOMERNAME);
CREATE INDEX idx_productline ON sample_sales_data(PRODUCTLINE);
CREATE INDEX idx_city ON sample_sales_data(CITY);
CREATE INDEX idx_sales ON sample_sales_data(SALES);
CREATE INDEX idx_ordernumber ON sample_sales_data(ORDERNUMBER);


