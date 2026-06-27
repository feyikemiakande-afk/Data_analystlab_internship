--  WEEK 3 SQL PROJECT — CHINOOK DATABASE
--  AnalystLab Africa Data Analytics Internship | Batch B
--  Author : [Akande Oluwafeyikemi]
--  Date   : June 2025
--  Tool   : MySQL
-- ============================================================

--  SECTION 1: DATABASE SETUP & EXPLORATION
-- Using the Database already created
USE chinook;

-- Show all tables in the database
SHOW TABLES;

-- Exploring datasets and column types
DESCRIBE customer;
DESCRIBE album;
DESCRIBE artist;
DESCRIBE employee;
DESCRIBE genre;
DESCRIBE invoice;
DESCRIBE invoiceline;
DESCRIBE mediatype;
DESCRIBE playlist;
DESCRIBE playlisttrack;
DESCRIBE track;

-- The Chinook database represents a digital music store.
-- Customers make purchases recorded in the Invoice table.
-- Individual purchased tracks are stored in the InvoiceLine table.
-- Each track belongs to an album, genre, and media type.
-- Albums are associated with artists.
-- Customers are assigned support representatives from the Employee table.

-- Preview of all the tables
SELECT * FROM customer LIMIT 10;
SELECT * FROM album LIMIT 10;
SELECT * FROM artist LIMIT 10;
SELECT * FROM employee LIMIT 10;
SELECT * FROM genre LIMIT 10;
SELECT * FROM invoice LIMIT 10;
SELECT * FROM invoiceline LIMIT 10;
SELECT * FROM mediatype LIMIT 10;
SELECT * FROM playlist LIMIT 10;
SELECT * FROM playlisttrack LIMIT 10;
SELECT * FROM track LIMIT 10;

-- TABLE RELATIONSHIPS
-- Employee.EmployeeId   = Customer.SupportRepId
-- Customer.CustomerId   = Invoice.CustomerId
-- Invoice.InvoiceId     = InvoiceLine.InvoiceId
-- InvoiceLine.TrackId   = Track.TrackId
-- Track.AlbumId         = Album.AlbumId
-- Album.ArtistId        = Artist.ArtistId
-- Track.GenreId         = Genre.GenreId
-- Track.MediaTypeId     = MediaType.MediaTypeId
-- Playlist.PlaylistId   = PlaylistTrack.PlaylistId
-- Track.TrackId         = PlaylistTrack.TrackId

--  SECTION 2: CORE QUERIES — SELECT, WHERE, ORDER BY, GROUP BY, HAVING

-- Displaying Customer Information
SELECT
    FirstName,
    LastName,
    Country,
    CustomerId,
    SupportRepId
FROM customer;

-- Displaying album information and associated artist IDs.
SELECT
    AlbumID,
    Title,
    ArtistID
FROM album;

-- Displaying artist ID and name
SELECT
    ArtistID,
    Name
FROM artist;

-- Displayng employees with name and titles
SELECT
    EmployeeID,
    LastName,
    FirstName,
    Title
FROM employee;

-- Genre's available in the store
SELECT
    GenreID,
    Name
FROM genre;

-- Customer Invoice totals
SELECT
    CustomerID,
    InvoiceID,
    Total
FROM invoice;

-- Track details with album, genre, and composer
SELECT
    TrackId,
    Name,
    AlbumId,
    GenreId,
    Composer
FROM track;

-- Customers Supported by Support Rep ID 4
SELECT
    CustomerId,
    FirstName,
    LastName,
    SupportRepId
FROM customer
WHERE SupportRepId = 4
ORDER BY CustomerId;

--  Support Rep 4 identity
SELECT
    EmployeeId,
    FirstName,
    LastName,
    Title
FROM employee
WHERE EmployeeId = 4;

-- Display details of Invoice 3
SELECT
    InvoiceId,
    CustomerId,
    InvoiceDate,
    Total
FROM invoice
WHERE InvoiceId = 3;

-- Displaying  Details of Invloce 3 including Track Id and UnitPrice, and InvloiceLineId
SELECT
    InvoiceLineId,
    InvoiceId,
    TrackId,
    UnitPrice,
    Quantity
FROM invoiceline
WHERE InvoiceLineId = 7
   OR InvoiceLineId = 8
   OR InvoiceLineId = 9
   OR InvoiceLineId = 10;
   
   -- Tracks purchased on Invoice 3
   SELECT 
   TrackId,
   Name,
   AlbumId,
   GenreId,
   UnitPrice
   FROM track
   WHERE TrackId = 16
   OR TrackId = 20
   OR TrackId = 24
   OR TrackId = 28;
   
   -- Invloice Line of Tracks purchased on Invoice 3
   SELECT
    InvoiceLineId,
    InvoiceId,
    TrackId,
    UnitPrice,
    Quantity,
    ROUND(UnitPrice * Quantity, 2) AS line_total
FROM invoiceline
WHERE InvoiceLineId IN (7, 8, 9, 10);

-- Invoices over $10, most expensive first
SELECT InvoiceId, 
CustomerId, 
InvoiceDate, 
Total
FROM invoice
WHERE Total > 10
ORDER BY Total DESC;

SELECT TrackId, 
Name, 
UnitPrice
FROM track
WHERE UnitPrice < 1.00
ORDER BY UnitPrice;

