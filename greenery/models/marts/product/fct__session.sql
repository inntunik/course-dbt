with session_length as (
select 
    session_guid 
    , min(created_at_utc) as first_event 
    , max(created_at_utc) as last_event
from {{ ref('stg_greenery__events') }}     
group by 1
)

select 
    init__session_events_basic_agg.session_guid
    , init__session_events_basic_agg.user_guid
    , stg_greenery__users.first_name
    , stg_greenery__users.last_name
    , stg_greenery__users.email
    , init__session_events_basic_agg.package_shipped
    , init__session_events_basic_agg.page_view
    , init__session_events_basic_agg.checkout
    , init__session_events_basic_agg.add_to_cart
    , session_length.first_event as first_session_event 
    , session_length.last_event as last_session_event
    , date_part('hour', session_length.last_event::timestamp - session_length.first_event::timestamp) as hours_diff
from {{ ref('init__session_events_basic_agg') }}
    left join {{ ref('stg_greenery__users') }}
      on init__session_events_basic_agg.user_guid = stg_greenery__users.user_guid
    left join session_length
      on init__session_events_basic_agg.session_guid = session_length.session_guid

