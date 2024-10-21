with 

source as (
    select
    `transaction date` as transaction_date,  -- Rename with alias
    `house age` as house_age,                -- Rename with alias
    `distance to the nearest MRT station` as distance_to_mrt,  -- Rename
    `number of convenience stores` as num_convenience_stores,  -- Rename
    `house price of unit area` as house_price,  -- Rename
    Latitude as latitude,
    Longitude as longitude
    from {{ source('bigquery_mortgage', 'realestatedata') }}

),

renamed as (

    select
        *

    from source

)

select * from renamed
