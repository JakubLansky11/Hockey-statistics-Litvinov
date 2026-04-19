# Hockey Statistics – HC Verva Litvínov

This project focuses on the analysis of match data for **HC Verva Litvínov** in the Czech hockey league.

The project combines multiple tools used in a realistic data workflow:
- **Excel + Power Query** for downloading and preparing source data
- **Python** for data cleaning, transformation, analysis, and visualisation
- **PostgreSQL** for testing SQL queries on prepared datasets
- **Excel Pivot Table / Pivot Chart** for additional reporting output
- **Power BI** analytical dashboard

The goal of the project was not only to analyze Litvínov’s performance across seasons, but also to prepare structured datasets for further SQL work and possible dashboard development.

---

## Project pipeline

**Excel + Power Query → Python analysis → SQL-ready datasets → PostgreSQL → Power BI dashboard**

---

## Project overview

This project is based on match statistics of **HC Verva Litvínov** across multiple seasons of the Czech Extraliga.

My workflow was divided into several steps:

1. **Data collection in Excel**
   - match statistics were downloaded into Excel
   - source tables were cleaned and adjusted using **Power Query**

2. **Python analysis**
   - the cleaned Excel dataset was loaded into Python
   - I performed my own data analysis and created visualisations
   - I also transformed the data into a format suitable for further database work

3. **Preparation of datasets for SQL**
   - in Python, I prepared **two output data files**
   - these files were exported for further work in **PostgreSQL**
   - the files were exported **without column headers** to match my PostgreSQL import workflow

4. **SQL testing in PostgreSQL**
   - I used the prepared datasets in PostgreSQL
   - I tested and practiced SQL queries on data that I had first cleaned and transformed in Python

5. **Additional reporting output**
   - I also created a pivot-based chart in Excel as another way to summarize and present selected results

---

## Main goals of the project

- analyze HC Verva Litvínov match results across seasons
- compare team performance season by season
- visualize standings development and points progression
- analyze results against specific opponents
- identify scoring patterns and top scorers
- prepare structured datasets for SQL analysis in PostgreSQL
- create a foundation for possible future dashboarding in Power BI

---

## Tools used

- **Excel**
- **Power Query**
- **Python**
- **Pandas**
- **Matplotlib**
- **Seaborn**
- **PostgreSQL**
- **Pivot Tables / Pivot Charts**
- **Power BI**

---

## My workflow

### 1. Data collection and preparation
I first downloaded the data into **Excel**, where I used **Power Query** to clean and transform the source tables into a usable format.

### 2. Python analysis
After that, I loaded the prepared dataset into Python and worked on:
- data cleaning and transformations
- exploratory data analysis
- comparisons across seasons
- analysis of opponents
- visualisations of team performance
- scoring analysis

### 3. Data preparation for SQL
Besides the Python analysis itself, I also used Python to prepare **two output data files** for further SQL work.

These exports were designed for use in **PostgreSQL**, where I continued testing SQL queries on the transformed data.

---

## Main questions answered

- How did Litvínov perform across different seasons?
- How did the team’s league position change during a season?
- How many points did the team collect in each season?
- Against which opponents was Litvínov more successful?
- How many power-play goals were scored against individual opponents?
- Which players scored the most goals against selected teams?

---

## Repository contents

- `Hokej_LIT.ipynb`   – main Jupyter Notebook with Python analysis and visualisations
- `Statistiky.xlsx`   – source Excel dataset prepared before Python analysis
- `sql_queries.sql`   – a collection of SQL queries I tested in PostgreSQL on datasets prepared in Python
- `Hockey_LIT.pbix`   – Power BI dashboard - comparison of Litvinov seasons (points, goals, standing)
- `Hockey_LIT.pdf`    – Power BI dashboard presentation
- `pivot_graph_1.pdf` – an Excel pivot chart created from a pivot table
- `README.md` – project description

---

## Example analyses included

### Season analysis
- points comparison across seasons
- development of team standings during a season
- selected team performance metrics

### Opponent analysis
- wins against individual opponents
- comparison of match outcomes
- power-play goal analysis

### Scorer analysis
- transformation of scorer columns into a long-format dataset
- player goal counts against selected opponents
- top scorers by opponent

---

## SQL part of the project

An important part of the project was preparing structured outputs for database work.

In Python, I created **two output datasets** that were later used in **PostgreSQL**.  
The file `sql_queries.sql` contains examples of SQL queries that I tested on these prepared datasets.

This part of the project helped me connect:
- data preparation in Excel / Power Query
- transformation and analysis in Python
- querying structured data in PostgreSQL

---

## Excel reporting output

The file `pivot_graph_1.pdf` contains a chart created in **Excel** from a **pivot table**.

This shows another way of presenting the analyzed data outside Python and demonstrates how the same dataset can be used for additional reporting in spreadsheet tools.

---

## Future improvements

- add more comments and explanations inside the notebook
- more SQL scripts

---

## Author

**Jakub Lansky**

This project is part of my data analytics portfolio focused on:
- Python
- SQL
- Power BI
- Excel

I enjoy working on sports analytics projects, especially hockey-related data.
