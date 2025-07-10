with 

source as (

    select * from {{ source('coloplast', 'gas_stations_london') }}

),

renamed as (

    select *
    from source

)

select * from renamed
