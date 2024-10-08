with 

source as (

    select * from {{ source('bigquery_mortgage', 'realestatedata') }}

),

renamed as (

    select
        transaction date,
        house age,
        distance to the nearest mrt station,
        number of convenience stores,
        latitude,
        longitude,
        house price of unit area

    from source

)

select * from renamed
