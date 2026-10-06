SELECT
    pharmacy_id                         AS pharmacy_id,
    medication                          AS medication,
    'pharmacy'                          AS load_table_id,
    {{ omop_id("pharmacy_id") }}                   AS load_row_id,
    json_object('pharmacy_id', pharmacy_id)::text AS trace_id
FROM
    {{ source('mimic', 'pharmacy') }}