# Analytics Engineering with dbt, week 2

## What is our user repeat rate?
```
with base as (
  select
    user_guid
    , count(distinct order_guid) as user_orders
  from dbt_inna_t.stg_greenery__orders
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
``` 
> Answer: The repeat rate is 0.7983870967741935.

## Explain the marts models you added. Why did you organize the models in the way you did?

> I added the users and products dimensions as I think they are entities and behave like a catalog. The facts that I added are growing constantly, and have user_id or product_id to be able to join to the dimensions in order to get full information.

## What assumptions are you making about each model? (i.e. why are you adding each test?)

* Primary keys on every model should be unique and should NOT be NULL
* Email format should be valid
* Phone number format should be valid
* Zipcode should be valid
* Order status should be one of the accepted values (preparing, shipped, or delivered)
* Order quantity should NOT be greater than the product inventory
* Promo code GUID should be in the defined format (using lower case and underscore) before further analysis.
* Promo code status should be one of the accepted values (active or inactive)
* Product inventory should be only positive
* Order quantity should be only positive
* Shipping service should be one of the accepted values (fedex, dhl, ups, or usps) and can be NULL
* Event type should be one of the accepted values (add_to_cart, checkout, page_view, or package_shipped)
* Relationships between models should be associated correctly
* Order quantity or prices are positive values
* Order dates should be before delivery dates

## Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

> I found promo code GUID was originally in an arbitrary format, so I need to clean the staging model of the promo code up before further analysis.

## Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

> I have an automated system that schedules the tests to run every morning to make sure the data are in the good condition and ready for reporting and analyses. If a test fails, the system will notify me; therefore, I can jump in and fix it before the data users know.
