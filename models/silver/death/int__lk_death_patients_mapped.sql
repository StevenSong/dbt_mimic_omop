SELECT DISTINCT
    src.subject_id,
    src.dod AS deathtime,
    CAST(NULL AS TIMESTAMP) AS dischtime,
    32815 AS type_concept_id, -- "OMOP4976888" Death Certificate
    --
    'patients' AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{  ref("stg__patients")  }} AS src
WHERE 
    src.dod IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM {{  ref("stg__admissions")  }} AS adm
            WHERE adm.subject_id = src.subject_id
              AND adm.deathtime IS NOT NULL
        )