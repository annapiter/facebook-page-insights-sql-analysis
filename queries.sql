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

SELECT COUNT(DISTINCT CountryName) 
FROM PopStats;

-- =====================================================
-- Question 2: Unique Cities
-- =====================================================
-- Business question:
-- How many unique cities are there?

SELECT COUNT(DISTINCT City) 
FROM FansPerCity; 

-- =====================================================
-- Question 3: Unique Languages
-- =====================================================
-- Business question:
-- How many unique languages are there?

SELECT COUNT(DISTINCT Language) 
FROM FansPerLanguage;

-- =====================================================
-- Question 4: Global Page Reach
-- =====================================================
-- Business question:
-- What is the daily average reach of the posts on the global page over the period?

SELECT 
  ROUND(AVG(daily_reach), 2) AS daily_average_reach 
FROM 
  (SELECT SUM(DailyPostReach) AS daily_reach
  FROM GlobalPage
  GROUP BY Date);

-- =====================================================
-- Question 5: Global Page Likes
-- =====================================================
-- Business question:
-- What is the daily average number of new likes on the global page over the period?

SELECT 
  ROUND(AVG(daily_new_likes), 2) AS daily_average_engagement_rate 
FROM 
  (SELECT SUM(NewLikes) AS daily_new_likes
  FROM GlobalPage
  GROUP BY Date);

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

SELECT 
  ps.CountryCode, ps.CountryName, fpc.NumberOfFans
FROM FansPerCountry fpc
JOIN PopStats ps ON ps.CountryCode = fpc.CountryCode
WHERE fpc.Date = (SELECT max(Date) FROM FansPerCountry)
ORDER BY NumberOfFans DESC
LIMIT 10;

-- =====================================================
-- Question 7: Top 10 countries by Penetration Ratio
-- =====================================================
-- Business question:
-- What are the top 10 countries by penetration ratio (i.e. the % of the country population that are fans)?

SELECT 
  ps.CountryName, 
  ROUND(100.0 * fpc.NumberOfFans / ps.Population, 2) AS PenetrationRatio,
  fpc.NumberOfFans,
  ps.Population
FROM FansPerCountry fpc
JOIN PopStats ps ON ps.CountryCode = fpc.CountryCode
WHERE fpc.Date = (SELECT max(Date) FROM FansPerCountry)
ORDER BY PenetrationRatio DESC
LIMIT 10;

-- =====================================================
-- Question 8: Bottom 10 Cities by Number of Fans
-- =====================================================
-- Business question:
-- What are the bottom 10 cities (considering the number of fans) among countries with a population over 20 million?

SELECT 
  ps.CountryName, 
  fpc.City,
  fpc.NumberOfFans,
  ps.Population
FROM FansPerCity fpc
JOIN PopStats ps ON ps.CountryCode = fpc.CountryCode
WHERE 
  fpc.Date = (SELECT max(Date) FROM FansPerCity)
  AND ps.Population > 20000000
ORDER BY fpc.NumberOfFans ASC
LIMIT 10;

/*
=====================================================
SECTION 3 — GEOGRAPHIC FAN ANALYSIS
=====================================================
*/
-- =====================================================
-- Question 9: Analysis by age group (split of fans)
-- =====================================================
-- Business question:
-- What is the split of page fans across age groups (in %)?

WITH total_fans AS (
  SELECT
    SUM(NumberOfFans)AS TotalFans
  FROM FansPerGenderAge
  WHERE Date = (SELECT MAX(Date) FROM FansPerGenderAge)
)
SELECT 
  fpga.AgeGroup,
  ROUND(100.0 * SUM(fpga.NumberOfFans) / tf.TotalFans, 2) AS PercentageOfFans 
FROM FansPerGenderAge fpga
CROSS JOIN total_fans tf
WHERE fpga.Date = (SELECT MAX(Date) FROM FansPerGenderAge)
GROUP BY AgeGroup;

-- =====================================================
-- Question 10: Analysis by gender (split of fans)
-- =====================================================
-- Business question:
-- What is the split of page fans by gender (in %)?

WITH total_fans AS (
  SELECT
    SUM(NumberOfFans) AS TotalFans
  FROM FansPerGenderAge
  WHERE Date = (SELECT MAX(Date) FROM FansPerGenderAge)
)
SELECT 
  fpga.Gender,
  ROUND(100.0 * SUM(fpga.NumberOfFans) / tf.TotalFans, 2) AS PercentageOfFans 
FROM FansPerGenderAge fpga
CROSS JOIN total_fans tf
WHERE fpga.Date = (SELECT MAX(Date) FROM FansPerGenderAge)
GROUP BY fpga.Gender

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

SELECT
  Language, 
  SUM(NumberOfFans) AS TotalFans
FROM FansPerLanguage
WHERE 
  Date = (SELECT MAX(Date) FROM FansPerLanguage)
AND Language = 'en';

-- =====================================================
-- Question 12: English Speaking Fans Percentage
-- =====================================================
-- Business question:
-- What is the percentage of the fans that have declared English as their primary language?

