/*
Project: Facebook Page Insights SQL Analysis
Author: Anna Piterskaya

Description:
Business-oriented SQL analysis of Facebook audience,
engagement, demographics, and growth metrics using SQLite.

Skills:
- CTEs
- Window Functions
- Aggregations
- Joins
- Date/Time Analysis
- KPI Calculations
*/

/*
=====================================================
SECTION 1 — BASIC SUMMARY STATISTICS
=====================================================
*/

-- =====================================================
-- Question 1: Unique Countries
-- =====================================================
-- Business question:
-- How many unique countries are there?

-- =====================================================
-- Question 2: Unique Cities
-- =====================================================
-- Business question:
-- How many unique cities are there?

-- =====================================================
-- Question 3: Unique Languages
-- =====================================================
-- Business question:
-- How many unique languages are there?

-- =====================================================
-- Question 4: Global Page Reach
-- =====================================================
-- Business question:
-- What is the daily average reach of the posts on the global page over the period?

-- =====================================================
-- Question 5: Global Page Likes
-- =====================================================
-- Business question:
-- What is the daily average engagement rate on the global page over the period?

/*
=====================================================
SECTION 2 — LOCATION ANALYSIS
=====================================================
*/

-- =====================================================
-- Question 6: Top 10 countries by Number of Fans
-- =====================================================
-- Business question:
-- What are the top 10 countries (considering the number of fans)?

-- =====================================================
-- Question 7: Top 10 countries by Penetration Ratio
-- =====================================================
-- Business question:
-- What are the top 10 countries by penetration ratio (i.e. the % of the country population that are fans)?

-- =====================================================
-- Question 8: Bottom 10 Cities by Number of Fans
-- =====================================================
-- Business question:
-- What are the bottom 10 cities (considering the number of fans) among countries with a population over 20 million?

/*
=====================================================
SECTION 3 — FAN ANALYSIS
=====================================================
*/

-- =====================================================
-- Question 9: Analysis by age group (split of fans)
-- =====================================================
-- Business question:
-- What is the split of page fans across age groups (in %)?

-- =====================================================
-- Question 10: Analysis by gender (split of fans)
-- =====================================================
-- Business question:
-- What is the split of page fans by gender (in %)?

/*
=====================================================
SECTION 4 — AUDIENCE ANALYSIS
=====================================================
*/

-- =====================================================
-- Question 11: English Speaking Fans
-- =====================================================
-- Business question:
-- What is the number of the fans that have declared English as their primary language?

-- =====================================================
-- Question 12: English Speaking Fans Percentage
-- =====================================================
-- Business question:
-- What is the percentage of the fans that have declared English as their primary language?

-- =====================================================
-- Question 13: Buying Power of English Speakers
-- =====================================================
-- Business question:
-- Based on the number of fans who have declared English as their primary language and living in the US, 
-- what is the potential buying power that can be accessed? (Please use the average income data per country for this question. 
-- It is estimated that on average, 0.01% of the annual income is dedicated to online magazine subscriptions in the US).

/*
=====================================================
SECTION 5 — ENGAGEMENT ANALYSIS
=====================================================
*/

-- =====================================================
-- Question 14: Engagement per day of the week
-- =====================================================
-- Business question:
-- What is the split of the EngagedFans across the days of the week?

-- =====================================================
-- Question 15: Engagement per time of day
-- =====================================================
-- Business question:
-- What is the split of the EngagedFans by time of the day?

/*
=====================================================
SECTION 6 — ADVANCED TREND ANALYSIS
=====================================================
*/

-- =====================================================
-- Question 16: Month to month change in engagement
-- =====================================================
-- Business question:
-- Analyze month-over-month changes in PostClicks, EngagedFans, and Reach to identify engagement trends over time.

