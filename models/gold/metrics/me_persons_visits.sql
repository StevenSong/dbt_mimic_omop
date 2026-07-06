-- me_persons_visits: Person and visit statistics for OMOP CDM
-- Provides demographic breakdowns and visit summaries

-- Number of persons - Total
SELECT 
    'Number of persons' AS category, 
    'Total' AS name, 
    COUNT(*) AS count
FROM {{ ref('person') }}

UNION ALL

-- Number of persons by Race
SELECT 
    'Number of persons by Race' AS category, 
    COALESCE(vc.concept_name, 'Unknown/Unmapped') AS name, 
    COUNT(*) AS count
FROM {{ ref('person') }} per
LEFT JOIN {{ ref('stg__voc_concept') }} vc
    ON per.race_concept_id = vc.concept_id
GROUP BY vc.concept_name

UNION ALL

-- Number of persons by Ethnicity
SELECT 
    'Number of persons by Ethnicity' AS category, 
    COALESCE(vc.concept_name, 'Unknown/Unmapped') AS name, 
    COUNT(*) AS count
FROM {{ ref('person') }} per
LEFT JOIN {{ ref('stg__voc_concept') }} vc
    ON per.ethnicity_concept_id = vc.concept_id
GROUP BY vc.concept_name

UNION ALL

-- Number of persons by Gender
SELECT 
    'Number of persons by Gender' AS category, 
    COALESCE(vc.concept_name, 'Unknown/Unmapped') AS name, 
    COUNT(*) AS count
FROM {{ ref('person') }} per
LEFT JOIN {{ ref('stg__voc_concept') }} vc
    ON per.gender_concept_id = vc.concept_id
GROUP BY vc.concept_name

UNION ALL

-- Number of visits - Total
SELECT 
    'Number of visits' AS category, 
    'Total' AS name, 
    COUNT(*) AS count
FROM {{ ref('visit_occurrence') }}

UNION ALL

-- Number of visits by visit_concept_id
SELECT 
    'Number of visits by visit_concept_id' AS category, 
    COALESCE(vc.concept_name, 'Unknown/Unmapped') AS name, 
    COUNT(*) AS count
FROM {{ ref('visit_occurrence') }} vis
LEFT JOIN {{ ref('stg__voc_concept') }} vc
    ON vis.visit_concept_id = vc.concept_id
GROUP BY vc.concept_name

UNION ALL

-- Number of visit details - Total
SELECT 
    'Number of visit details' AS category, 
    'Total' AS name, 
    COUNT(*) AS count
FROM {{ ref('visit_detail') }}

UNION ALL

-- Number of visit details by visit_detail_concept_id
SELECT 
    'Number of visit details by visit_detail_concept_id' AS category, 
    COALESCE(vc.concept_name, 'Unknown/Unmapped') AS name, 
    COUNT(*) AS count
FROM {{ ref('visit_detail') }} vd
LEFT JOIN {{ ref('stg__voc_concept') }} vc
    ON vd.visit_detail_concept_id = vc.concept_id
GROUP BY vc.concept_name

UNION ALL

-- Number of deaths
SELECT 
    'Number of deaths' AS category, 
    'Total' AS name, 
    COUNT(*) AS count
FROM {{ ref('death') }}

UNION ALL

-- Number of observation periods
SELECT 
    'Number of observation periods' AS category, 
    'Total' AS name, 
    COUNT(*) AS count
FROM {{ ref('observation_period') }}

UNION ALL

-- Average observation period length in days
SELECT 
    'Observation period length (days)' AS category, 
    'Average' AS name, 
    ROUND(AVG(observation_period_end_date - observation_period_start_date), 1) AS count
FROM {{ ref('observation_period') }}

UNION ALL

-- Number of images - Total
SELECT
    'Number of images' AS category,
    'Total' AS name,
    COUNT(*) AS count
FROM {{ ref('image_occurrence') }}

UNION ALL

-- Number of images by view position
SELECT
    'Number of images by view_position' AS category,
    COALESCE(view_position, 'Unknown') AS name,
    COUNT(*) AS count
FROM {{ ref('image_occurrence') }}
GROUP BY view_position

UNION ALL

-- Number of images by modality
SELECT
    'Number of images by modality' AS category,
    COALESCE(modality_source_value, 'Unknown') AS name,
    COUNT(*) AS count
FROM {{ ref('image_occurrence') }}
GROUP BY modality_source_value

UNION ALL

-- Number of images linked to visits
SELECT
    'Number of images linked to visits' AS category,
    'Total' AS name,
    COUNT(*) AS count
FROM {{ ref('image_occurrence') }}
WHERE visit_occurrence_id IS NOT NULL

UNION ALL

-- Number of image features - Total
SELECT
    'Number of image features' AS category,
    'Total' AS name,
    COUNT(*) AS count
FROM {{ ref('image_feature') }}

UNION ALL

-- Number of image features by finding
SELECT
    'Number of image features by finding' AS category,
    COALESCE(feature_source_value, 'Unknown') AS name,
    COUNT(*) AS count
FROM {{ ref('image_feature') }}
GROUP BY feature_source_value

UNION ALL

-- Number of image features by value interpretation
SELECT
    'Number of image features by interpretation' AS category,
    value_as_concept_name AS name,
    COUNT(*) AS count
FROM {{ ref('image_feature') }}
GROUP BY value_as_concept_name

ORDER BY category, name
