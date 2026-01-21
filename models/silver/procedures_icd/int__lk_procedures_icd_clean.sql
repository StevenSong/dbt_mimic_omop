SELECT
    src.subject_id AS subject_id,
    src.hadm_id AS hadm_id,
    adm.dischtime AS start_datetime,
    src.icd_code AS icd_code,
    src.icd_version AS icd_version,
    CASE
        WHEN src.icd_version = 9 THEN 'ICD9Proc'
        WHEN src.icd_version = 10 THEN 'ICD10PCS'
        ELSE 'Unknown'
    END AS source_vocabulary_id,
    REPLACE(src.icd_code, '.', '') AS source_code, -- to join lk_icd_proc_concept
    adm.admit_provider_id AS provider_id,
    --
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{ ref("stg__procedures_icd") }} AS src
INNER JOIN
    {{ ref("stg__admissions") }} AS adm
        ON src.hadm_id = adm.hadm_id