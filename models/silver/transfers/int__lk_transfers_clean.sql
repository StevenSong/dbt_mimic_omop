SELECT
    src.subject_id AS subject_id,
    COALESCE(src.hadm_id, vis.hadm_id) AS hadm_id,
    CAST(src.intime AS DATE) AS date_id,
    src.transfer_id AS transfer_id,
    src.intime AS start_datetime,
    src.outtime AS end_datetime,
    src.careunit AS current_location, -- find prev and next for adm and disch location
    COALESCE(pro.admit_provider_id, vis.admit_provider_id) AS provider_id,
    --
    'transfers' AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{ ref("stg__transfers") }} AS src
LEFT JOIN
    {{ ref("int__lk_admissions_clean") }} AS vis -- associate transfers with admissions according to 
        ON vis.subject_id = src.subject_id
        AND src.intime BETWEEN vis.start_datetime AND vis.end_datetime
        AND src.hadm_id IS NULL
LEFT JOIN
    {{ ref("int__lk_admissions_clean") }} AS pro
        ON src.hadm_id = pro.hadm_id
        AND src.hadm_id IS NOT NULL
WHERE
    src.eventtype != 'discharge' -- these are not useful