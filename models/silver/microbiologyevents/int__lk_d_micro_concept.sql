with lk_d_micro_clean as (
SELECT
    dm.itemid AS itemid,
    CAST(dm.itemid AS TEXT) AS source_code,
    dm.label AS source_label, -- for organism_mapped: test name plus specimen name
    CONCAT('mimiciv_micro_', LOWER(dm.category)) AS source_vocabulary_id
FROM
    {{ ref("int__lk_d_micro") }} AS dm
UNION ALL
SELECT DISTINCT
    CAST(NULL AS INTEGER) AS itemid,
    src.interpretation AS source_code,
    src.interpretation AS source_label,
    'mimiciv_micro_resistance' AS source_vocabulary_id
FROM
    {{ ref("int__lk_meas_ab_clean") }} AS src
WHERE
    src.interpretation IS NOT NULL
)

SELECT
    dm.itemid AS itemid,
    dm.source_code AS source_code, -- itemid
    dm.source_label AS source_label, -- symbolic information in case more mapping is required
    dm.source_vocabulary_id AS source_vocabulary_id,
    -- source concept
    vc.domain_id AS source_domain_id,
    vc.concept_id AS source_concept_id,
    vc.concept_name AS source_concept_name,
    -- target concept
    vc2.vocabulary_id AS target_vocabulary_id,
    vc2.domain_id AS target_domain_id,
    vc2.concept_id AS target_concept_id,
    vc2.concept_name AS target_concept_name,
    vc2.standard_concept AS target_standard_concept
FROM
    lk_d_micro_clean AS dm
LEFT JOIN
    {{ ref("stg__voc_concept") }} AS vc
        ON dm.source_code = vc.concept_code
        -- gcpt_microbiology_specimen_to_concept -> mimiciv_micro_specimen
        -- (gcpt) brand new vocab -> mimiciv_micro_test
        -- gcpt_org_name_to_concept -> mimiciv_micro_organism
        -- (gcpt) brand new vocab -> mimiciv_micro_resistance
        AND vc.vocabulary_id = dm.source_vocabulary_id
LEFT JOIN
    {{ ref("stg__voc_concept_relationship") }} AS vcr
        ON vc.concept_id = vcr.concept_id_1
        AND vcr.relationship_id = 'Maps to'
LEFT JOIN
    {{ ref("stg__voc_concept") }} AS vc2
        ON vc2.concept_id = vcr.concept_id_2
        AND vc2.standard_concept = 'S'
        AND vc2.invalid_reason IS NULL