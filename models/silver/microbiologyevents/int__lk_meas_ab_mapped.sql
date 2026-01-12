SELECT
    hash(src.subject_id, src.start_datetime, src.load_row_id, src.load_table_id) AS measurement_id,
    src.subject_id AS subject_id,
    COALESCE(src.hadm_id, hadm.hadm_id) AS hadm_id,
    CAST(src.start_datetime AS DATE) AS date_id,
    32856 AS type_concept_id, -- Lab
    src.start_datetime AS start_datetime,
    src.ab_itemid AS ab_itemid,
    ac.source_code AS source_code,
    COALESCE(ac.target_concept_id, 0) AS target_concept_id,
    COALESCE(ac.source_concept_id, 0) AS source_concept_id,
    rc.target_concept_id AS value_as_concept_id,
    src.interpretation AS value_source_value,
    src.dilution_value AS value_as_number,
    src.dilution_comparison AS operator_source_value,
    opc.target_concept_id AS operator_concept_id,
    COALESCE(ac.target_domain_id, 'Measurement') AS target_domain_id,
    src.provider_id AS provider_id,
    -- fields to link test-organism and antibiotics
    src.trace_id_org AS trace_id_org,
    src.unit_id AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{ ref("int__lk_meas_ab_clean") }} AS src
INNER JOIN
    {{ ref("int__lk_d_micro_concept") }} AS ac
        ON src.ab_itemid = ac.itemid
LEFT JOIN
    {{ ref("int__lk_d_micro_concept") }} AS rc
        ON src.interpretation = rc.source_code
        AND rc.source_vocabulary_id = 'mimiciv_micro_resistance'
LEFT JOIN
    {{ ref("int__lk_meas_operator_concept") }} AS opc
        ON src.dilution_comparison = opc.source_code
LEFT JOIN
    {{ ref("int__lk_micro_hadm_id") }} AS hadm
        ON hadm.event_trace_id = src.trace_id
        AND hadm.row_num = 1