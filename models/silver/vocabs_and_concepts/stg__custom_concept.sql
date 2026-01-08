select
    voc.source_concept_id as concept_id,
    voc.concept_name as concept_name,
    voc.source_domain_id as domain_id,
    voc.source_vocabulary_id as vocabulary_id,
    voc.source_concept_class_id as concept_class_id,
    case
        when voc.target_concept_id = 0 then 'S' else voc.standard_concept
    end as standard_concept,
    voc.concept_code as concept_code,
    try_cast(voc.valid_start_date as date) as valid_start_date,
    try_cast(voc.valid_end_date as date) as valid_end_date,
    voc.invalid_reason as invalid_reason,

    'stg__custom_mapping' as load_table_id,
    cast(null as bigint) as load_row_id
from {{ ref("stg__custom_mappings") }} as voc
group by
    voc.source_concept_id,
    voc.concept_name,
    voc.source_domain_id,
    voc.source_vocabulary_id,
    voc.source_concept_class_id,
    case when voc.target_concept_id = 0 then 'S' else voc.standard_concept end,
    voc.concept_code,
    voc.valid_start_date,
    voc.valid_end_date,
    voc.invalid_reason
