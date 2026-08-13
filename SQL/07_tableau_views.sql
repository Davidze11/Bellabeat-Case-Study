-- Bellabeat Case Study
-- 07_tableau_views.sql
-- Purpose: Create the six BigQuery tables exported to Tableau for visualization.

-- ============================================================
-- 1. Activity by day
-- ============================================================

CREATE OR REPLACE TABLE `tethers-400518-495323.bellabeat_case_study.viz_activity_by_day` AS
SELECT FORMAT_DATE('%A', ActivityDate) AS day_of_week,
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
GROUP BY day_of_week, day_number
ORDER BY day_number;

-- ============================================================
-- 2. Activity by hour
-- ============================================================

CREATE OR REPLACE TABLE `tethers-400518-495323.bellabeat_case_study.viz_activity_by_hour` AS
SELECT EXTRACT(HOUR FROM ActivityHour) AS hour_of_day,
       FORMAT_DATETIME('%I %p', ActivityHour) AS hour_label,
       COUNT(*) AS observations,
       ROUND(AVG(StepTotal), 0) AS avg_steps
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_clean`
GROUP BY hour_of_day, hour_label
ORDER BY hour_of_day;

-- ============================================================
-- 3. Activity segments
-- ============================================================

CREATE OR REPLACE TABLE `tethers-400518-495323.bellabeat_case_study.viz_activity_segments` AS
WITH user_summary AS (
  SELECT Id,
         COUNT(DISTINCT ActivityDate) AS days_recorded,
         ROUND(AVG(TotalSteps), 0) AS avg_daily_steps,
         ROUND(AVG(VeryActiveMinutes), 0) AS avg_very_active_minutes,
         ROUND(AVG(SedentaryMinutes), 0) AS avg_sedentary_minutes
  FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_clean`
  GROUP BY Id
),
user_segments AS (
  SELECT *,
         CASE WHEN avg_daily_steps < 5000 THEN 'Sedentary'
              WHEN avg_daily_steps < 7500 THEN 'Low active'
              WHEN avg_daily_steps < 10000 THEN 'Somewhat active'
              ELSE 'Active' END AS activity_segment
  FROM user_summary
)
SELECT activity_segment,
       COUNT(*) AS users,
       ROUND(AVG(avg_daily_steps), 0) AS segment_avg_steps,
       ROUND(AVG(avg_very_active_minutes), 0) AS avg_very_active_minutes,
       ROUND(AVG(avg_sedentary_minutes), 0) AS avg_sedentary_minutes
FROM user_segments
GROUP BY activity_segment
ORDER BY CASE activity_segment
           WHEN 'Sedentary' THEN 1 WHEN 'Low active' THEN 2
           WHEN 'Somewhat active' THEN 3 WHEN 'Active' THEN 4 END;

-- ============================================================
-- 4. Steps vs calories
-- ============================================================

CREATE OR REPLACE TABLE `tethers-400518-495323.bellabeat_case_study.viz_steps_calories` AS
SELECT Id, ActivityDate, TotalSteps, Calories
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_clean`
WHERE TotalSteps IS NOT NULL AND Calories IS NOT NULL;

-- ============================================================
-- 5. Sleep by activity level
-- ============================================================

CREATE OR REPLACE TABLE `tethers-400518-495323.bellabeat_case_study.viz_sleep_by_activity` AS
WITH sleep_activity AS (
  SELECT a.Id, a.ActivityDate, a.TotalSteps, s.TotalMinutesAsleep, s.TotalTimeInBed
  FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_clean` AS a
  INNER JOIN `tethers-400518-495323.bellabeat_case_study.sleep_day_clean` AS s
    ON a.Id = s.Id
   AND a.ActivityDate = DATE(PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', s.SleepDay))
),
categorized AS (
  SELECT *,
         CASE WHEN TotalSteps < 5000 THEN 'Sedentary'
              WHEN TotalSteps < 7500 THEN 'Low active'
              WHEN TotalSteps < 10000 THEN 'Somewhat active'
              ELSE 'Active' END AS activity_level
  FROM sleep_activity
)
SELECT activity_level,
       COUNT(*) AS records,
       ROUND(AVG(TotalSteps), 0) AS avg_steps,
       ROUND(AVG(TotalMinutesAsleep) / 60, 2) AS avg_hours_asleep,
       ROUND(AVG(TotalTimeInBed) / 60, 2) AS avg_hours_in_bed,
       ROUND(AVG(SAFE_DIVIDE(TotalMinutesAsleep, TotalTimeInBed) * 100), 2) AS avg_sleep_efficiency
FROM categorized
GROUP BY activity_level
ORDER BY CASE activity_level
           WHEN 'Sedentary' THEN 1 WHEN 'Low active' THEN 2
           WHEN 'Somewhat active' THEN 3 WHEN 'Active' THEN 4 END;

-- ============================================================
-- 6. Steps vs sleep
-- ============================================================

CREATE OR REPLACE TABLE `tethers-400518-495323.bellabeat_case_study.viz_steps_sleep` AS
SELECT a.Id,
       a.ActivityDate,
       a.TotalSteps,
       ROUND(s.TotalMinutesAsleep / 60.0, 2) AS HoursAsleep
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_clean` AS a
INNER JOIN `tethers-400518-495323.bellabeat_case_study.sleep_day_clean` AS s
  ON a.Id = s.Id
 AND a.ActivityDate = DATE(PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', s.SleepDay));
