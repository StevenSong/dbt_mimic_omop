SELECT
    hash(src.subject_id, src.start_datetime, src.load_row_id, src.load_table_id) AS measurement_id,
    src.subject_id AS subject_id,
    COALESCE(src.hadm_id, hadm.hadm_id) AS hadm_id,
    CAST(src.start_datetime AS DATE) AS date_id,
    32856 AS type_concept_id, -- Lab
    src.start_datetime AS start_datetime,
    src.test_itemid AS test_itemid,
    src.spec_itemid AS spec_itemid,
    src.org_itemid AS org_itemid,
    CONCAT(tc.source_code, '|', sc.source_code) AS source_code, -- test itemid plus specimen itemid
    tc.source_vocabulary_id AS source_vocabulary_id,
    tc.source_concept_id AS source_concept_id,
    COALESCE(tc.target_domain_id, 'Measurement') AS target_domain_id,
    tc.target_concept_id AS target_concept_id,
    oc.source_code AS value_source_value,
    oc.target_concept_id AS value_as_concept_id,
    src.provider_id AS provider_id,
    -- fields to link to specimen and test-organism
    src.trace_id_spec AS trace_id_spec,
    --
    src.unit_id AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{ ref("int__lk_meas_organism_clean") }} AS src
INNER JOIN
    {{ ref("int__lk_d_micro_concept") }} AS tc
        ON src.test_itemid = tc.itemid
INNER JOIN
    {{ ref("int__lk_d_micro_concept") }} AS sc
        ON src.spec_itemid = sc.itemid
LEFT JOIN
    {{ ref("int__lk_d_micro_concept") }} AS oc
        ON src.org_itemid = oc.itemid
LEFT JOIN
    {{ ref("int__lk_micro_hadm_id") }} AS hadm
        ON hadm.event_trace_id = src.trace_id
        AND hadm.row_num = 1