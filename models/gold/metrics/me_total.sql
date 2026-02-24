-- me_total: Total record counts for each OMOP CDM table
-- Provides an overview of the dataset size

SELECT 'care_site' AS table_name, COUNT(*) AS count FROM {{ ref('care_site') }}
UNION ALL
SELECT 'person' AS table_name, COUNT(*) AS count FROM {{ ref('person') }}
UNION ALL
SELECT 'death' AS table_name, COUNT(*) AS count FROM {{ ref('death') }}
UNION ALL
SELECT 'observation_period' AS table_name, COUNT(*) AS count FROM {{ ref('observation_period') }}
UNION ALL
SELECT 'visit_occurrence' AS table_name, COUNT(*) AS count FROM {{ ref('visit_occurrence') }}
UNION ALL
SELECT 'visit_detail' AS table_name, COUNT(*) AS count FROM {{ ref('visit_detail') }}
UNION ALL
SELECT 'condition_occurrence' AS table_name, COUNT(*) AS count FROM {{ ref('condition_occurrence') }}
UNION ALL
SELECT 'procedure_occurrence' AS table_name, COUNT(*) AS count FROM {{ ref('procedure_occurrence') }}
UNION ALL
SELECT 'observation' AS table_name, COUNT(*) AS count FROM {{ ref('observation') }}
UNION ALL
SELECT 'measurement' AS table_name, COUNT(*) AS count FROM {{ ref('measurement') }}
UNION ALL
SELECT 'device_exposure' AS table_name, COUNT(*) AS count FROM {{ ref('device_exposure') }}
UNION ALL
SELECT 'drug_exposure' AS table_name, COUNT(*) AS count FROM {{ ref('drug_exposure') }}
UNION ALL
SELECT 'condition_era' AS table_name, COUNT(*) AS count FROM {{ ref('condition_era') }}
UNION ALL
SELECT 'drug_era' AS table_name, COUNT(*) AS count FROM {{ ref('drug_era') }}
UNION ALL
SELECT 'dose_era' AS table_name, COUNT(*) AS count FROM {{ ref('dose_era') }}
UNION ALL
SELECT 'specimen' AS table_name, COUNT(*) AS count FROM {{ ref('specimen') }}
UNION ALL
SELECT 'note' AS table_name, COUNT(*) AS count FROM {{ ref('note') }}
UNION ALL
SELECT 'note_nlp' AS table_name, COUNT(*) AS count FROM {{ ref('note_nlp') }}
UNION ALL
SELECT 'fact_relationship' AS table_name, COUNT(*) AS count FROM {{ ref('fact_relationship') }}
UNION ALL
SELECT 'provider' AS table_name, COUNT(*) AS count FROM {{ ref('provider') }}
UNION ALL
SELECT 'location' AS table_name, COUNT(*) AS count FROM {{ ref('location') }}
UNION ALL
SELECT 'cdm_source' AS table_name, COUNT(*) AS count FROM {{ ref('cdm_source') }}
ORDER BY table_name
