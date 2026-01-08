select *
from {{ ref("stg__voc_concept") }}

union all

select
    vcv.vocabulary_concept_id as concept_id,
    vcv.vocabulary_name as concept_name,
    'Metadata' as domain_id,
    'Vocabulary' as vocabulary_id,
    'Vocabulary' as concept_class_id,
    'S' as standard_concept,
    vcv.vocabulary_reference as concept_code,
    try_cast('1970-01-01' as date) as valid_start_date,
    try_cast('2099-12-31' as date) as valid_end_date,
    null as invalid_reason
from {{ ref("stg__custom_vocabulary") }} as vcv
