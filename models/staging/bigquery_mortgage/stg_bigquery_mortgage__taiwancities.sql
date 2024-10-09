with 

source as (

    select * from {{ source('bigquery_mortgage', 'taiwancities') }}

),

renamed as (

    select
        city,
        lat,
        lng,
        country,
        iso2,
        admin_name,
        capital,
        population,
        population_proper

    from source

)

select * from renamed
