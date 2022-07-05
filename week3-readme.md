# Analytics Engineering with dbt, week 3

## What is our overall conversion rate? 
```
select
    round(count(distinct case when event_type = 'checkout' then session_guid end)::numeric
        / count(distinct session_guid)::numeric, 2) as conversion_rate
from dbt_inna_t.stg_greenery__events
``` 
> Answer: The coversion rate is 62%

## What is our conversion rate by product? (Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product)
```
with page_view_count_by_product as (

    select
        p.product_guid
        , p.product_name
        , sum(case when e.event_type = 'page_view' then 1 else 0 end) as page_view_count

    from dbt.dbt_inna_t.stg_greenery__events e
    left join dbt.dbt_inna_t.stg_greenery__products p
        on e.product_guid = p.product_guid
    where
        e.product_guid is not null
    group by 1, 2

)

, checkout_count_by_product as (

    select
        po.product_guid
        , po.product_name
        , sum(case when e.event_type = 'checkout' then 1 else 0 end) as checkout_count

    from dbt.dbt_inna_t.stg_greenery__events e
    left join dbt.dbt_inna_t.int_product_orders__joined po
        on e.order_guid = po.order_guid
    where
        e.order_guid is not null
    group by 1, 2

)

, final as (

    select
        co.product_name
        , checkout_count
        , page_view_count
        , checkout_count::float / page_view_count::float as conversion_rate

    from checkout_count_by_product as co
    join page_view_count_by_product as pv
        on co.product_guid = pv.product_guid

)

select * from final

``` 
> Answer:
product_name     checkout_count      page_view_count   conversion_rate
Orchid           34                  75                0.45
Monstera         25                  48                0.51
Ficus            29                  68                0.43
Peace Lily       27                  67                0.40
Devil's Ivy      22                  45                0.49