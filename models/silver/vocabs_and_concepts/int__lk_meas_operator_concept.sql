SELECT
    vc.concept_name AS source_code, -- operator_name
    vc.concept_id AS target_concept_id -- operator_concept_id
FROM
    {{ ref("stg__voc_concept") }} AS vc
WHERE
    vc.domain_id = 'Meas Value Operator'