WITH notes_src AS (

    SELECT
        note_id,
        subject_id,
        hamd_id,
        charttime,
        text,
        706531 AS note_class_concept_id,
        'DISCHARGE SUMMARY' AS note_title,
        'Discharge summary' AS note_source_value
    FROM {{ ref('stg__discharge') }}

    UNION ALL

    SELECT
        note_id,
        subject_id,
        hamd_id,
        charttime,
        text,
        706371 AS note_class_concept_id,
        'RADIOLOGY REPORT' AS note_title,
        'Report' AS note_source_value
    FROM {{ ref('stg__radiology') }}

)

SELECT
    src.note_id AS note_id,
    per.person_id AS person_id,
    src.charttime::date AS note_date,
    src.charttime AS note_datetime,
    32817 AS note_type_concept_id,
    src.note_class_concept_id AS note_class_concept_id,
    src.note_title AS note_title,
    src.text AS note_text,
    32766 AS encoding_concept_id,
    4180186 AS language_concept_id,
    NULL AS provider_id,
    vo.visit_occurrence_id AS visit_occurrence_id,
    vd.visit_detail_id AS visit_detail_id,
    src.note_source_value AS note_source_value,
    NULL AS note_event_id,
    NULL AS note_event_field_concept_id
FROM
    notes_src AS src
LEFT JOIN
    {{ ref('person') }} AS per
        ON src.subject_id::text = per.person_source_value
LEFT JOIN
    {{ ref('visit_occurrence') }} AS vo
        ON src.hamd_id::text = split_part(vo.visit_source_value, '|', 2)
LEFT JOIN
    {{ ref('visit_detail') }} AS vd
        ON vo.visit_occurrence_id = vd.visit_occurrence_id
