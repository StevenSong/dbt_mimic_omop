with lk_outputevents AS (
SELECT
    src.subject_id AS subject_id,
    src.hadm_id AS hadm_id,
    src.stay_id AS stay_id,
    src.caregiver_id AS provider_id,
    src.itemid AS itemid,
    CAST(src.itemid AS TEXT) AS source_code,
    di.label AS source_label,
    src.charttime AS start_datetime,
    src.value AS valuenum,
    src.valueuom AS valueuom,
    --
    'outputevents' AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{ ref("stg__outputevents") }} AS src
INNER JOIN
    {{ ref("stg__d_items") }} AS di
        ON src.itemid = di.itemid
)

SELECT
    hash(src.subject_id, src.hadm_id, src.stay_id, src.itemid, src.start_datetime) AS measurement_id,
    src.subject_id AS subject_id,
    src.hadm_id AS hadm_id,
    src.stay_id AS stay_id,
    src.provider_id AS provider_id,
    src.start_datetime AS start_datetime,
    32817 AS type_concept_id,  -- OMOP4976890 EHR
    src.itemid AS itemid,
    src.source_code AS source_code,
    src.source_label AS source_label,
    vc.vocabulary_id AS vocabulary_id,
    vc.domain_id AS source_domain_id,
    vc.concept_id AS source_concept_id,
    vc2.domain_id AS target_domain_id,
    vc2.concept_id AS target_concept_id,
    CAST(src.valuenum AS TEXT) AS value_source_value,
    0 AS value_as_concept_id,
    CASE
        WHEN src.itemid = 227488 THEN -src.valuenum
        ELSE src.valuenum
    END AS value_as_number,
    src.valueuom AS unit_source_value,
    CASE
        WHEN src.valueuom IS NOT NULL THEN COALESCE(uc.target_concept_id, 0)
        ELSE NULL
    END AS unit_concept_id,
    CASE
        WHEN src.valueuom IS NOT NULL THEN COALESCE(uc.source_concept_id, 0)
        ELSE 0
    END AS unit_source_concept_id,
    --
    CONCAT('meas.', src.unit_id) AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    lk_outputevents AS src
LEFT JOIN {{ ref("stg__voc_concept") }} AS vc
    ON src.source_code = vc.concept_code AND vc.vocabulary_id = 'mimiciv_outputevents'
LEFT JOIN {{ ref("stg__voc_concept_relationship") }} AS vcr
    ON vc.concept_id = vcr.concept_id_1
LEFT JOIN {{ ref("stg__voc_concept") }} AS vc2
    ON vcr.concept_id_2 = vc2.concept_id
    AND vc2.standard_concept = 'S'
    AND vc2.invalid_reason IS NULL
LEFT JOIN {{ ref("int__lk_meas_unit_concept") }} AS uc
    ON src.valueuom = uc.source_code