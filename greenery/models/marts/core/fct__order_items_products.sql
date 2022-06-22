select oi.order_guid 
    , oi.product_guid 
    , p.name as product_name 
    , p.price as product_price
    , oi.quantity as product_quantity 
    , p.price * oi.quantity as user_prod_expenditure
    , p.inventory as product_inventory 
    , geo.state
from {{ ref('stg_greenery__order_items') }} as oi 
    left join {{ ref('stg_greenery__products') }} as p
    on oi.product_guid = p.product_guid
    left join {{ ref('dim__order_user_geo') }} as geo
    on oi.order_guid = geo.order_guid
order by oi.order_guid