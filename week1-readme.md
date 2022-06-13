# Analytics Engineering with dbt, week 1

## How many users do we have?
```
select count(distinct user_guid) as users
from dbt.dbt_inna_t.stg_greenery__users;
``` 
> Answer: 130 unique users

## On average, how many orders do we receive per hour?
```
with 
    orders_per_hour as (
        select count(order_guid)
            , date_trunc('hour', created_at_utc) as order_hour_utc
        from dbt.dbt_inna_t.stg_greenery__orders
            group by order_hour_utc
    )

select 
    avg(count) 
from orders_per_hour;
```
> Answer: 7.52 orders per hour on average

## On average, how long does an order take from being placed to being delivered?
```
with 
    orders_avg_delivery_time as (
        select created_at_utc
            , delivered_at_utc
            , (delivered_at_utc - created_at_utc) as delivery_time
        from dbt.dbt_inna_t.stg_greenery__orders
            where 
                delivered_at_utc IS NOT NULL
                and ordered_status = 'delivered'
    )

select avg(delivery_time) 
from orders_avg_delivery_time;
```
> Answer: 3 days, 21 h, 24 min, 11.8 sec

## How many users have only made one purchase? Two purchases? Three+ purchases?
```
with 
    orders_per_customer as (
        select user_guid
            , count(dbt.dbt_inna_t.stg_greenery__orders.user_guid) as number_of_orders
        from dbt.dbt_inna_t.stg_greenery__orders
            group by dbt.dbt_inna_t.stg_greenery__orders.user_guid
            order by number_of_orders desc
    )
select sum(case when number_of_orders = 1 then 1 else 0 end) as one_purchase
    , sum(case when number_of_orders = 2 then 1 else 0 end) as two_purchases
    , sum(case when number_of_orders >= 3 then 1 else 0 end) as three_plus_purchases
from orders_per_customer;
```
> Answer: 
> - 25 customers with 1 purchase
> - 28 customers with 2 purchases
> - 71 customers with 3+ purchases

## On average, how many unique sessions do we have per hour?
```
with 
    unique_sessions_per_hour as (
        select count(distinct(session_guid)) as unique_sessions
            , date_trunc('hour', created_at_utc) as session_hour_utc
        from dbt.dbt_inna_t.stg_greenery__events
            group by session_hour_utc
    )
select avg(unique_sessions) 
from unique_sessions_per_hour;
```
> Answer: 16.33 unique sessions per hour
