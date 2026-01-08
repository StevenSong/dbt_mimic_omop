select *
from {{ source("athena_vocabulary", "VOCABULARY") }}
where vocabulary_concept_id < 2000000000
