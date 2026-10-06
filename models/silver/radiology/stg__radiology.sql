{{ config(enabled=var('build_note')) }}

SELECT
    note_id AS note_id,
    subject_id AS subject_id,
    hadm_id AS hamd_id,
    note_type AS note_type,
    note_seq AS note_seq,
    charttime AS charttime,
    storetime AS storetime,
    text AS text,
    'radiology' AS load_table_id,
    {{ omop_id("note_id, subject_id, hadm_id, note_type, note_seq") }} AS load_row_id,
    json_object('subject_id', subject_id, 'hadm_id', hadm_id, 'note_type', note_type, 'note_seq', note_seq)::text AS trace_id
FROM
    {{ source('mimic', 'radiology') }}