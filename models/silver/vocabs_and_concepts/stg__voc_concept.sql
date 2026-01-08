select
    concept_id,
    concept_name,
    domain_id,
    vocabulary_id,
    concept_class_id,
    standard_concept,
    concept_code,
    try_cast(
        strptime(cast(valid_start_date as varchar), '%Y%m%d') as date
    ) as valid_start_date,
    try_cast(
        strptime(cast(valid_end_date as varchar), '%Y%m%d') as date
    ) as valid_end_date,

    invalid_reason
from {{ source("athena_vocabulary", "CONCEPT") }}
where concept_id < 2000000000
