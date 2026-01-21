SELECT *
FROM {{ source('mimic', 'discharge_annotations') }}