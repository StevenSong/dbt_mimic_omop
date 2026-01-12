with admissions_death as (
SELECT
    per.person_id AS person_id,
    CAST(
        CASE 
            WHEN src.deathtime <= src.dischtime THEN src.deathtime 
            ELSE src.dischtime 
        END AS DATE
    ) AS death_date,
    CASE 
        WHEN src.deathtime <= src.dischtime THEN src.deathtime 
        ELSE src.dischtime 
    END AS death_datetime,
    src.type_concept_id AS death_type_concept_id,
    0 AS cause_concept_id,
    NULL AS cause_source_value,
    0 AS cause_source_concept_id,
    --
    CONCAT('death.', src.unit_id) AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{  ref("int__lk_death_adm_mapped")  }} src
INNER JOIN
    {{  ref("cdm_person")  }} AS per
        ON CAST(src.subject_id AS TEXT) = per.person_source_value
),

patients_death AS (
    SELECT
    per.person_id AS person_id,
    src.deathtime AS death_date,
    NULL AS death_datetime,
    src.type_concept_id AS death_type_concept_id,
    0 AS cause_concept_id,
    NULL AS cause_source_value,
    0 AS cause_source_concept_id,
    --
    CONCAT('death.', src.unit_id) AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
      {{  ref("int__lk_death_patients_mapped")  }} AS src
INNER JOIN
    {{  ref("cdm_person")  }} AS per
        ON CAST(src.subject_id AS TEXT) = per.person_source_value
)

SELECT * FROM admissions_death
UNION ALL
SELECT * FROM patients_death