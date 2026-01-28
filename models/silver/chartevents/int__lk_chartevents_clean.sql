-- This has to be a table due to the deduplication
-- It dedups a total of... 81 rows
{{ config(materialized='table') }}

WITH duplicated_ids AS (
    SELECT load_row_id
    FROM {{ ref("stg__chartevents") }}
    GROUP BY load_row_id
    HAVING COUNT(*) > 1
),
filtered AS (
    SELECT
        subject_id,
        hadm_id,
        stay_id,
        caregiver_id,
        itemid,
        charttime,
        value,
        valuenum,
        valueuom,
        load_table_id,
        load_row_id,
        trace_id
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY load_row_id
                ORDER BY trace_id
            ) AS rn
        FROM {{ ref("stg__chartevents") }}
        WHERE load_row_id IN (SELECT load_row_id FROM duplicated_ids)
    )
    WHERE rn = 1
),
stg__chartevents_dedup AS (
    SELECT *
    FROM {{ ref("stg__chartevents") }}
    WHERE load_row_id NOT IN (SELECT load_row_id FROM duplicated_ids)

    UNION ALL

    SELECT *
    FROM filtered
)

SELECT
    src.subject_id,
    src.hadm_id,
    src.stay_id,
    src.caregiver_id AS provider_id,
    src.itemid,
    CAST(src.itemid AS TEXT) AS source_code,
    di.label AS source_label,
    src.charttime AS start_datetime,
    TRIM(src.value) AS value,
    CASE
        WHEN src.value ~ '^[-]?\d+(\.\d+)?\s*[a-z]+$'
        THEN CAST(regexp_extract(src.value, '[-]?\d+(\.\d+)?', 0) AS DOUBLE)
        ELSE src.valuenum
    END AS valuenum,
    CASE
        WHEN src.value ~ '^[-]?\d+(\.\d+)?\s*[a-z]+$'
        THEN regexp_extract(src.value, '[a-z]+', 0)
        ELSE src.valueuom
    END AS valueuom,
    'chartevents' AS unit_id,
    src.load_table_id,
    src.load_row_id,
    src.trace_id
FROM stg__chartevents_dedup src
JOIN {{ ref("stg__d_items") }} di
  ON src.itemid = di.itemid
WHERE
    di.label NOT LIKE '%Temperature'
    OR (
        di.label LIKE '%Temperature'
        AND (
            CASE
                WHEN src.valueuom ILIKE '%F%'
                THEN (src.valuenum - 32) * 5 / 9
                ELSE src.valuenum
            END
        ) BETWEEN 25 AND 44
    )
