{{
  config(
    materialized='view'
  )
}}

with promos_source as (
  select * from {{ source('greenery', 'promos') }} 
),

renamed_casted as (
  select
    promo_id as promo_guid
    , discount
    , status as ordered_status
  from promos_source

)

select * from renamed_casted