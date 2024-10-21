with source as ( select * from {{ ref('stg_coloplast__supplychaindata') }} )

, avg_unit_price_calc as (
    select
        product_name,
        round(avg(unit_price), 2) as avg_unit_price
    from source
    group by 1
)
, total_quantity_calc as (
    select
        product_name,
        sum(quantity) as total_quantity_ordered
    from source
    group by 1
)

, final as (
    select 
        aup.product_name,
        aup.avg_unit_price,
        tq.total_quantity_ordered
    from avg_unit_price_calc aup 
    left join total_quantity_calc tq 
    on aup.product_name = tq.product_name
    order by tq.total_quantity_ordered desc
    limit 10
)
select * from final