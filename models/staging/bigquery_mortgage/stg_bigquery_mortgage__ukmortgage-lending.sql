with 

source as (

    select * from {{ source('bigquery_mortgage', 'ukmortgage-lending') }}

),

renamed as (

    select
        date,
        nl_banks,
        nl_specialist_lenders,
        nl_others,
        nl_total,
        bo_banks,
        bo_specialist lenders,
        bo_others,
        bo_total,
        lp_house_purchase,
        lp_remortgaging,
        lp_other

    from source

)

select * from renamed
