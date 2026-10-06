SELECT
    itemid                              AS itemid,
    label                               AS label,
    linksto                             AS linksto,
    'd_items'                           AS load_table_id,
    {{ omop_id("itemid, linksto") }}               AS load_row_id,
    json_object('itemid', itemid, 
    'linksto', linksto)::text           AS trace_id
FROM
    {{ source("mimic", "d_items") }}