-- AGGREGATIONS — SUM, COUNT, AVG, GROUP BY, HAVING

    -- How many customers per country
    SELECT Country, 
    COUNT(CustomerId) AS total_customers
	FROM customer
	GROUP BY Country
    ORDER BY total_customers DESC;
    
    -- Total Revenue Per Country
    SELECT BillingCountry,
    SUM(Total) AS total_revenue
    FROM invoice
    GROUP BY BillingCountry
    ORDER BY total_revenue DESC;
    
    -- Average Invoice Per Country
    SELECT BillingCountry,
    AVG(Total) AS avg_invoice
    FROM invoice
    GROUP BY BillingCountry
    ORDER BY avg_invoice DESC;
    
    -- How many tracks per genre
    SELECT GenreID,
    COUNT(TrackId) AS total_tracks
    FROM track
    GROUP BY GenreID
    ORDER BY total_tracks DESC;
    
    -- Countries with more than 5 customers
    SELECT Country,
    COUNT(CustomerId) AS total_customers
    FROM customer
    GROUP BY Country
    HAVING COUNT(CustomerId) > 5
    ORDER BY total_customers DESC;
    
-- ============================================================
-- SECTION 3: Advanced SQL Concepts
-- ============================================================
    
    -- INNER JOIN: Customers who have made a purchase
SELECT 
c.CustomerId,
c.FirstName, 
c.LastName, 
i.InvoiceId, 
i.Total
FROM customer c
INNER JOIN invoice i ON i.CustomerId = c.CustomerId
ORDER BY i.Total DESC;

-- LEFT JOIN: -- Customers who have never made a purchase
SELECT 
c.CustomerId,
c.FirstName, 
c.LastName
FROM customer c
LEFT JOIN invoice i ON i.CustomerId = c.CustomerId
WHERE i.InvoiceID is NULL;

-- RIGHT JOIN: Returning all customers including those with and without an invoice
SELECT 
c.CustomerId,
c.FirstName, 
c.LastName, 
i.InvoiceId, 
i.Total
FROM customer c
RIGHT JOIN invoice i ON i.CustomerId = c.CustomerId
ORDER BY i.Total DESC;

-- SUBQUERIES

-- Customers who have made at least one purchase
SELECT
    InvoiceId,
    CustomerId,
    InvoiceDate,
    Total,
    ROW_NUMBER() OVER (ORDER BY InvoiceDate) AS row_num
FROM invoice;

-- Customers who spent above the average
SELECT
    FirstName,
    LastName
FROM customer
WHERE CustomerId IN (
    SELECT CustomerId
    FROM invoice
    GROUP BY CustomerId
    HAVING SUM(Total) > (SELECT AVG(Total) FROM invoice)
);

-- Tracks that have never been purchased
SELECT
    TrackId,
    Name
FROM track
WHERE TrackId NOT IN (
    SELECT TrackId FROM invoiceline
);

-- Ranking all invloices within each Country
SELECT
    BillingCountry,
    InvoiceId,
    Total,
    RANK() OVER (
        PARTITION BY BillingCountry
        ORDER BY Total DESC
    ) AS rank_in_country
FROM invoice;

-- Ranking all invoices by total amount
SELECT
    InvoiceId,
    CustomerId,
    Total,
    RANK() OVER (ORDER BY Total DESC) AS ranked
FROM invoice;


-- SECTION 4: Business Problem Solving

    -- Top 5 customers by total amount spent
  SELECT
    c.FirstName,
    c.LastName,
    SUM(i.Total) AS total_spent
FROM customer c
JOIN invoice i ON i.CustomerId = c.CustomerId
GROUP BY c.FirstName, c.LastName
ORDER BY total_spent DESC
LIMIT 5;

-- 	Top 5 products
SELECT
    t.Name,
    COUNT(il.TrackId) AS times_purchased
FROM invoiceline il
JOIN track t ON t.TrackId = il.TrackId
GROUP BY t.Name
ORDER BY times_purchased DESC
LIMIT 5;

-- Top 5 artists
SELECT
    ar.Name,
    SUM(il.UnitPrice) AS revenue
FROM invoiceline il
JOIN track  t  ON t.TrackId   = il.TrackId
JOIN album  al ON al.AlbumId  = t.AlbumId
JOIN artist ar ON ar.ArtistId = al.ArtistId
GROUP BY ar.Name
ORDER BY revenue DESC
LIMIT 5;

-- Revenue trends over time
SELECT
    YEAR(InvoiceDate)AS year,
    SUM(Total)AS revenue
FROM invoice
GROUP BY YEAR(InvoiceDate)
ORDER BY revenue DESC;

-- Customer purchasing behaviour
SELECT
    c.FirstName,
    c.LastName,
    SUM(i.Total) AS total_spent
FROM customer c
JOIN invoice i ON i.CustomerId = c.CustomerId
GROUP BY c.FirstName, c.LastName
ORDER BY total_spent DESC;

--  SECTION 5: QUERY OPTIMIZATION
-- INDEX 1: Country

-- STEP 1: Checking running plan BEFORE index (expect type = ALL)
EXPLAIN
SELECT FirstName, LastName
FROM customer
WHERE Country = 'USA';

-- STEP 2: Create index on Country column
CREATE INDEX idx_country ON customer(Country);

 -- STEP 3: Check execution plan AFTER index (expect type = ref — faster)
EXPLAIN
SELECT FirstName, LastName
FROM customer
WHERE Country = 'USA';
 
-- Creating Indexes on All Tables
-- All tables expected to be the same as country
CREATE INDEX idx_date ON invoice(InvoiceDate);
CREATE INDEX idx_rep ON customer(SupportRepId);
CREATE INDEX idx_customer ON invoice(CustomerId);
CREATE INDEX idx_track ON invoiceline(TrackId);
CREATE INDEX idx_billingcountry ON invoice(BillingCountry);
CREATE INDEX idx_genreid ON track(GenreId);
CREATE INDEX idx_albumid ON track(AlbumId);

