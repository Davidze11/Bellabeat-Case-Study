-- Bellabeat Case Study
-- 06_sleep_activity_analysis.sql
-- Purpose: Validate the activity-sleep join, analyze relationships between sleep
--          and daily activity, and compare activity behavior across sleep-duration groups.
-- Platform: Google BigQuery
-- Project: tethers-400518-495323
-- Dataset: bellabeat_case_study

-- ============================================================
-- 1. Validate the activity + sleep join
-- ============================================================

SELECT
  COUNT(*) AS matched_records,
  COUNT(DISTINCT a.Id) AS matched_users,
  MIN(a.ActivityDate) AS earliest_date,
  MAX(a.ActivityDate) AS latest_date
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_clean` AS a
INNER JOIN `tethers-400518-495323.bellabeat_case_study.sleep_day_clean` AS s
  ON a.Id = s.Id
  AND a.ActivityDate = DATE(
    PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', s.SleepDay)
  );


-- ============================================================
-- 2. Correlations between sleep duration and daily activity measures
-- ============================================================

WITH sleep_activity AS (
  SELECT
    a.Id,
    a.ActivityDate,
    a.TotalSteps,
    a.VeryActiveMinutes,
    a.FairlyActiveMinutes,
    a.LightlyActiveMinutes,
    a.SedentaryMinutes,
    a.Calories,
    s.TotalMinutesAsleep,
    s.TotalTimeInBed
  FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_clean` AS a
  INNER JOIN `tethers-400518-495323.bellabeat_case_study.sleep_day_clean` AS s
    ON a.Id = s.Id
    AND a.ActivityDate = DATE(
      PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', s.SleepDay)
    )
)
SELECT
  ROUND(CORR(TotalMinutesAsleep, TotalSteps), 3) AS sleep_steps_corr,
  ROUND(CORR(TotalMinutesAsleep, VeryActiveMinutes), 3) AS sleep_very_active_corr,
  ROUND(CORR(TotalMinutesAsleep, FairlyActiveMinutes), 3) AS sleep_fairly_active_corr,
  ROUND(CORR(TotalMinutesAsleep, LightlyActiveMinutes), 3) AS sleep_lightly_active_corr,
  ROUND(CORR(TotalMinutesAsleep, SedentaryMinutes), 3) AS sleep_sedentary_corr,
  ROUND(CORR(TotalMinutesAsleep, Calories), 3) AS sleep_calories_corr
FROM sleep_activity;


-- ============================================================
-- 3. Compare activity behavior across sleep-duration categories
-- ============================================================

WITH sleep_activity AS (
  SELECT
    a.Id,
    a.ActivityDate,
    a.TotalSteps,
    a.SedentaryMinutes,
    a.Calories,
    s.TotalMinutesAsleep
  FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_clean` AS a
  INNER JOIN `tethers-400518-495323.bellabeat_case_study.sleep_day_clean` AS s
    ON a.Id = s.Id
    AND a.ActivityDate = DATE(
      PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', s.SleepDay)
    )
)
SELECT
  CASE
    WHEN TotalMinutesAsleep < 360 THEN 'Less than 6 hours'
    WHEN TotalMinutesAsleep < 420 THEN '6 to <7 hours'
    WHEN TotalMinutesAsleep < 480 THEN '7 to <8 hours'
    ELSE '8+ hours'
  END AS sleep_category,
  COUNT(*) AS records,
  ROUND(AVG(TotalMinutesAsleep) / 60, 2) AS avg_hours_asleep,
  ROUND(AVG(TotalSteps), 0) AS avg_steps,
  ROUND(AVG(SedentaryMinutes), 0) AS avg_sedentary_minutes,
  ROUND(AVG(Calories), 0) AS avg_calories
FROM sleep_activity
GROUP BY sleep_category
ORDER BY
  CASE sleep_category
    WHEN 'Less than 6 hours' THEN 1
    WHEN '6 to <7 hours' THEN 2
    WHEN '7 to <8 hours' THEN 3
    WHEN '8+ hours' THEN 4
  END;
