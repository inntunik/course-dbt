with base as (
  select
    user_guid
    , count(distinct order_guid) as user_orders
  from {{ ref('stg_greenery__orders') }}
  group by user_guid
),
user_purchases as (
  select
    user_guid
    , (user_orders = 1)::int as one_purchase
    , (user_orders >= 2)::int as two_purchases
    , (user_orders >= 1)::int as three_purchases
  from base
)
select 
  sum(two_purchases)::float / count(distinct user_guid) as repeat_rate
from user_purchases