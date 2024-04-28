{{ config(materialized='table') }}

WITH monthly_data AS (
    SELECT
        crash_year,
        SUM(total_persons_injured) AS yr_total_persons_inj, 
        SUM(total_persons_killed) AS yr_total_persons_fatal,
        SUM(number_of_pedestrians_injured) AS yr_total_ped_inj,
        SUM(number_of_pedestrians_killed) AS yr_total_ped_fatal, 
        SUM(number_of_cyclist_injured) AS yr_total_cyc_inj,
        SUM(number_of_cyclist_killed) AS yr_total_cyc_fatal,
        SUM(number_of_motorist_injured) AS yr_total_mot_inj,
        SUM(number_of_motorist_killed) AS yr_total_mot_fatal,
    FROM
        {{ ref('fact_crash_weather_enriched') }}
    GROUP BY
        crash_year
)
SELECT
    crash_year,
    yr_total_persons_inj,
    yr_total_persons_fatal,
    yr_total_ped_inj,
    yr_total_ped_fatal,
    yr_total_cyc_inj,
    yr_total_cyc_fatal,
    yr_total_mot_inj,
    yr_total_mot_fatal,
    ROUND(yr_total_ped_inj / 365, 1) AS avg_daily_ped_inj,
    ROUND(yr_total_ped_fatal / 365, 1) AS avg_daily_ped_fatal,
    ROUND(yr_total_cyc_inj / 365, 1) AS avg_daily_cyc_inj,
    ROUND(yr_total_cyc_fatal / 365, 1) AS avg_daily_cyc_fatal,
    ROUND(yr_total_mot_inj / 365, 1) AS avg_daily_mot_inj,
    ROUND(yr_total_mot_fatal / 365, 1) AS avg_daily_mot_fatal
FROM
    monthly_data
ORDER BY 
    crash_year

-- dbt build --m <model.sql> --vars 'is_test_run: false'
--{% if var('is_test_run', default=true) %}

--  limit 100

--{% endif %}