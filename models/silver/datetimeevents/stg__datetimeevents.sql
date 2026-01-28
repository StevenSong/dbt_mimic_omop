SELECT
    subject_id  AS subject_id,
    hadm_id     AS hadm_id,
    stay_id     AS stay_id,
	caregiver_id AS caregiver_id,
    itemid      AS itemid,
    charttime   AS charttime,
    value       AS value,
    'datetimeevents'                    AS load_table_id,
    hash(subject_id, hadm_id, stay_id, charttime) AS load_row_id,
    json_object('subject_id', subject_id, 'hadm_id', hadm_id, 'stay_id', stay_id, 'charttime', charttime)::text AS trace_id
FROM
    {{ source("mimic", "datetimeevents") }}