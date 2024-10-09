with estatedata as (
    select round(longitude, 2) as longitude, round(latitude,2) as latitude from {{ ref('stg_bigquery_mortgage__realestatedata') }} 
)
,    geo as (
    select round(lng,2) as lng, round(lat,2) as lat, city, country from {{ ref('stg_bigquery_mortgage__worldcities') }}
)
, taiwangeo as (
    select round(lng,2) as lng, round(lat,2) as lat, city, country from {{ ref('stg_bigquery_mortgage__taiwancities') }}
)
, initial as (
    select
        abs(farm_fingerprint(concat(cast(latitude as string), cast(longitude as string)))) as location_id,  -- Generate integer ID
        longitude,
        latitude,
        g.lng,
        g.lat,
        g.city,
        g.country
    from estatedata as es
    inner join geo as g
    on es.latitude = g.lat and es.longitude = g.lng 
)
, otherset as (
    select
        longitude,
        latitude,
        t.lng,
        t.lat,
        t.city,
        t.country
    from estatedata as es
    full outer join taiwangeo as t
    on es.latitude = t.lat and es.longitude = t.lng 
)

select * from otherset