WITH total_fans AS (
  SELECT 
    SUM(NumberOfFans) AS TotalFans
  FROM FansPerLanguage
  WHERE 
    Date = (SELECT MAX(Date) FROM FansPerLanguage)
)
SELECT
  ROUND(100.0 * SUM(fpl.NumberOfFans) / tf.TotalFans, 2) AS english_speaking_fans_percentage
FROM FansPerLanguage fpl
CROSS JOIN total_fans tf
WHERE 
  fpl.Date = (SELECT MAX(Date) FROM FansPerLanguage)
AND fpl.Language = 'en';

-- =====================================================
-- Question 13: Buying Power of English Speakers
-- =====================================================
-- Business question:
-- Estimate the potential subscription buying power of English-speaking fans in the United States.

WITH eng_fans AS (
  SELECT 
    SUM(fpl.NumberOfFans) as TotalEnglishFans
  FROM FansPerLanguage fpl
  JOIN PopStats ps ON ps.CountryCode = fpl.CountryCode
  WHERE 
    fpl.Date = (Select MAX(Date) from FansPerLanguage)
    AND fpl.Language = 'en'
    AND ps.CountryName = 'United states'
),
avg_income_per_country AS (
  SELECT
    AverageIncome 
  FROM PopStats
  WHERE CountryName = 'United states'
)
SELECT 
ROUND(f.TotalEnglishFans * ai.AverageIncome * 0.0001, 2) AS buying_power
FROM eng_fans f
CROSS JOIN avg_income_per_country ai;

/*
=====================================================
SECTION 5 — ENGAGEMENT ANALYSIS
=====================================================
*/
-- =====================================================
-- Question 14: Engagement per day of the week
-- =====================================================
-- Business question:
-- How are engaged fans distributed across days of the week?

WITH total_engaged AS (
  SELECT SUM(EngagedFans) as total_engaged_fans 
  FROM PostInsights
)
SELECT
  CASE strftime('%w', p.CreatedTime)
    WHEN '0' THEN 'Sunday'
    WHEN '1' THEN 'Monday'
    WHEN '2' THEN 'Tuesday'
    WHEN '3' THEN 'Wednesday' 
    WHEN '4' THEN 'Thursday'
    WHEN '5' THEN 'Friday'
    WHEN '6' THEN 'Saturday'
  END AS DayOfWeek,
  ROUND(100.0 * SUM(p.EngagedFans)/t.total_engaged_fans, 2) AS PercentageSplit
FROM PostInsights p
CROSS JOIN total_engaged t
GROUP BY DayOfWeek
ORDER BY PercentageSplit DESC;

-- =====================================================
-- Question 15: Engagement per time of day
-- =====================================================
-- Business question:
-- How are engaged fans distributed across time ranges during the day?

WITH total_engaged AS (
SELECT 
  SUM(EngagedFans) as total_engaged_fans FROM PostInsights
)
SELECT
  CASE
    WHEN CAST(strftime('%H',CreatedTime) AS INTEGER) BETWEEN 5 AND 8 THEN '05:00 - 08:59'
    WHEN CAST(strftime('%H',CreatedTime) AS INTEGER) BETWEEN 9 and 11 THEN '09:00 - 11:59'
    WHEN CAST(strftime('%H',CreatedTime) AS INTEGER) BETWEEN 12 AND 14 THEN '12:00 - 14:59'
    WHEN CAST(strftime('%H',CreatedTime) AS INTEGER) BETWEEN 15 AND 18 THEN '15:00 - 18:59'
    WHEN CAST(strftime('%H',CreatedTime) AS INTEGER) BETWEEN 19 AND 21 THEN '19:00 - 21:59'
  ELSE '22:00 or later'
  END AS TimeRange,
  ROUND(100.0 * SUM(p.EngagedFans)/t.total_engaged_fans, 2) AS PercentageSplit
FROM PostInsights p
CROSS JOIN total_engaged t
GROUP BY TimeRange
ORDER BY PercentageSplit DESC;

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

WITH 
current_month AS (
  SELECT 
    strftime('%m', CreatedTime) AS month,
    SUM(PostClicks) AS PostClicks,
    SUM(EngagedFans) AS EngagedFans,
    SUM(Reach) AS Reach
  FROM PostInsights
  GROUP BY month
),
lag_month AS (
  SELECT 
    lag(month) OVER(ORDER BY month) AS FromMonth,
    month as ToMonth,
    PostClicks, 
    lag(PostClicks) over(ORDER BY month) AS PostClicks_lag,
    EngagedFans, 
    lag(EngagedFans) OVER (ORDER BY month) AS EngagedFans_lag,
    Reach, 
    lag(Reach) OVER (ORDER BY month) AS Reach_lag
  FROM current_month
)
SELECT
  FromMonth, ToMonth, 
  ROUND(100.0 * (PostClicks - PostClicks_lag)/PostClicks_lag, 2) AS DeltaPostClicks,
  ROUND(100.0 *(EngagedFans - EngagedFans_lag)/EngagedFans_lag, 2) AS DeltaEngagedFans,
  ROUND(100.0 * (Reach - Reach_lag)/Reach_lag, 2) AS DeltaReach
FROM lag_month
WHERE FromMonth IS NOT NULL;
