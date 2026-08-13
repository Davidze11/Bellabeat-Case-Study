# Bellabeat Case Study: How Can a Wellness Company Play It Smart?

**Google Data Analytics Professional Certificate Capstone**

This case study analyzes Fitbit fitness tracker data to identify consumer activity, sleep, and wellness trends and translate those findings into high-level marketing recommendations for Bellabeat's **Leaf** wellness tracker.

## Project Overview

Bellabeat is a high-tech wellness company that manufactures health-focused smart products for women. The business task for this project was to analyze smart-device usage data, identify meaningful consumer behavior trends, and apply those insights to a Bellabeat product to support its marketing strategy.

The analysis follows the Google Data Analytics process:

**Ask → Prepare → Process → Analyze → Share → Act**

## Business Task

Analyze smart-device usage data to identify trends in consumer behavior and apply those insights to one Bellabeat product in order to develop high-level marketing recommendations that support Bellabeat's marketing strategy.

### Key Questions

- When are users most and least active?
- How does physical activity relate to calories burned?
- How do sleep patterns differ among users?
- Is there a relationship between activity and sleep?
- Can users be grouped into meaningful activity segments?

## Tools Used

- **Google BigQuery / SQL** — data validation, cleaning, integration, transformation, and analysis
- **Tableau Public** — exploratory visualization and dashboard development
- **CSV** — source, cleaned, and visualization-ready datasets
- **Google Data Analytics Framework** — Ask, Prepare, Process, Analyze, Share, and Act

## Dataset

The analysis uses the publicly available **FitBit Fitness Tracker Data** dataset provided by Möbius through Kaggle under a CC0: Public Domain license.

The files used in the analysis contained:

| Source table | Records | Unique users |
|---|---:|---:|
| `daily_activity_0312_0411` | 457 | 35 |
| `daily_activity_0412_0512` | 940 | 33 |
| `hourly_steps_0312_0411` | 24,084 | 34 |
| `hourly_steps_0412_0512` | 22,099 | 33 |
| `sleep_day` | 413 | 24 |

Participant coverage varies across the source files, so results—especially analyses involving sleep—should be interpreted as behavioral trends within this sample rather than generalized to all wearable-device users or Bellabeat customers.

## Data Cleaning & Processing

The original CSV files were preserved as separate raw tables in BigQuery while data-quality issues were investigated.

Key processing steps included:

- Validated record and participant counts.
- Checked all five source tables for exact duplicate records.
- Identified **3 exact duplicate sleep records** and removed them in a separate cleaned table.
- Validated the cleaned sleep dataset at **410 unique records** with no remaining exact duplicates.
- Checked the selected fields for missing values; no NULL values requiring removal or imputation were identified.
- Standardized hourly activity date-time values by converting `ActivityHour` from STRING to DATETIME.
- Investigated overlapping data on April 12, 2016 before combining collection periods.
- For daily activity, retained the later dataset's April 12 observations because it contained broader participant coverage.
- For hourly steps, confirmed that all 175 matching April 12 participant-hour records had identical `StepTotal` values and excluded the duplicate observations from the earlier dataset.
- Created final cleaned analysis tables:
  - `daily_activity_clean` — **1,373 records**
  - `hourly_steps_clean` — **46,008 records**
  - `sleep_day_clean` — **410 records**

## Analysis & Key Findings

### Overall Activity

Participants averaged approximately:

- **7,377 steps per day**
- **5.29 miles per day**
- **2,295 calories per day**

### Activity by Day and Hour

- **Saturday** had the highest average daily steps at approximately **7,752**.
- **Sunday** had the lowest at approximately **6,607**.
- Activity was very low overnight and increased rapidly beginning around **6 AM**.
- Average hourly steps peaked at approximately **555 steps at 7 PM**.

### Activity and Calories

Daily steps showed a **moderate positive correlation** with calories burned (**r = 0.58**).

Among activity-intensity measures, very-active minutes had the strongest positive relationship with calories burned (**r = 0.594**). This indicates association, not causation.

### Sleep

Among participants with sleep records:

- Average sleep duration was approximately **6.99 hours per night**.
- Average time in bed was approximately **7.64 hours**.
- Average sleep efficiency was approximately **91.65%**.

