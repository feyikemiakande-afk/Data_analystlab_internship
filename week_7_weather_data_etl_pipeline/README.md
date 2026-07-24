# Weather ETL Pipeline — AnalystLab Africa Week 7

## Project Overview
This project builds a simple ETL (Extract, Transform, Load) pipeline that
collects real-time weather data for three cities, **Lagos, Abuja, and
London**, using the OpenWeather API. The raw data is cleaned and
structured with Pandas, saved to a CSV file, and then explored through a
short analysis comparing temperature, humidity, wind speed, and how these
variables relate to one another.

This was built as the Week 7 project for the AnalystLab Africa Data
Analytics Internship (Batch B), covering data pipelines and automation.


## Data Source
- **OpenWeather API** — [openweathermap.org/api](https://openweathermap.org/api)
- Specifically, the **Current Weather Data** endpoint
  (`/data/2.5/weather`), which returns live weather conditions for a
  given city.

## Tools Used
- **Python**
- **Pandas** — data cleaning and transformation
- **Requests** — calling the OpenWeather API
- **JSON** — parsing and saving raw API responses
- **Datetime** — handling and converting timestamps
- **Matplotlib & Seaborn** — charts and visualizations
-  **OS** — environment and file path handling

-  ## ETL Process

**1. Extract**
Weather data for Lagos, Abuja, and London is pulled from the OpenWeather
API using the `requests` library. Each response is tagged with a
retrieval timestamp and saved as raw JSON.

**2. Transform**
The raw JSON is flattened into a structured Pandas DataFrame, with one
row per city. Column names are changed to uppercase for consistency,
and the `DT ISO` column is renamed to `WEATHER OBSERVATION TIME` for
clarity. Date/time fields are then converted from raw formats (Unix
timestamps and ISO strings) into proper datetime types.

**3. Load**
The cleaned dataset is saved as a **CSV file** (`weather_api_csv.csv`)
using `df.to_csv()`.

**4. Analysis**
The cleaned dataset is explored through:
- Bar charts comparing temperature and humidity across cities
- A line chart comparing wind speed
- A pie chart showing temperature distribution
- A correlation heatmap between temperature, humidity, and wind speed
- A summary table and written findings

## Steps Taken
1. Created an OpenWeather account and generated an API key.
2. Wrote a Python script/notebook to call the API for three cities.
3. Saved the raw API responses to a JSON file.
4. Loaded the raw JSON into a Pandas DataFrame and flattened the nested
   fields into simple columns (city name, temperature, humidity,
   weather description, wind speed, timestamps).
5. Renamed columns and converted date/time fields to proper datetime
   types.
6. Saved the cleaned dataset to a CSV file.
7. Reloaded the CSV to confirm it saved correctly.
8. Built visualizations and a correlation analysis to compare weather
   patterns across the three cities.

   ## Key Findings

- **Lagos** was the warmest city recorded, with high humidity and
  light rain conditions.
- **Abuja** sat in the middle for both temperature and humidity, under
  overcast skies.
- **London** was the coolest city, with the lowest humidity and the
  lowest wind speed.
- Across this dataset, temperature, humidity, and wind speed all showed
  strong positive correlations with one another, as one increased,
  the others tended to increase too.
