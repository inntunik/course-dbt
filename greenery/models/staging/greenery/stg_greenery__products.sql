{{
  config(
    materialized='view'
  )
}}

with products_source as (
  select * from {{ source('greenery', 'products') }}
)

, renamed_casted as (
  select
    product_id as product_guid
    , name as product_name
    , price
    , inventory
  from products_source

)

select * from renamed_casted