SELECT DISTINCT
    src.ethnicity_first AS source_code,
    vc.concept_id AS source_concept_id,
    vc.vocabulary_id AS source_vocabulary_id,
    vc1.concept_id AS target_concept_id,
    vc1.vocabulary_id AS target_vocabulary_id  -- look here to distinguish Race and Ethnicity
FROM 
    {{ ref("int__subject_ethnicity") }} src
LEFT JOIN
    {{ ref("stg__voc_concept") }} vc
        ON UPPER(vc.concept_code) = UPPER(src.ethnicity_first) -- do the custom mapping
        AND vc.domain_id IN ('Race', 'Ethnicity')
LEFT JOIN
    {{ ref("stg__voc_concept_relationship") }} cr1
        ON cr1.concept_id_1 = vc.concept_id
        AND cr1.relationship_id = 'Maps to'
LEFT JOIN
    {{ ref("stg__voc_concept") }} vc1
        ON cr1.concept_id_2 = vc1.concept_id
        AND vc1.invalid_reason IS NULL
        AND vc1.standard_concept = 'S'
