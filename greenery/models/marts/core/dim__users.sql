select u.user_guid
    , u.first_name
    , u.last_name
    , a.zip_code
    , a.state
    , a.country 
from {{ ref('stg_greenery__users') }} as u 
    left join {{ ref('stg_greenery__addresses') }} as a
    on u.address_guid = a.address_guid   