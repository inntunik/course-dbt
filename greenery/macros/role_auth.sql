{% macro role_auth(role) %}

    {% set sql %}
      GRANT SELECT, INSERT, DELETE, UPDATE ON {{ this }} TO {{ role }};
    {% endset %}

    {% set table = run_query(sql) %}

{% endmacro %}