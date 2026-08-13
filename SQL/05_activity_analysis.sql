-- Bellabeat Case Study
-- 05_activity_analysis.sql
-- Purpose: Analyze overall activity, weekly patterns, calories, activity intensity,
--          and user activity segments using the cleaned daily activity dataset.
-- Platform: Google BigQuery
-- Project: tethers-400518-495323
-- Dataset: bellabeat_case_study

-- ============================================================
-- 1. Overall activity averages
-- ============================================================

SELECT
  COUNT(DISTINCT Id) AS total_users,
  ROUND(AVG(TotalSteps), 0) AS avg_daily_steps,
  ROUND(AVG(TotalDistance), 2) AS avg_daily_distance,
  ROUND(AVG(VeryActiveMinutes), 0) AS avg_very_active_minutes,
  ROUND(AVG(FairlyActiveMinutes), 0) AS avg_fairly_active_minutes,
  ROUND(AVG(LightlyActiveMinutes), 0) AS avg_lightly_active_minutes,
  ROUND(AVG(SedentaryMinutes), 0) AS avg_sedentary_minutes,
  ROUND(AVG(Calories), 0) AS avg_daily_calories
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_clean`;


-- ============================================================
-- 2. Activity patterns by day of week
-- ============================================================

SELECT
  FORMAT_DATE('%A', ActivityDate) AS day_of_week,
  EXTRACT(DAYOFWEEK FROM ActivityDate) AS day_number,
  COUNT(*) AS observations,
  ROUND(AVG(TotalSteps), 0) AS avg_steps,
  ROUND(AVG(TotalDistance), 2) AS avg_distance,
  ROUND(AVG(VeryActiveMinutes), 0) AS avg_very_active_minutes,
  ROUND(AVG(FairlyActiveMinutes), 0) AS avg_fairly_active_minutes,
  ROUND(AVG(LightlyActiveMinutes), 0) AS avg_lightly_active_minutes,
  ROUND(AVG(SedentaryMinutes), 0) AS avg_sedentary_minutes,
  ROUND(AVG(Calories), 0) AS avg_calories
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_clean`
GROUP BY
  day_of_week,
  day_number
ORDER BY
  day_number;


-- ============================================================
-- 3. Correlation between daily steps and calories burned
-- ============================================================

SELECT
  ROUND(CORR(TotalSteps, Calories), 3) AS steps_calories_correlation
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_clean`
WHERE
  TotalSteps IS NOT NULL
  AND Calories IS NOT NULL;


-- ============================================================
-- 4. Row-level steps and calories for visualization
-- ============================================================

SELECT
  Id,
  ActivityDate,
  TotalSteps,
  Calories
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_clean`
WHERE
  TotalSteps IS NOT NULL
  AND Calories IS NOT NULL
ORDER BY
  TotalSteps;


-- ============================================================
-- 5. Correlations between activity intensity and calories
-- ============================================================

SELECT
  ROUND(CORR(VeryActiveMinutes, Calories), 3) AS very_active_calorie_corr,
  ROUND(CORR(FairlyActiveMinutes, Calories), 3) AS fairly_active_calorie_corr,
  ROUND(CORR(LightlyActiveMinutes, Calories), 3) AS lightly_active_calorie_corr,
  ROUND(CORR(SedentaryMinutes, Calories), 3) AS sedentary_calorie_corr
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_clean`;


-- ============================================================
-- 6. User activity segmentation
--    Segment users according to average daily steps.
-- ============================================================

WITH user_summary AS (
  SELECT
    Id,
    COUNT(DISTINCT ActivityDate) AS days_recorded,
    ROUND(AVG(TotalSteps), 0) AS avg_daily_steps,
    ROUND(AVG(VeryActiveMinutes), 0) AS avg_very_active_minutes,
    ROUND(AVG(SedentaryMinutes), 0) AS avg_sedentary_minutes
  FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_clean`
  GROUP BY Id
)
SELECT
  CASE
    WHEN avg_daily_steps < 5000 THEN 'Sedentary'
    WHEN avg_daily_steps < 7500 THEN 'Low active'
    WHEN avg_daily_steps < 10000 THEN 'Somewhat active'
    ELSE 'Active'
  END AS user_activity_segment,
  COUNT(*) AS users,
  ROUND(AVG(avg_daily_steps), 0) AS segment_avg_steps,
  ROUND(AVG(avg_very_active_minutes), 0) AS avg_very_active_minutes,
  ROUND(AVG(avg_sedentary_minutes), 0) AS avg_sedentary_minutes
FROM user_summary
GROUP BY user_activity_segment
ORDER BY segment_avg_steps;
