-- Bellabeat Case Study
-- 01_source_validation.sql
-- Purpose: Validate the raw source tables before cleaning and analysis.
-- Platform: Google BigQuery
-- Project: tethers-400518-495323
-- Dataset: bellabeat_case_study

-- ============================================================
-- 1. Record counts by source table
-- ============================================================
SELECT 'daily_activity_0312_0411' AS table_name, COUNT(*) AS row_count
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0312_0411`
UNION ALL
SELECT 'daily_activity_0412_0512', COUNT(*)
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0412_0512`
UNION ALL
SELECT 'hourly_steps_0312_0411', COUNT(*)
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0312_0411`
UNION ALL
SELECT 'hourly_steps_0412_0512', COUNT(*)
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0412_0512`
UNION ALL
SELECT 'sleep_day', COUNT(*)
FROM `tethers-400518-495323.bellabeat_case_study.sleep_day`;

-- ============================================================
-- 2. Distinct participant counts by source table
-- ============================================================

SELECT 'daily_activity_0312_0411' AS table_name, COUNT(DISTINCT Id) AS unique_users
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0312_0411`
UNION ALL
SELECT 'daily_activity_0412_0512', COUNT(DISTINCT Id)
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0412_0512`
UNION ALL
SELECT 'hourly_steps_0312_0411', COUNT(DISTINCT Id)
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0312_0411`
UNION ALL
SELECT 'hourly_steps_0412_0512', COUNT(DISTINCT Id)
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0412_0512`
UNION ALL
SELECT 'sleep_day', COUNT(DISTINCT Id)
FROM `tethers-400518-495323.bellabeat_case_study.sleep_day`;

-- ============================================================
-- 3. Exact duplicate-row check across all raw tables
-- ============================================================

SELECT 'daily_activity_0312_0411' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT FORMAT('%t', t)) AS distinct_rows,
       COUNT(*) - COUNT(DISTINCT FORMAT('%t', t)) AS duplicate_rows
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0312_0411` AS t
UNION ALL
SELECT 'daily_activity_0412_0512',
       COUNT(*),
       COUNT(DISTINCT FORMAT('%t', t)),
       COUNT(*) - COUNT(DISTINCT FORMAT('%t', t))
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0412_0512` AS t
UNION ALL
SELECT 'hourly_steps_0312_0411',
       COUNT(*),
       COUNT(DISTINCT FORMAT('%t', t)),
       COUNT(*) - COUNT(DISTINCT FORMAT('%t', t))
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0312_0411` AS t
UNION ALL
SELECT 'hourly_steps_0412_0512',
       COUNT(*),
       COUNT(DISTINCT FORMAT('%t', t)),
       COUNT(*) - COUNT(DISTINCT FORMAT('%t', t))
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0412_0512` AS t
UNION ALL
SELECT 'sleep_day',
       COUNT(*),
       COUNT(DISTINCT FORMAT('%t', t)),
       COUNT(*) - COUNT(DISTINCT FORMAT('%t', t))
FROM `tethers-400518-495323.bellabeat_case_study.sleep_day` AS t;

-- ============================================================
-- 4. NULL check for hourly step source tables
-- ============================================================

SELECT 'hourly_steps_0312_0411' AS table_name,
       COUNTIF(Id IS NULL) AS null_id,
       COUNTIF(ActivityHour IS NULL) AS null_activity_hour,
       COUNTIF(StepTotal IS NULL) AS null_step_total
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0312_0411`
UNION ALL
SELECT 'hourly_steps_0412_0512',
       COUNTIF(Id IS NULL),
       COUNTIF(ActivityHour IS NULL),
       COUNTIF(StepTotal IS NULL)
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0412_0512`;

-- ============================================================
-- 5. NULL check for daily activity source tables
-- ============================================================

SELECT 'daily_activity_0312_0411' AS table_name,
       COUNTIF(Id IS NULL) AS null_id,
       COUNTIF(ActivityDate IS NULL) AS null_activity_date,
       COUNTIF(TotalSteps IS NULL) AS null_total_steps,
       COUNTIF(TotalDistance IS NULL) AS null_total_distance,
       COUNTIF(TrackerDistance IS NULL) AS null_tracker_distance,
       COUNTIF(LoggedActivitiesDistance IS NULL) AS null_logged_distance,
       COUNTIF(VeryActiveDistance IS NULL) AS null_very_active_distance,
       COUNTIF(ModeratelyActiveDistance IS NULL) AS null_moderately_active_distance,
       COUNTIF(LightActiveDistance IS NULL) AS null_light_active_distance,
       COUNTIF(SedentaryActiveDistance IS NULL) AS null_sedentary_distance,
       COUNTIF(VeryActiveMinutes IS NULL) AS null_very_active_minutes,
       COUNTIF(FairlyActiveMinutes IS NULL) AS null_fairly_active_minutes,
       COUNTIF(LightlyActiveMinutes IS NULL) AS null_lightly_active_minutes,
       COUNTIF(SedentaryMinutes IS NULL) AS null_sedentary_minutes,
       COUNTIF(Calories IS NULL) AS null_calories
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0312_0411`
UNION ALL
SELECT 'daily_activity_0412_0512',
       COUNTIF(Id IS NULL),
       COUNTIF(ActivityDate IS NULL),
       COUNTIF(TotalSteps IS NULL),
       COUNTIF(TotalDistance IS NULL),
       COUNTIF(TrackerDistance IS NULL),
       COUNTIF(LoggedActivitiesDistance IS NULL),
       COUNTIF(VeryActiveDistance IS NULL),
       COUNTIF(ModeratelyActiveDistance IS NULL),
       COUNTIF(LightActiveDistance IS NULL),
       COUNTIF(SedentaryActiveDistance IS NULL),
       COUNTIF(VeryActiveMinutes IS NULL),
       COUNTIF(FairlyActiveMinutes IS NULL),
       COUNTIF(LightlyActiveMinutes IS NULL),
       COUNTIF(SedentaryMinutes IS NULL),
       COUNTIF(Calories IS NULL)
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0412_0512`;
