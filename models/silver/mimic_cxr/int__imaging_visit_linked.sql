-- Intermediate model: Link CXR studies to OMOP visit_occurrence
-- Uses subject_id + temporal alignment (study_date within visit dates)
-- This is the critical join for connecting imaging to clinical data

{{
    config(
        materialized='table',
        tags=['mimic_cxr']
    )
}}

WITH cxr_studies AS (
    -- Get unique studies with metadata
    SELECT DISTINCT
        s.dicom_id,
        s.study_id,
        s.subject_id,
        s.data_split,
        m.study_date,
        m.study_time,
        m.view_position,
        m.image_rows,
        m.image_columns,
        m.modality,
        m.body_part_examined,
        m.procedure_description,
        m.view_code_meaning,
        m.patient_orientation
    FROM {{ ref("stg__mimic_cxr_studies") }} s
    LEFT JOIN {{ ref("stg__mimic_cxr_metadata") }} m
        ON s.dicom_id = m.dicom_id
),

person_lookup AS (
    -- Get person_id from person table using subject_id
    SELECT
        person_id,
        CAST(person_source_value AS BIGINT) AS subject_id
    FROM {{ ref("person") }}
)

SELECT
    cxr.dicom_id,
    cxr.study_id,
    cxr.subject_id,
    cxr.data_split,
    p.person_id,
    vo.visit_occurrence_id,
    cxr.study_date,
    cxr.study_time,
    cxr.view_position,
    cxr.image_rows,
    cxr.image_columns,
    cxr.modality,
    cxr.body_part_examined,
    cxr.procedure_description,
    cxr.view_code_meaning,
    cxr.patient_orientation,
    -- Build local file path as it exists on omop-mimic node
    -- Agent connects to omop-mimic and uses this path directly
    '/home/ubuntu/mimic-cxr/physionet.org/files/mimic-cxr-jpg/2.1.0/files/p' || SUBSTR(cxr.subject_id::TEXT, 1, 2) || 
    '/p' || cxr.subject_id::TEXT || 
    '/s' || cxr.study_id::TEXT || 
    '/' || cxr.dicom_id || '.jpg' AS local_path,
    -- GCS URI as fallback for cloud access
    'gs://mimic-cxr-jpg-2.1.0.physionet.org/files/p' || 
    SUBSTR(cxr.subject_id::TEXT, 1, 2) || 
    '/p' || cxr.subject_id::TEXT || 
    '/s' || cxr.study_id::TEXT || 
    '/' || cxr.dicom_id || '.jpg' AS wadors_uri,
    -- Flag if successfully linked to a visit
    CASE WHEN vo.visit_occurrence_id IS NOT NULL THEN 1 ELSE 0 END AS visit_linked_flag
FROM cxr_studies cxr
INNER JOIN person_lookup p
    ON cxr.subject_id = p.subject_id
LEFT JOIN {{ ref("visit_occurrence") }} vo
    ON p.person_id = vo.person_id
    AND cxr.study_date BETWEEN vo.visit_start_date AND vo.visit_end_date
