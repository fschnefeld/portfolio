with 

source as (

    select * from {{ source('bigquery_customers', 'transactions') }}

),

renamed as (

    select

    from source

)

select * from renamed
