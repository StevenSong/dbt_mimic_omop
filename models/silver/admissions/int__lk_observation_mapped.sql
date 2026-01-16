with lk_obs_admissions_concept AS (
SELECT DISTINCT
    src.value_as_string AS source_code,
    src.source_vocabulary_id AS source_vocabulary_id,
    vc.domain_id AS source_domain_id,
    vc.concept_id AS source_concept_id,
    vc2.domain_id AS target_domain_id,
    vc2.concept_id AS target_concept_id
FROM
    {{ ref("int__lk_observation_clean") }} AS src
LEFT JOIN
    {{ ref("stg__voc_concept") }} AS vc
        ON src.value_as_string = vc.concept_code
        AND src.source_vocabulary_id = vc.vocabulary_id
LEFT JOIN
    {{ ref("stg__voc_concept_relationship") }} AS vcr
        ON vc.concept_id = vcr.concept_id_1
        AND vcr.relationship_id = 'Maps to'
LEFT JOIN
    {{ ref("stg__voc_concept") }} AS vc2
        ON vc2.concept_id = vcr.concept_id_2
        AND vc2.standard_concept = 'S'
        AND vc2.invalid_reason IS NULL
)

SELECT
    src.hadm_id AS hadm_id, -- to visit
    src.subject_id AS subject_id, -- to person
    COALESCE(src.target_concept_id, 0) AS target_concept_id,
    src.start_datetime AS start_datetime,
    src.end_datetime,
    32817 AS type_concept_id, -- OMOP4976890 EHR, -- Rules 1-4
    src.source_code AS source_code,
    0 AS source_concept_id,
    src.value_as_string AS value_as_string,
    lc.target_concept_id AS value_as_concept_id,
    'Observation' AS target_domain_id, -- to join on src.target_concept_id?
    src.provider_id AS provider_id,
    --
    src.unit_id AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{ ref("int__lk_observation_clean") }} AS src
LEFT JOIN
    lk_obs_admissions_concept AS lc
        ON src.value_as_string = lc.source_code
        AND src.source_vocabulary_id = lc.source_vocabulary_id