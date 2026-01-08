select
    tcr.source_concept_id as concept_id_1,
    case
        when tcr.target_concept_id = 0
        then tcr.source_concept_id
        else tcr.target_concept_id
    end as concept_id_2,
    tcr.relationship_id as relationship_id,
    try_cast(tcr.relationship_valid_start_date as date) as valid_start_date,
    try_cast(tcr.relationship_end_date as date) as valid_end_date,
    tcr.invalid_reason_cr as invalid_reason,

    'stg__custom_mapping' as load_table_id,
    cast(null as bigint) as load_row_id
from {{ ref("stg__custom_mappings") }} as tcr
where tcr.target_concept_id is not null

union all

select
    case
        when tcr.target_concept_id = 0
        then tcr.source_concept_id
        else tcr.target_concept_id
    end as concept_id_1,
    tcr.source_concept_id as concept_id_2,
    tcr.reverse_relationship_id as relationship_id,
    try_cast(tcr.relationship_valid_start_date as date) as valid_start_date,
    try_cast(tcr.relationship_end_date as date) as valid_end_date,
    tcr.invalid_reason_cr as invalid_reason,

    'tmp_custom_mapping' as load_table_id,
    cast(null as bigint) as load_row_id
from {{ ref("stg__custom_mappings") }} as tcr
where tcr.target_concept_id is not null
