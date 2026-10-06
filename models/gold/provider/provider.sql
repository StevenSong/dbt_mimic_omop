{% set relationship_sources = [
    ref("stg__provider"),
    ref("stg__caregiver"),
] %}

{% for rel in relationship_sources %}
    SELECT
        {{ omop_id("provider_id") }} AS provider_id,
        CAST(NULL AS VARCHAR(255)) AS provider_name,
        CAST(NULL AS VARCHAR(20)) AS npi,
        CAST(NULL AS VARCHAR(20)) AS dea,
        NULL AS specialty_concept_id,
        NULL AS care_site_id,
        NULL AS year_of_birth,
        CAST(NULL AS INT) AS gender_concept_id,
        CAST(provider_id AS VARCHAR(50)) AS provider_source_value,
        CAST(NULL AS VARCHAR(50)) AS specialty_source_value,
        NULL AS specialty_source_concept_id,
        CAST(NULL AS VARCHAR(50)) AS gender_source_value,
        NULL AS gender_source_concept_id
    FROM
        {{ rel }}

    {% if not loop.last %}
        union all
    {% endif %}
{% endfor %}
