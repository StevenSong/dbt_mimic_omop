{% set relationship_sources = [
    ref("stg__provider"),
    ref("stg__caregiver"),
] %}

{% for rel in relationship_sources %}
    SELECT
        provider_id AS provider_id,
        NULL AS provider_name,
        NULL AS npi,
        NULL AS dea,
        NULL AS specialty_concept_id,
        NULL AS care_site_id,
        NULL AS year_of_birth,
        NULL AS gender_concept_id,
        CAST(provider_id AS VARCHAR(50)) AS provider_source_value,
        NULL AS specialty_source_value,
        NULL AS specialty_source_concept_id,
        NULL AS gender_source_value,
        NULL AS gender_source_concept_id,
	    'provider' AS load_table_id,
	    hash(provider_id) AS load_row_id,
        json_object(
            'provider_id', provider_id
        )::text                             AS trace_id
    FROM
        {{ rel }}

    {% if not loop.last %}
        union all
    {% endif %}
{% endfor %}
