-- Bellabeat Case Study
-- 02_sleep_cleaning.sql
-- Purpose: Identify duplicate sleep records, create a cleaned sleep table,
--          and validate key fields for missing values.
-- Platform: Google BigQuery
-- Project: tethers-400518-495323
-- Dataset: bellabeat_case_study

-- ============================================================
-- 1. Identify exact duplicate sleep records
-- ============================================================

SELECT
  Id,
  SleepDay,
  TotalSleepRecords,
  TotalMinutesAsleep,
  TotalTimeInBed,
  COUNT(*) AS occurrence_count
FROM `tethers-400518-495323.bellabeat_case_study.sleep_day`
GROUP BY
  Id,
  SleepDay,
  TotalSleepRecords,
  TotalMinutesAsleep,
  TotalTimeInBed
HAVING COUNT(*) > 1
ORDER BY
  Id,
  SleepDay;


-- ============================================================
-- 2. Create cleaned sleep table
--    SELECT DISTINCT preserves one copy of each unique record.
-- ============================================================

CREATE OR REPLACE TABLE
  `tethers-400518-495323.bellabeat_case_study.sleep_day_clean` AS
SELECT DISTINCT *
FROM `tethers-400518-495323.bellabeat_case_study.sleep_day`;


-- ============================================================
-- 3. Check cleaned sleep table for NULL values
-- ============================================================

SELECT
  COUNTIF(Id IS NULL) AS null_id,
  COUNTIF(SleepDay IS NULL) AS null_sleep_day,
  COUNTIF(TotalSleepRecords IS NULL) AS null_sleep_records,
  COUNTIF(TotalMinutesAsleep IS NULL) AS null_minutes_asleep,
  COUNTIF(TotalTimeInBed IS NULL) AS null_time_in_bed
FROM `tethers-400518-495323.bellabeat_case_study.sleep_day_clean`;
