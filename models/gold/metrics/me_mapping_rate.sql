-- me_mapping_rate: Concept mapping coverage rates for OMOP CDM tables
-- For each concept_id field, calculates:
-- - count: Number of records with valid mapping (concept_id > 0)
-- - percent: Percentage of records mapped
-- - total: Total number of records

-- Person table
SELECT
    'person' AS table_name,
    'gender_concept_id' AS concept_field,
    COUNT(CASE WHEN gender_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN gender_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('person') }}
WHERE gender_concept_id IS NOT NULL

UNION ALL

SELECT
    'person' AS table_name,
    'race_concept_id' AS concept_field,
    COUNT(CASE WHEN race_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN race_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('person') }}
WHERE race_concept_id IS NOT NULL

UNION ALL

SELECT
    'person' AS table_name,
    'ethnicity_concept_id' AS concept_field,
    COUNT(CASE WHEN ethnicity_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN ethnicity_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('person') }}
WHERE ethnicity_concept_id IS NOT NULL

UNION ALL

-- Death table
SELECT
    'death' AS table_name,
    'death_type_concept_id' AS concept_field,
    COUNT(CASE WHEN death_type_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN death_type_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('death') }}
WHERE death_type_concept_id IS NOT NULL

UNION ALL

SELECT
    'death' AS table_name,
    'cause_concept_id' AS concept_field,
    COUNT(CASE WHEN cause_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN cause_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('death') }}
WHERE cause_concept_id IS NOT NULL

UNION ALL

-- Observation Period table
SELECT
    'observation_period' AS table_name,
    'period_type_concept_id' AS concept_field,
    COUNT(CASE WHEN period_type_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN period_type_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('observation_period') }}
WHERE period_type_concept_id IS NOT NULL

UNION ALL

-- Visit Occurrence table
SELECT
    'visit_occurrence' AS table_name,
    'visit_concept_id' AS concept_field,
    COUNT(CASE WHEN visit_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN visit_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('visit_occurrence') }}
WHERE visit_concept_id IS NOT NULL

UNION ALL

SELECT
    'visit_occurrence' AS table_name,
    'visit_type_concept_id' AS concept_field,
    COUNT(CASE WHEN visit_type_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN visit_type_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('visit_occurrence') }}
WHERE visit_type_concept_id IS NOT NULL

UNION ALL

SELECT
    'visit_occurrence' AS table_name,
    'visit_source_concept_id' AS concept_field,
    COUNT(CASE WHEN visit_source_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN visit_source_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('visit_occurrence') }}
WHERE visit_source_concept_id IS NOT NULL

UNION ALL

SELECT
    'visit_occurrence' AS table_name,
    'admitted_from_concept_id' AS concept_field,
    COUNT(CASE WHEN admitted_from_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN admitted_from_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('visit_occurrence') }}
WHERE admitted_from_concept_id IS NOT NULL

UNION ALL

SELECT
    'visit_occurrence' AS table_name,
    'discharged_to_concept_id' AS concept_field,
    COUNT(CASE WHEN discharged_to_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN discharged_to_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('visit_occurrence') }}
WHERE discharged_to_concept_id IS NOT NULL

UNION ALL

-- Visit Detail table
SELECT
    'visit_detail' AS table_name,
    'visit_detail_concept_id' AS concept_field,
    COUNT(CASE WHEN visit_detail_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN visit_detail_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('visit_detail') }}
WHERE visit_detail_concept_id IS NOT NULL

UNION ALL

SELECT
    'visit_detail' AS table_name,
    'visit_detail_type_concept_id' AS concept_field,
    COUNT(CASE WHEN visit_detail_type_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN visit_detail_type_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('visit_detail') }}
WHERE visit_detail_type_concept_id IS NOT NULL

UNION ALL

-- Condition Occurrence table
SELECT
    'condition_occurrence' AS table_name,
    'condition_concept_id' AS concept_field,
    COUNT(CASE WHEN condition_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN condition_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('condition_occurrence') }}
WHERE condition_concept_id IS NOT NULL

UNION ALL

SELECT
    'condition_occurrence' AS table_name,
    'condition_type_concept_id' AS concept_field,
    COUNT(CASE WHEN condition_type_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN condition_type_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('condition_occurrence') }}
WHERE condition_type_concept_id IS NOT NULL

UNION ALL

SELECT
    'condition_occurrence' AS table_name,
    'condition_source_concept_id' AS concept_field,
    COUNT(CASE WHEN condition_source_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN condition_source_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('condition_occurrence') }}
WHERE condition_source_concept_id IS NOT NULL

UNION ALL

-- Procedure Occurrence table
SELECT
    'procedure_occurrence' AS table_name,
    'procedure_concept_id' AS concept_field,
    COUNT(CASE WHEN procedure_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN procedure_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('procedure_occurrence') }}
