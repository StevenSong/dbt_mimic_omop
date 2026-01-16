with lk_hcpcsevents_clean AS (
SELECT
    src.subject_id AS subject_id,
    src.hadm_id AS hadm_id,
    adm.dischtime AS start_datetime,
    src.seq_num AS seq_num, --- procedure_type as in condtion_occurrence
    src.hcpcs_cd AS hcpcs_cd,
    src.short_description AS short_description,
    adm.admit_provider_id AS provider_id,
    --
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{  ref("stg__hcpcsevents")}} AS src
INNER JOIN
    {{ ref("stg__admissions")}} AS adm
        ON src.hadm_id = adm.hadm_id
),

lk_procedures_icd_clean AS (
SELECT
    src.subject_id AS subject_id,
    src.hadm_id AS hadm_id,
    adm.dischtime AS start_datetime,
    src.icd_code AS icd_code,
    src.icd_version AS icd_version,
    CASE
        WHEN src.icd_version = 9 THEN 'ICD9Proc'
        WHEN src.icd_version = 10 THEN 'ICD10PCS'
        ELSE 'Unknown'
    END AS source_vocabulary_id,
    REPLACE(src.icd_code, '.', '') AS source_code, -- to join lk_icd_proc_concept
    adm.admit_provider_id AS provider_id,
    --
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{ ref("stg__procedures_icd")}} AS src
INNER JOIN
    {{ ref("stg__admissions")}} AS adm
        ON src.hadm_id = adm.hadm_id
),

lk_hcpcs_concept AS (
SELECT
    vc.concept_code AS source_code,
    vc.vocabulary_id AS source_vocabulary_id,
    vc.domain_id AS source_domain_id,
    vc.concept_id AS source_concept_id,
    vc2.domain_id AS target_domain_id,
    vc2.concept_id AS target_concept_id
FROM
    {{ ref("stg__voc_concept") }} AS vc
LEFT JOIN
    {{ ref("stg__voc_concept_relationship") }} AS vcr
        ON vc.concept_id = vcr.concept_id_1
        AND vcr.relationship_id = 'Maps to'
LEFT JOIN
    {{ ref("stg__voc_concept") }} AS vc2
        ON vc2.concept_id = vcr.concept_id_2
        AND vc2.standard_concept = 'S'
        AND vc2.invalid_reason IS NULL
WHERE
    vc.vocabulary_id IN ('HCPCS', 'CPT4')
),

lk_icd_proc_concept AS (
SELECT
    REPLACE(vc.concept_code, '.', '') AS source_code,
    vc.vocabulary_id AS source_vocabulary_id,
    vc.domain_id AS source_domain_id,
    vc.concept_id AS source_concept_id,
    vc2.domain_id AS target_domain_id,
    vc2.concept_id AS target_concept_id
FROM
    {{ ref("stg__voc_concept") }} AS vc
LEFT JOIN
    {{ ref("stg__voc_concept_relationship") }} AS vcr
        ON vc.concept_id = vcr.concept_id_1
        AND vcr.relationship_id = 'Maps to'
LEFT JOIN
    {{ ref("stg__voc_concept") }} AS vc2
        ON vc2.concept_id = vcr.concept_id_2
        AND vc2.standard_concept = 'S'
        AND vc2.invalid_reason IS NULL
WHERE
    vc.vocabulary_id IN ('ICD9Proc', 'ICD10PCS')
),

lk_itemid_concept AS (
SELECT
    d_items.itemid AS itemid,
    CAST(d_items.itemid AS TEXT) AS source_code,
    d_items.label AS source_label,
    vc.vocabulary_id AS source_vocabulary_id,
    vc.domain_id AS source_domain_id,
    vc.concept_id AS source_concept_id,
    vc2.domain_id AS target_domain_id,
    vc2.concept_id AS target_concept_id
FROM
    {{ ref("stg__d_items") }} AS d_items
LEFT JOIN
    {{ ref("stg__voc_concept") }} AS vc
        ON vc.concept_code = CAST(d_items.itemid AS TEXT)
        AND vc.vocabulary_id IN (
            'mimiciv_proc_itemid',
            'mimiciv_proc_datetimeevents'
        )
LEFT JOIN
    {{ ref("stg__voc_concept_relationship") }} AS vcr
        ON vc.concept_id = vcr.concept_id_1
        AND vcr.relationship_id = 'Maps to'
LEFT JOIN
    {{ ref("stg__voc_concept") }} AS vc2
        ON vc2.concept_id = vcr.concept_id_2
        AND vc2.standard_concept = 'S'
        AND vc2.invalid_reason IS NULL
WHERE
    d_items.linksto IN (
        'procedureevents',
        'datetimeevents'
    )
)

SELECT
    src.subject_id AS subject_id, -- to person
    src.hadm_id AS hadm_id, -- to visit
    src.start_datetime AS start_datetime,
    src.start_datetime AS end_datetime,
    32821 AS type_concept_id, -- OMOP4976894 EHR billing record
    1 AS quantity,
    CAST(NULL AS INTEGER) AS itemid,
    src.source_code AS source_code,
    CAST(NULL AS TEXT) AS source_label,
    src.source_vocabulary_id AS source_vocabulary_id,
    lc.source_domain_id AS source_domain_id,
    COALESCE(lc.source_concept_id, 0) AS source_concept_id,
    lc.target_domain_id AS target_domain_id,
    COALESCE(lc.target_concept_id, 0) AS target_concept_id,
    src.provider_id AS provider_id,
    --
    'proc.procedures_icd' AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    lk_procedures_icd_clean AS src
LEFT JOIN
    lk_icd_proc_concept AS lc
        ON src.source_code = lc.source_code
        AND src.source_vocabulary_id = lc.source_vocabulary_id

UNION ALL

SELECT
    src.subject_id AS subject_id, -- to person
    src.hadm_id AS hadm_id, -- to visit
    src.start_datetime AS start_datetime,
    src.end_datetime AS end_datetime,
    32833 AS type_concept_id, -- OMOP4976906 EHR order
    src.quantity AS quantity,
    lc.itemid AS itemid,
    CAST(src.itemid AS TEXT) AS source_code,
    lc.source_label AS source_label,
    lc.source_vocabulary_id AS source_vocabulary_id,
    lc.source_domain_id AS source_domain_id,
    COALESCE(lc.source_concept_id, 0) AS source_concept_id,
    lc.target_domain_id AS target_domain_id,
    COALESCE(lc.target_concept_id, 0) AS target_concept_id,
    src.provider_id AS provider_id,
    --
    CONCAT('proc.', src.unit_id) AS unit_id,
    src.load_table_id AS load_table_id,
    src.load_row_id AS load_row_id,
    src.trace_id AS trace_id
FROM
    {{ ref("int__lk_proc_d_items_clean") }} AS src
LEFT JOIN
    lk_itemid_concept AS lc
        ON src.itemid = lc.itemid