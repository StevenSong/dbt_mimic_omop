select 
    caregiver_id AS provider_id
from {{ source("mimic", "caregiver") }}