WHERE procedure_concept_id IS NOT NULL

UNION ALL

SELECT
    'procedure_occurrence' AS table_name,
    'procedure_type_concept_id' AS concept_field,
    COUNT(CASE WHEN procedure_type_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN procedure_type_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('procedure_occurrence') }}
WHERE procedure_type_concept_id IS NOT NULL

UNION ALL

-- Observation table
SELECT
    'observation' AS table_name,
    'observation_concept_id' AS concept_field,
    COUNT(CASE WHEN observation_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN observation_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('observation') }}
WHERE observation_concept_id IS NOT NULL

UNION ALL

SELECT
    'observation' AS table_name,
    'observation_type_concept_id' AS concept_field,
    COUNT(CASE WHEN observation_type_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN observation_type_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('observation') }}
WHERE observation_type_concept_id IS NOT NULL

UNION ALL

SELECT
    'observation' AS table_name,
    'value_as_concept_id' AS concept_field,
    COUNT(CASE WHEN value_as_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN value_as_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('observation') }}
WHERE value_as_concept_id IS NOT NULL

UNION ALL

SELECT
    'observation' AS table_name,
    'unit_concept_id' AS concept_field,
    COUNT(CASE WHEN unit_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN unit_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('observation') }}
WHERE unit_concept_id IS NOT NULL

UNION ALL

-- Measurement table
SELECT
    'measurement' AS table_name,
    'measurement_concept_id' AS concept_field,
    COUNT(CASE WHEN measurement_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN measurement_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('measurement') }}
WHERE measurement_concept_id IS NOT NULL

UNION ALL

SELECT
    'measurement' AS table_name,
    'measurement_type_concept_id' AS concept_field,
    COUNT(CASE WHEN measurement_type_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN measurement_type_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('measurement') }}
WHERE measurement_type_concept_id IS NOT NULL

UNION ALL

SELECT
    'measurement' AS table_name,
    'operator_concept_id' AS concept_field,
    COUNT(CASE WHEN operator_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN operator_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('measurement') }}
WHERE operator_concept_id IS NOT NULL

UNION ALL

SELECT
    'measurement' AS table_name,
    'value_as_concept_id' AS concept_field,
    COUNT(CASE WHEN value_as_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN value_as_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('measurement') }}
WHERE value_as_concept_id IS NOT NULL

UNION ALL

SELECT
    'measurement' AS table_name,
    'unit_concept_id' AS concept_field,
    COUNT(CASE WHEN unit_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN unit_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('measurement') }}
WHERE unit_concept_id IS NOT NULL

UNION ALL

-- Device Exposure table
SELECT
    'device_exposure' AS table_name,
    'device_concept_id' AS concept_field,
    COUNT(CASE WHEN device_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN device_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('device_exposure') }}
WHERE device_concept_id IS NOT NULL

UNION ALL

SELECT
    'device_exposure' AS table_name,
    'device_type_concept_id' AS concept_field,
    COUNT(CASE WHEN device_type_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN device_type_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('device_exposure') }}
WHERE device_type_concept_id IS NOT NULL

UNION ALL

-- Drug Exposure table
SELECT
    'drug_exposure' AS table_name,
    'drug_concept_id' AS concept_field,
    COUNT(CASE WHEN drug_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN drug_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('drug_exposure') }}
WHERE drug_concept_id IS NOT NULL

UNION ALL

SELECT
    'drug_exposure' AS table_name,
    'drug_type_concept_id' AS concept_field,
    COUNT(CASE WHEN drug_type_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN drug_type_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('drug_exposure') }}
WHERE drug_type_concept_id IS NOT NULL

UNION ALL

SELECT
    'drug_exposure' AS table_name,
    'route_concept_id' AS concept_field,
    COUNT(CASE WHEN route_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN route_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('drug_exposure') }}
WHERE route_concept_id IS NOT NULL

UNION ALL

-- Condition Era table
SELECT
    'condition_era' AS table_name,
    'condition_concept_id' AS concept_field,
    COUNT(CASE WHEN condition_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN condition_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('condition_era') }}
WHERE condition_concept_id IS NOT NULL

UNION ALL

-- Drug Era table
SELECT
    'drug_era' AS table_name,
    'drug_concept_id' AS concept_field,
    COUNT(CASE WHEN drug_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN drug_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('drug_era') }}
WHERE drug_concept_id IS NOT NULL

UNION ALL

-- Dose Era table
SELECT
    'dose_era' AS table_name,
    'drug_concept_id' AS concept_field,
    COUNT(CASE WHEN drug_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN drug_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('dose_era') }}
