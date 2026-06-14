-- Creating the database
CREATE DATABASE netflix_titles;

-- Loading the dataset
USE netflix_titles;

-- Displaying tables
SHOW TABLES;

-- Check how many rows actually made it in
SELECT COUNT(*) AS imported_rows FROM netflix_titles;

-- Displaying the first few rows
SELECT * FROM netflix_titles LIMIT 15;

-- Identifying number of columns name, and data type
DESCRIBE netflix_titles;

-- Identifying the number of rows
SELECT COUNT(*)
FROM netflix_titles;

-- IDENTIFYING CATEGORICAL FEATURES
DESCRIBE netflix_titles;
SELECT COUNT(release_year)
FROM netflix_titles;

-- IDENTIFYING POSSIBLE UNIQUE IDENTIFIERS
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT show_id) AS unique_ids
FROM netflix_titles;

-- DATA CLEANING
-- Identifying columns with missing values and number of missing values per column
SELECT
    SUM(show_id IS NULL OR show_id = '') AS missing_show_id,
    SUM(type IS NULL OR type = '') AS missing_type,
    SUM(title IS NULL OR title = '') AS missing_title,
    SUM(director IS NULL OR director = '') AS missing_director,
    SUM(cast IS NULL OR cast = '') AS missing_cast,
    SUM(country IS NULL OR country = '') AS missing_country,
    SUM(date_added IS NULL OR date_added = '') AS missing_date_added,
    SUM(release_year IS NULL OR release_year = '') AS missing_release_year,
    SUM(rating IS NULL OR rating = '') AS missing_rating,
    SUM(duration IS NULL OR duration = '') AS missing_duration,
    SUM(listed_in IS NULL OR listed_in = '') AS missing_listed_in,
    SUM(description IS NULL OR description = '') AS missing_description
FROM netflix_titles; 

UPDATE netflix_titles
SET
    director = CASE
        WHEN director IS NULL OR director = '' THEN 'Unknown'
        ELSE director
    END,
    cast = CASE
        WHEN cast IS NULL OR cast = '' THEN 'Unknown'
        ELSE cast
    END,
    country = CASE
        WHEN country IS NULL OR country = '' THEN 'Unknown'
        ELSE country
    END;

-- Confirming data has been cleaned
SELECT
    SUM(show_id IS NULL OR show_id = '') AS missing_show_id,
    SUM(type IS NULL OR type = '') AS missing_type,
    SUM(title IS NULL OR title = '') AS missing_title,
    SUM(director IS NULL OR director = '') AS missing_director,
    SUM(cast IS NULL OR cast = '') AS missing_cast,
    SUM(country IS NULL OR country = '') AS missing_country,
    SUM(date_added IS NULL OR date_added = '') AS missing_date_added,
    SUM(release_year IS NULL OR release_year = '') AS missing_release_year,
    SUM(rating IS NULL OR rating = '') AS missing_rating,
    SUM(duration IS NULL OR duration = '') AS missing_duration,
    SUM(listed_in IS NULL OR listed_in = '') AS missing_listed_in,
    SUM(description IS NULL OR description = '') AS missing_description
FROM netflix_titles; 

-- CONFIRMING DUPLICATES NOT FOUND
SELECT
    show_id,
    type,
    title,
    director,
    cast,
    country,
    date_added,
    release_year,
    rating,
    duration,
    listed_in,
    description,
    COUNT(*) AS duplicate_count
FROM netflix_titles
GROUP BY show_id, type, title, director, cast, country, date_added, release_year, rating, duration, listed_in, description
ORDER BY duplicate_count DESC;

-- STANDARDIZATION OF DATE

-- Check how dates currently look
SELECT DISTINCT date_added FROM netflix_titles;

-- Standardize to YYYY-MM-DD format
UPDATE netflix_titles
SET date_added = STR_TO_DATE(date_added, '%M %d, %Y')
WHERE date_added IS NOT NULL AND date_added != '';

-- Then change the column data type
ALTER TABLE netflix_titles
MODIFY COLUMN date_added DATE;

