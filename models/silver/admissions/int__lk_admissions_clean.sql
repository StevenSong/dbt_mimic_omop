SELECT
    src.subject_id AS subject_id,
    src.hadm_id AS hadm_id,
    CASE 
        WHEN src.edregtime < src.admittime THEN src.edregtime
        ELSE src.admittime
    END AS start_datetime, -- the earliest of
    src.dischtime AS end_datetime,
    src.admission_type AS admission_type, -- current location
    src.admit_provider_id AS admit_provider_id,
    src.admission_location AS admission_location, -- to hospital
    src.discharge_location AS discharge_location, -- from hospital
    CASE 
        WHEN src.edregtime IS NULL THEN FALSE
        ELSE TRUE
    END AS is_er_admission, -- create visit_detail if TRUE
    --
    'admissions' AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{ ref("stg__admissions") }} AS src