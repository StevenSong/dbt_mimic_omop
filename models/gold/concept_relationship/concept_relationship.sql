-- stg__voc_concept_relationship already unions the athena and custom relationships
select
    cast(concept_id_1 as bigint) as concept_id_1,
    cast(concept_id_2 as bigint) as concept_id_2,
    relationship_id,
    valid_start_date,
    valid_end_date,
    invalid_reason
from {{ ref("stg__voc_concept_relationship") }}