-- The data consistency is accurate so no change needed
ALTER TABLE netflix_titles
MODIFY COLUMN show_id VARCHAR(10),
MODIFY COLUMN type VARCHAR(10),
MODIFY COLUMN title VARCHAR(1000),
MODIFY COLUMN director VARCHAR(100),
MODIFY COLUMN cast VARCHAR(1000),
MODIFY COLUMN country VARCHAR(100),
MODIFY COLUMN date_added DATE,
MODIFY COLUMN rating VARCHAR(10),
MODIFY COLUMN duration VARCHAR(20),
MODIFY COLUMN listed_in VARCHAR(200),
MODIFY COLUMN description VARCHAR(500);

-- COLUMN STANDARDIZATION
ALTER TABLE netflix_titles RENAME COLUMN show_id TO ShowId;
ALTER TABLE netflix_titles RENAME COLUMN type TO Type;
ALTER TABLE netflix_titles RENAME COLUMN title TO Title;
ALTER TABLE netflix_titles RENAME COLUMN director TO Director;
ALTER TABLE netflix_titles RENAME COLUMN cast TO Cast;
ALTER TABLE netflix_titles RENAME COLUMN country TO Country;
ALTER TABLE netflix_titles RENAME COLUMN date_added TO DateAdded;
ALTER TABLE netflix_titles RENAME COLUMN release_year TO ReleaseYear;
ALTER TABLE netflix_titles RENAME COLUMN rating TO Rating;
ALTER TABLE netflix_titles RENAME COLUMN duration TO Duration;
ALTER TABLE netflix_titles RENAME COLUMN listed_in TO ListedIn;
ALTER TABLE netflix_titles RENAME COLUMN description TO Description;

-- Reconfirming column names have changed
DESCRIBE netflix_titles;

-- DATA VALIDATION
SELECT DISTINCT Type FROM netflix_titles GROUP BY Type;
SELECT Director FROM netflix_titles;
SELECT Title FROM netflix_titles;
SELECT Cast FROM netflix_titles;
SELECT Country FROM netflix_titles;
SELECT DateAdded FROM netflix_titles;
SELECT ReleaseYear FROM netflix_titles;
SELECT Rating FROM netflix_titles;
SELECT Duration FROM netflix_titles;
SELECT ListedIn FROM netflix_titles;
SELECT Description FROM netflix_titles;

-- CREATING A SUMMARY TABLE
CREATE TABLE data_cleaning_summary (
    Issue_Found  VARCHAR(50),
    Action_Taken VARCHAR(50),
    Affected_Columns VARCHAR(100),
	Records_Affected INT
);

INSERT INTO data_cleaning_summary (Issue_Found, Action_Taken, Affected_Columns, Records_Affected)
VALUES
    ('Missing Values','Filled with Unknown','Director, CastMembers, Country', 2916),
    ('Duplicates', 'None Found', 'All Columns', 0),
    ('Invalid Entries', 'Corrected', 'DateAdded', 8797),
    ('Standardization', 'Applied', 'All Columns', 0);
    
SELECT * FROM data_cleaning_summary;

-- TASK 3
-- Exploratory Data Analysis (EDA)
SELECT 
    ROUND(AVG(ReleaseYear))  AS mean,
    MAX(ReleaseYear)  AS maximum,
    MIN(ReleaseYear)  AS minimum,
    ROUND(STDDEV(ReleaseYear)) AS std_dev_release_year
FROM netflix_titles;

-- MEDIAN ReleaseYear
WITH ranked AS (
    SELECT 
        ReleaseYear,
        ROW_NUMBER() OVER (ORDER BY ReleaseYear) AS rn,
        COUNT(*) OVER () AS total
    FROM netflix_titles
)
SELECT ROUND(AVG(ReleaseYear)) AS median
FROM ranked
WHERE rn IN (FLOOR((total + 1) / 2), CEIL((total + 1) / 2));

-- Movie duration stats (in minutes)
SELECT 
    ROUND(AVG(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED)))    AS mean,
    MAX(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED))    AS maximum,
    MIN(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED))    AS minimum,
    ROUND(STDDEV(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED))) AS std_deviation
FROM netflix_titles
WHERE Type = 'Movie';

-- TV Show duration stats (in seasons)
SELECT 
    ROUND(AVG(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED)))    AS mean,
    MAX(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED))    AS maximum,
    MIN(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED))    AS minimum,
    ROUND(STDDEV(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED))) AS std_deviation
FROM netflix_titles
WHERE Type = 'TV Show';

