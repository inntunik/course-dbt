select du.user_guid
    , du.zip_code
    , du.state 
    , du.country
    , o.order_guid
from {{ ref('dim__users') }} as du 
    left join {{ ref('stg_greenery__orders') }} as o
    on du.user_guid = o.user_guid