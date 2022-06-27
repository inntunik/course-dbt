{% macro agg_session_events() %}

    {% set event_types = ['page_view', 'add_to_cart', 'checkout'] %}

        {% for event_type in event_types %}
            sum(case when event_type = '{{event_type}}' 
            then 1 else 0 end) 
            as {{event_type}}_total,
        {% endfor %}

{% endmacro %}