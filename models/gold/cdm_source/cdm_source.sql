SELECT
    'MIMIC IV' AS cdm_source_name,
    'mimiciv' AS cdm_source_abbreviation,
    'PhysioNet' AS cdm_holder,          
    CONCAT('MIMIC-IV is a publicly available database of patients ',
        'admitted to the Beth Israel Deaconess Medical Center in Boston, MA, USA.') AS source_description,
    'https://mimic-iv.mit.edu/docs/' AS source_documentation_reference,
    'https://github.com/CogStack/dbt_mimic_omop' AS cdm_etl_reference,
    '2024-10-11'::DATE AS source_release_date, -- MIMIC-IV v3.1 publication date on PhysioNet
    CURRENT_DATE AS cdm_release_date,
    '5.4' AS cdm_version,
    705800 AS cdm_version_concept_id,
    v.vocabulary_version AS vocabulary_version
FROM 
    {{ ref('stg__voc_vocabulary') }} AS v
WHERE
    v.vocabulary_id = 'None'