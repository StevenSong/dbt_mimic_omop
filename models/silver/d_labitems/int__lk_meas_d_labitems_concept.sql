with lk_meas_d_labitems_clean AS (
SELECT
    dlab.itemid AS itemid, -- for <cdm>.<source_value>
    COALESCE(dlab.loinc_code, CAST(dlab.itemid AS TEXT)) AS source_code, -- to join to vocabs
    dlab.loinc_code AS loinc_code, -- for the crosswalk table
    CONCAT(dlab.label, '|', dlab.fluid, '|', dlab.category) AS source_label, -- for the crosswalk table
    CASE
        WHEN dlab.loinc_code IS NOT NULL 
        THEN 'LOINC'
        ELSE 'mimiciv_meas_lab_loinc'
    END AS source_vocabulary_id
FROM
    {{ ref("stg__d_labitems") }} AS dlab
)

SELECT
    dlab.itemid AS itemid,
    dlab.source_code AS source_code,
    dlab.loinc_code AS loinc_code,
    dlab.source_label AS source_label,
    dlab.source_vocabulary_id AS source_vocabulary_id,
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
    lk_meas_d_labitems_clean AS dlab
LEFT JOIN
    {{ ref("stg__voc_concept") }} AS vc
        ON vc.concept_code = dlab.source_code
        AND vc.vocabulary_id = dlab.source_vocabulary_id
        -- AND vc.domain_id = 'Measurement'
LEFT JOIN
    {{ ref("stg__voc_concept_relationship") }} AS vcr
        ON vc.concept_id = vcr.concept_id_1
        AND vcr.relationship_id = 'Maps to'
LEFT JOIN
    {{ ref("stg__voc_concept") }} AS vc2
        ON vc2.concept_id = vcr.concept_id_2
        AND vc2.standard_concept = 'S'
        AND vc2.invalid_reason IS NULL