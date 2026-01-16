SELECT
    src.subject_id AS subject_id,
    src.hadm_id AS hadm_id,
    src.starttime AS start_datetime,
    src.endtime AS end_datetime,
    src.value AS quantity,
    src.itemid AS itemid,
    src.caregiver_id AS provider_id,
                            -- THEN it stores the duration... this is a warkaround and may be inproved
    --
    'procedureevents' AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{ ref("stg__procedureevents" )}} AS src
WHERE
    src.cancelreason = 0 -- not cancelled

union all

SELECT
    src.subject_id AS subject_id,
    src.hadm_id AS hadm_id,
    src.value AS start_datetime,
    src.value AS end_datetime,
    1 AS quantity,
    src.itemid AS itemid,
    src.caregiver_id AS provider_id,
    --
    'datetimeevents' AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id    
FROM
    {{ ref("stg__datetimeevents")}} AS src -- de
INNER JOIN
    {{ ref("stg__patients")}} AS pat
        ON pat.subject_id = src.subject_id
WHERE
    EXTRACT(YEAR FROM src.value) >= pat.anchor_year