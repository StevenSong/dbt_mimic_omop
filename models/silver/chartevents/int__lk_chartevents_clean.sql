SELECT
    src.subject_id AS subject_id,
    src.hadm_id AS hadm_id,
    src.stay_id AS stay_id,
    src.caregiver_id AS provider_id,
    src.itemid AS itemid,
    CAST(src.itemid AS TEXT) AS source_code,
    di.label AS source_label,
    src.charttime AS start_datetime,
    TRIM(src.value) AS value,
    CASE
        WHEN TRIM(src.value) ~ '^[-]?\d+(\.\d+)?\s*[a-z]+$'
        THEN CAST(
            regexp_extract(TRIM(src.value), '[-]?\d+(\.\d+)?', 0)
            AS DOUBLE
        )
        ELSE src.valuenum
    END AS valuenum,
    CASE
        WHEN TRIM(src.value) ~ '^[-]?\d+(\.\d+)?\s*[a-z]+$'
        THEN regexp_extract(TRIM(src.value), '[a-z]+', 0)
        ELSE src.valueuom
    END AS valueuom, -- unit of measurement
    --
    'chartevents' AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{ ref("stg__chartevents") }} AS src
INNER JOIN
    {{ ref("stg__d_items" )}} AS di
        ON src.itemid = di.itemid
WHERE
    di.label NOT LIKE '%Temperature'
    OR (
        di.label LIKE '%Temperature'
        AND CASE
                WHEN src.valueuom ILIKE '%F%' THEN (src.valuenum - 32) * 5 / 9
                ELSE src.valuenum
            END BETWEEN 25 AND 44
    )