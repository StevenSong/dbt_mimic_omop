SELECT
    src.careunit              AS source_code,
    src.load_table_id         AS load_table_id,
    0                         AS load_row_id,
    MIN(src.trace_id)         AS trace_id
FROM 
    {{ ref("stg__transfers") }} AS src
WHERE
    src.careunit IS NOT NULL
GROUP BY
    src.careunit,
    src.load_table_id