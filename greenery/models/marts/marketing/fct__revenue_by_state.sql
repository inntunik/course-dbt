select state 
    , round(sum(user_prod_expenditure)) as revenue
    , round(sum(product_quantity)) as units_of_output
from {{ ref('fct__order_items_products') }}
group by 1
order by revenue desc