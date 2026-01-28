SELECT
    src.load_row_id AS measurement_id,
    src.subject_id AS subject_id,
    src.hadm_id AS hadm_id,
    src.stay_id AS stay_id,
    src.provider_id AS provider_id,
    src.start_datetime AS start_datetime,
    32817 AS type_concept_id,  -- OMOP4976890 EHR
    src.itemid AS itemid,
    src.source_code AS source_code,
    src.source_label AS source_label,
    c_main.source_vocabulary_id AS source_vocabulary_id,
    c_main.source_domain_id AS source_domain_id,
    c_main.source_concept_id AS source_concept_id,
    c_main.target_domain_id AS target_domain_id,
    c_main.target_concept_id AS target_concept_id,
    src.value AS value_source_value,
    CASE
        WHEN src.valuenum IS NULL AND src.value IS NOT NULL 
        THEN COALESCE(c_value.target_concept_id, 0)
        ELSE NULL
    END AS value_as_concept_id,
    src.valuenum AS value_as_number,
    src.valueuom AS unit_source_value, -- unit of measurement
    CASE
        WHEN src.valueuom IS NOT NULL
        THEN COALESCE(uc.target_concept_id, 0)
        ELSE NULL
    END AS unit_concept_id,
    CASE
        WHEN src.valueuom IS NOT NULL
        THEN COALESCE(uc.source_concept_id, 0)
        ELSE NULL
    END AS unit_source_concept_id,
    --
    CONCAT('meas.', src.unit_id) AS unit_id,
    src.load_table_id AS load_table_id,
    src.trace_id AS trace_id,
    src.load_row_id AS load_row_id
FROM
    {{ ref("int__lk_chartevents_clean") }} AS src -- ce
LEFT JOIN
    {{ ref("int__lk_chartevents_concept") }} AS c_main -- main
        ON c_main.source_code = src.source_code
        AND c_main.source_vocabulary_id = 'mimiciv_meas_chart'
LEFT JOIN
    {{ ref("int__lk_chartevents_concept") }} AS c_value -- values for main
        ON c_value.source_code = src.value
        AND c_value.source_vocabulary_id = 'mimiciv_meas_chartevents_value'
        AND c_value.target_domain_id = 'Meas Value'
LEFT JOIN
    {{ ref("int__lk_meas_unit_concept") }} AS uc
        ON uc.source_code = src.valueuom