with 

source as (

    select * from {{ source('bigquery_mortgage', 'worldcities') }}

),

renamed as (

    select
        city,
        city_ascii,
        lat,
        lng,
        country,
        iso2,
        iso3,
        admin_name,
        capital,
        population,
        id

    from source

)

select * from renamed
