select
    concept_name,
    try_cast(source_concept_id as integer) as source_concept_id,
    source_vocabulary_id,
    source_domain_id,
    source_concept_class_id,
    standard_concept,
    concept_code,
    try_cast(valid_start_date as date) as valid_start_date,
    try_cast(valid_end_date as date) as valid_end_date,
    invalid_reason,
    try_cast(target_concept_id as integer) as target_concept_id,
    relationship_id,
    reverese_relationship_id as reverse_relationship_id,
    try_cast(relationship_valid_start_date as date) as relationship_valid_start_date,
    try_cast(relationship_end_date as date) as relationship_end_date,
    invalid_reason_cr
from {{ source("athena_vocabulary", "custom_mappings") }}
