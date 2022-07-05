select address_guid
    , zip_code
    , length(zip_code::text)
    , state
from {{ ref('stg_greenery__addresses') }}
group by address_guid
    , zip_code
    , state
having length(zip_code::text) not in (4,5)