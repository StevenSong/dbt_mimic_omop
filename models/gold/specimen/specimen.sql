SELECT
    src.specimen_id AS specimen_id,
    per.person_id AS person_id,
    COALESCE(src.target_concept_id, 0) AS specimen_concept_id,
    32856 AS specimen_type_concept_id, -- OMOP4976929 Lab
    CAST(src.start_datetime AS DATE) AS specimen_date,
    src.start_datetime AS specimen_datetime,
    NULL AS quantity,
    NULL AS unit_concept_id,
    0 AS anatomic_site_concept_id,
    0 AS disease_status_concept_id,
    src.trace_id AS specimen_source_id,
    src.source_code AS specimen_source_value,
    NULL AS unit_source_value,
    NULL AS anatomic_site_source_value,
    NULL AS disease_status_source_value,
    --
    CONCAT('specimen.', src.unit_id) AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{ ref("int__lk_specimen_mapped") }} AS src
INNER JOIN
    {{ ref("person") }} AS per
        ON CAST(src.subject_id AS TEXT) = per.person_source_value
WHERE
    src.target_domain_id = 'Specimen'