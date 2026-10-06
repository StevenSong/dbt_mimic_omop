{#
    Deterministic surrogate key for OMOP id columns.
    duckdb's hash() returns a UBIGINT spread over the full 64-bit range, so about half
    of its values overflow the signed int64 that the OMOP CDM and downstream tools
    (OMOP_MEDS, HADES, PostgreSQL) expect - drop the top bit to keep it signed.

    usage: {{ omop_id("src.subject_id, src.hadm_id") }}
#}
{% macro omop_id(cols) -%}
    cast(hash({{ cols }}) >> 1 as bigint)
{%- endmacro %}