Joining daily activity and sleep by participant and date produced **410 matched records from 24 participants**.

Daily steps and sleep duration had a **weak negative correlation (r = -0.19)**. The Tableau trend analysis indicated statistical significance (**p ≈ 0.0001**), but the small correlation coefficient means the relationship itself was weak and should not be interpreted as causal.

### Activity Segments

Participants were grouped using average daily steps:

| Activity segment | Average daily steps | Users |
|---|---:|---:|
| Sedentary | < 5,000 | 11 |
| Low Active | 5,000–7,499 | 9 |
| Somewhat Active | 7,500–9,999 | 8 |
| Active | 10,000+ | 7 |

Of the 35 analyzed participants, **20 (approximately 57%)** were classified as Sedentary or Low Active.

The Sedentary group averaged approximately **2,898 steps per day**, compared with approximately **12,694 steps per day** among Active users.

## Tableau Dashboards

Two dashboards were developed in Tableau Public.

### Bellabeat Wellness & Activity Analysis

The first dashboard explores:

- Average daily steps by day of week
- Average steps by hour of day
- Daily steps vs. calories burned
- Average sleep duration by activity level

### Bellabeat Sleep & Activity Analysis

The second dashboard explores:

- Average activity minutes by day of week
- Average sedentary minutes by day of week
- Daily steps vs. sleep duration
- Average sleep efficiency by activity level

Recorded sedentary time remained high throughout the week at approximately **970–1,030 minutes per day**, while sleep efficiency remained at **90% or greater across all activity levels**.

## Business Recommendations

The **Bellabeat Leaf** was selected as the product to which the findings were applied.

### 1. Promote Leaf as a Tool for Building Consistent Activity Habits

Use Leaf's activity tracking to help users identify lower-activity periods, establish personalized goals, and encourage more consistent movement throughout the week.

### 2. Emphasize Reducing Prolonged Sedentary Behavior

Position Leaf as a tool that helps consumers become more aware of prolonged inactivity and supports sustainable movement habits throughout the day rather than focusing only on a daily step target.

### 3. Market Leaf as an Integrated Activity and Sleep Wellness Tracker

Emphasize Leaf's ability to help users view activity and sleep together, balance movement with rest, and use personal wellness data to develop more informed routines.

## Limitations

- The dataset contains a relatively small number of participants.
- Participant coverage varies across tables and collection periods.
- Only **24 participants** had matching activity and sleep records.
- The data was collected in **2016**.
- The dataset contains limited demographic information.
- The participants were Fitbit users rather than Bellabeat customers.

Future analysis would benefit from a larger and more diverse sample, a longer collection period, additional demographic and wellness variables, and appropriately collected Bellabeat customer data.

## Repository Structure

```text
Bellabeat_Case_Study/
│
├── Original_Data/
│   ├── daily_activity_0312_0411.csv
│   ├── daily_activity_0412_0512.csv
│   ├── hourly_steps_0312_0411.csv
│   ├── hourly_steps_0412_0512.csv
│   └── sleep_day_0412_0512.csv
│
├── Cleaned_Data/
│   ├── daily_activity_clean.csv
│   ├── hourly_steps_clean.csv
│   └── sleep_day_clean.csv
│
├── SQL/
│   ├── 01_source_validation.sql
│   ├── 02_sleep_cleaning.sql
│   ├── 03_daily_activity_cleaning.sql
│   ├── 04_hourly_steps_cleaning.sql
│   ├── 05_activity_analysis.sql
│   ├── 06_sleep_activity_analysis.sql
│   └── 07_tableau_views.sql
│
├── Tableau/
│   ├── Tableau Data/
│   └── Tableau Workbook/
│
├── Report/
│   └── Bellabeat_Case_Study_Report.pdf
│
└── README.md
```

## Full Case Study

For the complete methodology, data-quality investigation, SQL analysis, Tableau findings, and business recommendations, see:

[**View the Full Bellabeat Case Study Report**](Report/Bellabeat_Case_Study_Report.pdf)

---

**David Engstrom**  
Google Data Analytics Professional Certificate  
August 2026
