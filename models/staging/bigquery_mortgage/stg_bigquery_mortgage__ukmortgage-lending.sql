with 

source as (

    select * from {{ source('bigquery_mortgage', 'ukmortgage-lending') }}

),

renamed as (

    select
        Date as date,
        NL_Banks as nl_banks,
        NL_Specialist_Lenders as nl_specialist_lenders,
        NL_Others as nl_others,
        NL_Total as nl_total,
        BO_Banks as bo_banks,
        `BO_Specialist Lenders` as bo_specialist_lenders,
        BO_Others as bo_others,
        BO_Total as bo_total,
        LP_House_Purchase as lp_house_purchase,
        LP_Remortgaging as lp_remortgaging,
        LP_Other as lp_other

    from source

)

select * from renamed
