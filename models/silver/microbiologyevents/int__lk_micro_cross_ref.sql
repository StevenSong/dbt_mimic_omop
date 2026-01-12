SELECT
    trace_id AS trace_id_ab, -- for antibiotics
    FIRST_VALUE(src.trace_id) OVER (
        PARTITION BY
            src.subject_id,
            src.hadm_id,
            COALESCE(src.charttime, src.chartdate),
            src.spec_itemid,
            src.test_itemid,
            src.org_itemid
        ORDER BY src.trace_id
    ) AS trace_id_org, -- for test-organism pairs
    FIRST_VALUE(src.trace_id) OVER (
        PARTITION BY
            src.subject_id,
            src.hadm_id,
            COALESCE(src.charttime, src.chartdate),
            src.spec_itemid
        ORDER BY src.trace_id
    ) AS trace_id_spec, -- for specimen
    subject_id AS subject_id, -- to pick additional hadm_id from admissions
    hadm_id AS hadm_id,
    src.load_row_id AS order_provider_id,
    COALESCE(src.charttime, src.chartdate) AS start_datetime, -- just to do coalesce once
    COALESCE(src.storetime, src.storedate) AS end_datetime
FROM
    {{ ref("stg__microbiologyevents") }} AS src