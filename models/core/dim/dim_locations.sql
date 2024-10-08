with locations as (
    select * from {{ ref('stg_bigquery_mortgage__realestatedata') }} 
)
, initial as (
    select
        abs(farm_fingerprint(concat(cast(latitude as string), cast(longitude as string)))) as location_id,  -- Generate integer ID
        longitude,
        latitude
    from locations
)

select * from initial