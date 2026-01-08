select
    voc.source_vocabulary_id as source_vocabulary_id,
    'stg__custom_mapping' as load_table_id,
    try_cast(null as bigint) as load_row_id
from {{ ref("stg__custom_mappings") }} as voc
group by voc.source_vocabulary_id
