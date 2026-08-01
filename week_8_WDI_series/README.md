# Global Urbanization & Population Density: A WDI Capstone (Excel, Python & Power BI)

A data analytics capstone project analyzing global urbanization and population density trends using the World Bank's World Development Indicators (WDI) dataset, built as the Week 8 final project for the AnalystLab Africa Data Analytics Internship (Batch B).

## Project Overview

This project examines how urbanization and population density have evolved globally between 2000 and 2024, using six indicators under the Environment: Density & Urbanization theme. It applies a full data analytics workflow, from raw data to an interactive Power BI dashboard and a written report with insights and recommendations.

## Objective

To understand the pace of global urbanization, the pressure that growing population density places on cities, and how these patterns differ across regions and income groups, in order to support planning and policy decisions by stakeholders such as governments, urban planners, and development bodies.

## Dataset

Source: [World Bank World Development Indicators (WDI)](https://datatopics.worldbank.org/world-development-indicators/)

Files used:
- `WDICSV.csv` — indicator values by country and year
- `WDISeries.csv` — indicator catalog and definitions
- `WDICountry.csv` — country metadata (Region, Income Group)

Indicators analyzed:
| Indicator | Code |
|---|---|
| Population density (people per sq. km) | `EN.POP.DNST` |
| Urban population (% of total) | `SP.URB.TOTL.IN.ZS` |
| Urban population growth (annual %) | `SP.URB.GROW` |
| Rural population (% of total) | `SP.RUR.TOTL.ZS` |
| Population in cities >1M (% of total) | `EN.URB.MCTY.TL.ZS` |
| Slum population (% of urban) | `EN.POP.SLUM.UR.ZS` |

## Tools Used

- **Excel** — browsing WDISeries.csv to identify and select indicators.
- **Python (pandas, Google Colab)** — filtering, cleaning, reshaping, and merging the dataset. Excel could not reliably handle the ~397,000-row source file, so this step was moved to Python.
- **Power BI** — building two interactive dashboards with KPI cards, calculated columns, DAX measures, and visuals.

## Data Cleaning Summary

- Filtered the full WDI dataset down to the six selected indicators.
- Trimmed the year range to 2000–2024 for stronger data completeness.
- Reshaped the data from wide to long format.
- Handled missing values selectively: dropped incomplete rows for indicators with minimal missingness (under ~2%), and retained blanks as-is for indicators with substantial missingness (Cities >1M %, Slum %) rather than dropping or fabricating values.
- Merged in Region and Income Group from WDICountry.csv.
- Separated individual countries from World Bank aggregate rows.
- Validated the dataset for duplicates and formatting inconsistencies.

## Dashboards

**Dashboard 1 — Urbanization Trends**
KPI cards (Avg Urban %, Avg Rural %, Avg Urban Growth Rate), a multi-indicator trend line, a regional comparison chart, a before/after period comparison, and an Urban Majority map/donut chart.

**Dashboard 2 — Density and Livability**
KPI cards (Avg Population Density, Avg Cities Over 1M %), a regional density comparison chart, a data coverage donut chart, a data coverage gauge chart, and a Slum % by Income Group comparison.

## Key Findings

- 59.43% of the global population lives in urban areas, versus 40.57% rural.
- 154 of 217 countries (71%) have crossed the 50% urban-majority threshold as of 2024.
- Urban population growth has slowed, from 2.13% annually (2000–2012) to 1.73% annually (2013–2024).
- Urbanization is highly uneven by region, ranging from 87.0% in North America to 34.3% in South Asia.
- Slum population % falls sharply as income rises, from 65.94% in Low income countries to 3.97% in High income countries.
- Data coverage is a real limitation: only 82% of possible country-year data points across all six indicators are populated.

Full findings, insights, and recommendations are in the final report.

