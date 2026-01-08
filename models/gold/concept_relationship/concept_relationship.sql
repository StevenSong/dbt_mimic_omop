{% set relationship_sources = [
    ref("stg__custom_concept_relationship"),
    ref("stg__voc_concept_relationship"),
] %}

{% for rel in relationship_sources %}
    select
        concept_id_1 as bigint,
        concept_id_2 as bigint,
        relationship_id,
        valid_start_date,
        valid_end_date,
        invalid_reason
    from {{ rel }}

    {% if not loop.last %}
        union all
    {% endif %}
{% endfor %}
