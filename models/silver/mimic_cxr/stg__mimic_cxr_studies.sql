-- Staging model for MIMIC-CXR study records
-- Maps DICOM ID -> Study ID -> Subject ID
-- Uses the split file which contains the mapping plus train/validate/test splits
-- Source: https://physionet.org/content/mimic-cxr-jpg/2.1.0/

{{
    config(
        enabled=var('build_cxr'),
        tags=['mimic_cxr']
    )
}}

SELECT
    dicom_id::VARCHAR                   AS dicom_id,
    study_id::BIGINT                    AS study_id,
    subject_id::BIGINT                  AS subject_id,
    split::VARCHAR                      AS data_split,  -- 'train', 'validate', or 'test'
    -- Traceability columns
    'mimic_cxr_split'                   AS load_table_id,
    {{ omop_id("dicom_id") }}                      AS load_row_id,
    json_object(
        'dicom_id', dicom_id,
        'study_id', study_id,
        'subject_id', subject_id
    )::TEXT                             AS trace_id
FROM {{ source("mimic_cxr", "mimic_cxr_split") }}
