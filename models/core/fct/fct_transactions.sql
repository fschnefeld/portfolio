with transactions as ( select * from {{ ref('stg_bigquery_mortgage__realestatedata') }})

select * from transactions