SELECT
    src.subject_id AS subject_id,
    src.hadm_id AS hadm_id,
    src.stay_id AS stay_id,
    src.provider_id AS provider_id,
    src.start_datetime AS start_datetime,
    src.value AS source_code,
    c_main.source_vocabulary_id AS source_vocabulary_id,
    c_main.source_concept_id AS source_concept_id,
    c_main.target_domain_id AS target_domain_id,
    c_main.target_concept_id AS target_concept_id,
    --
    CONCAT('cond.', src.unit_id) AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{ ref("int__lk_chartevents_clean") }} AS src
INNER JOIN
    {{ ref("int__lk_chartevents_concept") }} AS c_main
        ON c_main.source_code = src.value
        AND c_main.source_vocabulary_id = 'mimiciv_meas_chartevents_value'
        AND c_main.target_domain_id = 'Condition'