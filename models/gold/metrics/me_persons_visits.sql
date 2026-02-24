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

ORDER BY category, name
