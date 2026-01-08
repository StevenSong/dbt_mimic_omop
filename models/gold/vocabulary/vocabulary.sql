SELECT *
FROM
    {{ ref("stg__voc_vocabulary") }}
WHERE
    vocabulary_concept_id < 2000000000

union all

SELECT
    voc.vocabulary_id         AS vocabulary_id,
    voc.vocabulary_name       AS vocabulary_name,
    voc.vocabulary_reference  AS vocabulary_reference,
    voc.vocabulary_version    AS vocabulary_version,
    voc.vocabulary_concept_id AS vocabulary_concept_id
FROM 
    {{ ref("stg__custom_vocabulary") }} AS voc
