select * from {{ source("mimic", "provider") }}