WHERE drug_concept_id IS NOT NULL

UNION ALL

SELECT
    'dose_era' AS table_name,
    'unit_concept_id' AS concept_field,
    COUNT(CASE WHEN unit_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN unit_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('dose_era') }}
WHERE unit_concept_id IS NOT NULL

UNION ALL

-- Specimen table
SELECT
    'specimen' AS table_name,
    'specimen_concept_id' AS concept_field,
    COUNT(CASE WHEN specimen_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN specimen_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('specimen') }}
WHERE specimen_concept_id IS NOT NULL

UNION ALL

SELECT
    'specimen' AS table_name,
    'specimen_type_concept_id' AS concept_field,
    COUNT(CASE WHEN specimen_type_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN specimen_type_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('specimen') }}
WHERE specimen_type_concept_id IS NOT NULL

UNION ALL

SELECT
    'specimen' AS table_name,
    'unit_concept_id' AS concept_field,
    COUNT(CASE WHEN unit_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN unit_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('specimen') }}
WHERE unit_concept_id IS NOT NULL

UNION ALL

SELECT
    'specimen' AS table_name,
    'anatomic_site_concept_id' AS concept_field,
    COUNT(CASE WHEN anatomic_site_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN anatomic_site_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('specimen') }}
WHERE anatomic_site_concept_id IS NOT NULL

UNION ALL

SELECT
    'specimen' AS table_name,
    'disease_status_concept_id' AS concept_field,
    COUNT(CASE WHEN disease_status_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN disease_status_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('specimen') }}
WHERE disease_status_concept_id IS NOT NULL

UNION ALL

-- Note table
SELECT
    'note' AS table_name,
    'note_type_concept_id' AS concept_field,
    COUNT(CASE WHEN note_type_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN note_type_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('note') }}
WHERE note_type_concept_id IS NOT NULL

UNION ALL

SELECT
    'note' AS table_name,
    'note_class_concept_id' AS concept_field,
    COUNT(CASE WHEN note_class_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN note_class_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('note') }}
WHERE note_class_concept_id IS NOT NULL

UNION ALL

SELECT
    'note' AS table_name,
    'encoding_concept_id' AS concept_field,
    COUNT(CASE WHEN encoding_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN encoding_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('note') }}
WHERE encoding_concept_id IS NOT NULL

UNION ALL

SELECT
    'note' AS table_name,
    'language_concept_id' AS concept_field,
    COUNT(CASE WHEN language_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN language_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('note') }}
WHERE language_concept_id IS NOT NULL

UNION ALL

-- Note NLP table
SELECT
    'note_nlp' AS table_name,
    'section_concept_id' AS concept_field,
    COUNT(CASE WHEN section_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN section_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('note_nlp') }}
WHERE section_concept_id IS NOT NULL

UNION ALL

SELECT
    'note_nlp' AS table_name,
    'note_nlp_concept_id' AS concept_field,
    COUNT(CASE WHEN note_nlp_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN note_nlp_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('note_nlp') }}
WHERE note_nlp_concept_id IS NOT NULL

UNION ALL

-- Fact Relationship table
SELECT
    'fact_relationship' AS table_name,
    'domain_concept_id_1' AS concept_field,
    COUNT(CASE WHEN domain_concept_id_1 > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN domain_concept_id_1 > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('fact_relationship') }}
WHERE domain_concept_id_1 IS NOT NULL

UNION ALL

SELECT
    'fact_relationship' AS table_name,
    'domain_concept_id_2' AS concept_field,
    COUNT(CASE WHEN domain_concept_id_2 > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN domain_concept_id_2 > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('fact_relationship') }}
WHERE domain_concept_id_2 IS NOT NULL

UNION ALL

SELECT
    'fact_relationship' AS table_name,
    'relationship_concept_id' AS concept_field,
    COUNT(CASE WHEN relationship_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN relationship_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('fact_relationship') }}
WHERE relationship_concept_id IS NOT NULL

UNION ALL

-- Provider table
SELECT
    'provider' AS table_name,
    'specialty_concept_id' AS concept_field,
    COUNT(CASE WHEN specialty_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN specialty_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('provider') }}
WHERE specialty_concept_id IS NOT NULL

UNION ALL

SELECT
    'provider' AS table_name,
    'gender_concept_id' AS concept_field,
    COUNT(CASE WHEN gender_concept_id > 0 THEN 1 END) AS count,
    COALESCE(ROUND(100.0 * COUNT(CASE WHEN gender_concept_id > 0 THEN 1 END) / NULLIF(COUNT(*), 0), 2), 0) AS percent,
    COUNT(*) AS total
FROM {{ ref('provider') }}
WHERE gender_concept_id IS NOT NULL

ORDER BY table_name, concept_field
