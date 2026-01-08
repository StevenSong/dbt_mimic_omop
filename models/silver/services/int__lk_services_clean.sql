with lk_services_duplicated as 
(
    SELECT
        trace_id, COUNT(*) AS row_count
    FROM 
        {{ ref("stg__services" ) }} src
    GROUP BY
        src.trace_id
    HAVING COUNT(*) > 1
)

SELECT
    src.subject_id AS subject_id,
    src.hadm_id AS hadm_id,
    src.transfertime AS start_datetime,
    LEAD(src.transfertime) OVER (
        PARTITION BY src.subject_id, src.hadm_id
        ORDER BY src.transfertime
    ) AS end_datetime,
    src.curr_service AS curr_service,
    src.prev_service AS prev_service,
    LAG(src.curr_service) OVER (
        PARTITION BY src.subject_id, src.hadm_id 
        ORDER BY src.transfertime
    ) AS lag_service, -- to double-check that the services sequence is still consistent
    pro.admit_provider_id AS provider_id,
    --
    'services' AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM 
    {{ ref("stg__services" ) }} AS src
LEFT JOIN
    lk_services_duplicated AS sd
        ON src.trace_id = sd.trace_id
LEFT JOIN
    {{ ref("int__lk_admissions_clean") }} AS pro
        ON src.hadm_id = pro.hadm_id
WHERE
    sd.trace_id IS NULL -- remove duplicates with the exact same time of transferring