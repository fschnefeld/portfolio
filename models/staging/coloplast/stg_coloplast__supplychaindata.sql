with 

source as (

    select * from {{ source('coloplast', 'supplychaindata') }}

),

renamed as (

    select
        product_name,
        quantity,
        supplier_name,
        purchase_date,
        unit_price,
        total_cost,
        delivery_address,
        delivery_date,
        received_by,
        status

    from source

)

select * from renamed
