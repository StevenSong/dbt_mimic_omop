SELECT *
FROM {{ source('mimic', 'radiology_annotations') }}