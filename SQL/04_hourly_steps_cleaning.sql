-- Bellabeat Case Study
-- 04_hourly_steps_cleaning.sql
-- Purpose: Validate hourly step date ranges, investigate the April 12 overlap,
--          confirm duplicate hourly observations, and create the cleaned hourly table.
-- Platform: Google BigQuery
-- Project: tethers-400518-495323
-- Dataset: bellabeat_case_study

-- ============================================================
-- 1. Check the date ranges of both hourly step tables
-- ============================================================

SELECT
  'hourly_steps_0312_0411' AS table_name,
  MIN(
    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    )
  ) AS earliest_datetime,
  MAX(
    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    )
  ) AS latest_datetime
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0312_0411`

UNION ALL

SELECT
  'hourly_steps_0412_0512',
  MIN(
    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    )
  ),
  MAX(
    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    )
  )
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0412_0512`;


-- ============================================================
-- 2. Investigate the April 12 overlap
-- ============================================================

SELECT
  'hourly_steps_0312_0411' AS table_name,
  COUNT(*) AS april_12_rows,
  COUNT(DISTINCT Id) AS participants,
  MIN(
    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    )
  ) AS earliest_hour,
  MAX(
    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    )
  ) AS latest_hour
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0312_0411`
WHERE DATE(
  SAFE.PARSE_DATETIME(
    '%m/%d/%Y %I:%M:%S %p',
    ActivityHour
  )
) = '2016-04-12'

UNION ALL

SELECT
  'hourly_steps_0412_0512',
  COUNT(*),
  COUNT(DISTINCT Id),
  MIN(
    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    )
  ),
  MAX(
    SAFE.PARSE_DATETIME(
      '%m/%d/%Y %I:%M:%S %p',
      ActivityHour
    )
  )
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0412_0512`
WHERE DATE(
  SAFE.PARSE_DATETIME(
    '%m/%d/%Y %I:%M:%S %p',
    ActivityHour
  )
) = '2016-04-12';


-- ============================================================
-- 3. Compare matching hourly observations across both tables
-- ============================================================

SELECT
  COUNT(*) AS matching_id_hours,
  COUNTIF(
    a.StepTotal = b.StepTotal
  ) AS identical_step_records,
  COUNTIF(
    a.StepTotal != b.StepTotal
  ) AS different_step_records
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0312_0411` AS a
INNER JOIN `tethers-400518-495323.bellabeat_case_study.hourly_steps_0412_0512` AS b
  ON a.Id = b.Id
  AND SAFE.PARSE_DATETIME(
    '%m/%d/%Y %I:%M:%S %p',
    a.ActivityHour
  ) = SAFE.PARSE_DATETIME(
    '%m/%d/%Y %I:%M:%S %p',
    b.ActivityHour
  )
WHERE DATE(
  SAFE.PARSE_DATETIME(
    '%m/%d/%Y %I:%M:%S %p',
    a.ActivityHour
  )
) = '2016-04-12';


-- ============================================================
-- 4. Create the cleaned hourly step table
--    Keep the older table before April 12 and the newer table
--    from April 12 onward. Convert ActivityHour to DATETIME.
-- ============================================================

CREATE OR REPLACE TABLE
  `tethers-400518-495323.bellabeat_case_study.hourly_steps_clean` AS

-- Older dataset: keep everything before April 12
SELECT
  Id,
  SAFE.PARSE_DATETIME(
    '%m/%d/%Y %I:%M:%S %p',
    ActivityHour
  ) AS ActivityHour,
  StepTotal
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0312_0411`
WHERE DATE(
  SAFE.PARSE_DATETIME(
    '%m/%d/%Y %I:%M:%S %p',
    ActivityHour
  )
) < '2016-04-12'

UNION ALL

-- Newer dataset: keep April 12 onward
SELECT
  Id,
  SAFE.PARSE_DATETIME(
    '%m/%d/%Y %I:%M:%S %p',
    ActivityHour
  ) AS ActivityHour,
  StepTotal
FROM `tethers-400518-495323.bellabeat_case_study.hourly_steps_0412_0512`;
