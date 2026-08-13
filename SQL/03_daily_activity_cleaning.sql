-- Bellabeat Case Study
-- 03_daily_activity_cleaning.sql
-- Purpose: Investigate the April 12 overlap between daily activity tables
--          and create the final cleaned daily activity table.
-- Platform: Google BigQuery
-- Project: tethers-400518-495323
-- Dataset: bellabeat_case_study

-- ============================================================
-- 1. Compare April 12 record and participant counts
-- ============================================================

SELECT
  'daily_activity_0312_0411' AS table_name,
  COUNT(*) AS april_12_rows,
  COUNT(DISTINCT Id) AS participants
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0312_0411`
WHERE ActivityDate = '2016-04-12'

UNION ALL

SELECT
  'daily_activity_0412_0512',
  COUNT(*),
  COUNT(DISTINCT Id)
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0412_0512`
WHERE ActivityDate = '2016-04-12';


-- ============================================================
-- 2. Count participant-date overlap on April 12
-- ============================================================

SELECT
  COUNT(*) AS matching_participant_dates
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0312_0411` AS a
INNER JOIN `tethers-400518-495323.bellabeat_case_study.daily_activity_0412_0512` AS b
  ON a.Id = b.Id
  AND a.ActivityDate = b.ActivityDate
WHERE a.ActivityDate = '2016-04-12';


-- ============================================================
-- 3. Determine whether matching April 12 records are identical
-- ============================================================

SELECT
  COUNT(*) AS matching_id_dates,
  COUNTIF(
    a.TotalSteps = b.TotalSteps
    AND a.TotalDistance = b.TotalDistance
    AND a.TrackerDistance = b.TrackerDistance
    AND a.LoggedActivitiesDistance = b.LoggedActivitiesDistance
    AND a.VeryActiveDistance = b.VeryActiveDistance
    AND a.ModeratelyActiveDistance = b.ModeratelyActiveDistance
    AND a.LightActiveDistance = b.LightActiveDistance
    AND a.SedentaryActiveDistance = b.SedentaryActiveDistance
    AND a.VeryActiveMinutes = b.VeryActiveMinutes
    AND a.FairlyActiveMinutes = b.FairlyActiveMinutes
    AND a.LightlyActiveMinutes = b.LightlyActiveMinutes
    AND a.SedentaryMinutes = b.SedentaryMinutes
    AND a.Calories = b.Calories
  ) AS completely_identical_records,
  COUNTIF(
    NOT (
      a.TotalSteps = b.TotalSteps
      AND a.TotalDistance = b.TotalDistance
      AND a.TrackerDistance = b.TrackerDistance
      AND a.LoggedActivitiesDistance = b.LoggedActivitiesDistance
      AND a.VeryActiveDistance = b.VeryActiveDistance
      AND a.ModeratelyActiveDistance = b.ModeratelyActiveDistance
      AND a.LightActiveDistance = b.LightActiveDistance
      AND a.SedentaryActiveDistance = b.SedentaryActiveDistance
      AND a.VeryActiveMinutes = b.VeryActiveMinutes
      AND a.FairlyActiveMinutes = b.FairlyActiveMinutes
      AND a.LightlyActiveMinutes = b.LightlyActiveMinutes
      AND a.SedentaryMinutes = b.SedentaryMinutes
      AND a.Calories = b.Calories
    )
  ) AS different_records
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0312_0411` AS a
INNER JOIN `tethers-400518-495323.bellabeat_case_study.daily_activity_0412_0512` AS b
  ON a.Id = b.Id
  AND a.ActivityDate = b.ActivityDate
WHERE a.ActivityDate = '2016-04-12';


-- ============================================================
-- 4. Create the cleaned daily activity table
--    Keep the earlier dataset through April 11 and the later
--    dataset beginning April 12 to avoid duplicate participant-days.
-- ============================================================

CREATE OR REPLACE TABLE
  `tethers-400518-495323.bellabeat_case_study.daily_activity_clean` AS

-- Earlier dataset: keep everything before April 12
SELECT *
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0312_0411`
WHERE ActivityDate < '2016-04-12'

UNION ALL

-- Later dataset: keep April 12 onward
SELECT *
FROM `tethers-400518-495323.bellabeat_case_study.daily_activity_0412_0512`;
