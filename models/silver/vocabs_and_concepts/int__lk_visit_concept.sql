SELECT 
    vc.concept_code AS source_code,
    vc.concept_id AS source_concept_id,
    vc2.concept_id AS target_concept_id,
    vc.vocabulary_id AS source_vocabulary_id
FROM 
    {{ ref("stg__voc_concept")}} AS vc
LEFT JOIN
    {{ ref("stg__voc_concept_relationship")}} AS vcr
    ON vc.concept_id = vcr.concept_id_1 
    AND vcr.relationship_id = 'Maps to'
LEFT JOIN
    {{ ref("stg__voc_concept")}} AS vc2
    ON vc2.concept_id = vcr.concept_id_2
    AND vc2.standard_concept = 'S'
    AND vc2.invalid_reason IS NULL
WHERE
    vc.vocabulary_id IN (
        'mimiciv_vis_admission_location',   -- for admission_location_concept_id (visit and visit_detail)
        'mimiciv_vis_discharge_location',   -- for discharge_location_concept_id 
        'mimiciv_vis_service',              -- for admission_location_concept_id (visit_detail)
                                            -- and for discharge_location_concept_id
        'mimiciv_vis_admission_type',       -- for visit_concept_id
        'mimiciv_cs_place_of_service'       -- for visit_detail_concept_id
    )