-- MEDIAN RELEASE YEAR
SELECT AVG(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED)) AS median_movie_duration
FROM (
    SELECT Duration, 
           ROW_NUMBER() OVER (ORDER BY CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED)) AS row_num,
           COUNT(*) OVER () AS total
    FROM netflix_titles
    WHERE Type = 'Movie'
) AS ranked
WHERE row_num IN (FLOOR((total + 1) / 2), CEIL((total + 1) / 2));

-- Median TV show duration
SELECT AVG(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED)) AS median_tv_duration
FROM (
    SELECT Duration,
           ROW_NUMBER() OVER (ORDER BY CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED)) AS row_num,
           COUNT(*) OVER () AS total
    FROM netflix_titles
    WHERE Type = 'TV Show'
) AS ranked
WHERE row_num IN (FLOOR((total + 1) / 2), CEIL((total + 1) / 2));

-- Create the statistics summary table for minutes and duration
CREATE TABLE statistical_summary (
    Metric        VARCHAR(50),
    Category      VARCHAR(20),
    Mean          DECIMAL(10,2),
    Median        DECIMAL(10,2),
    Maximum       DECIMAL(10,2),
    Minimum       DECIMAL(10,2),
    Std_Deviation DECIMAL(10,2)
);

-- Insert duration (minutes_ stats
INSERT INTO statistical_summary (Metric, Category, Mean, Median, Maximum, Minimum, Std_Deviation)
SELECT 
    'Release Year'          AS Metric,
    'All'                   AS Category,
    ROUND(AVG(ReleaseYear)) AS Mean,
    2019                    AS Median,
    MAX(ReleaseYear)        AS Maximum,
    MIN(ReleaseYear)        AS Minimum,
	ROUND(STDDEV(ReleaseYear))     AS Std_Deviation
FROM netflix_titles;

-- Insert Movie duration stats
INSERT INTO statistical_summary (Metric, Category, Mean, Median, Maximum, Minimum, Std_Deviation)
SELECT
    'Duration'                                                              AS Metric,
    'Movie (mins)'                                                          AS Category,
    ROUND(AVG(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED)))           AS Mean,
    NULL                                                                    AS Median,
    MAX(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED))           AS Maximum,
    MIN(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED))           AS Minimum,
    STDDEV(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED))        AS Std_Deviation
FROM netflix_titles
WHERE Type = 'Movie';

-- Insert TV Show duration stats
INSERT INTO statistical_summary (Metric, Category, Mean, Median, Maximum, Minimum, Std_Deviation)
SELECT
    'Duration'                                                              AS Metric,
    'TV Show (seasons)'                                                     AS Category,
    AVG(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED))           AS Mean,
    NULL                                                                    AS Median,
    MAX(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED))           AS Maximum,
    MIN(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED))           AS Minimum,
    STDDEV(CAST(SUBSTRING_INDEX(Duration, ' ', 1) AS UNSIGNED))        AS Std_Deviation
FROM netflix_titles
WHERE Type = 'TV Show';

-- View the table
SELECT * FROM statistical_summary;


-- MOVIES AND TV SHOWS DISTRUBUTION
SELECT 
    Type,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix_titles), 2) AS percentage
FROM netflix_titles
GROUP BY Type;

-- CONTENTS ADDED PER YEAR
SELECT 
    YEAR(DateAdded) AS year_added,
    COUNT(*) AS total_content
FROM netflix_titles
WHERE DateAdded IS NOT NULL
GROUP BY YEAR(DateAdded)
ORDER BY year_added ASC;

-- TOP PRODUCING COUNTRIES
SELECT 
    Country,
    COUNT(*) AS total_content
FROM netflix_titles
WHERE Country != 'Unknown'
GROUP BY Country
ORDER BY total_content DESC
LIMIT 10;

-- MOST COMMON AGE RATINGS
SELECT 
    Rating,
    COUNT(*) AS total
FROM netflix_titles
WHERE Rating IS NOT NULL
GROUP BY Rating
ORDER BY total DESC;

-- MOST COMMON GENRES
SELECT 
    ListedIn,
    COUNT(*) AS total
FROM netflix_titles
GROUP BY ListedIn
ORDER BY total DESC
LIMIT 10;

-- DAYA VISUALIZATIONS
SELECT * FROM netflix_titles;