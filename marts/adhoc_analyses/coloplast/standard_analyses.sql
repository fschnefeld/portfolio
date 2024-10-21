with
    supplychain_data as (select * from {{ ref("stg_coloplast__supplychaindata") }}),

    -- CTE for Average Unit Price by Product
    avg_unit_price_cte as (
        select product_name, round(avg(unit_price), 2) as avg_unit_price
        from supplychain_data
        group by product_name
    ),

    -- CTE for Total Quantity Ordered by Product
    total_quantity_cte as (
        select product_name, sum(quantity) as total_quantity_ordered
        from supplychain_data
        group by product_name
    ),

    -- CTE for Total Inventory Value by Product
    total_inventory_value_cte as (
        select product_name, round(sum(total_cost), 2) as total_inventory_value
        from supplychain_data
        group by product_name
    ),

    -- CTE for Top 5 Most Expensive Products per Unit
    top_5_expensive_cte as (
        select product_name, round(avg(unit_price), 2) as avg_unit_price
        from supplychain_data
        group by product_name
        order by avg_unit_price desc
        limit 5
    ),

    -- CTE for Average Inventory Holding Time (Lead Time)
    avg_lead_time_cte as (
        select
            product_name,
            round(
                avg(date_diff(delivery_date, purchase_date, day)), 2
            ) as avg_lead_time_days
        from supplychain_data
        where delivery_date is not null and purchase_date is not null
        group by product_name
    ),

    -- CTE for Stock Status Overview (Aggregated at the status level)
    stock_status_cte as (
        select
            status,
            count(*) as number_of_orders,
            round(sum(total_cost), 2) as total_value_of_orders
        from supplychain_data
        group by status
    ),

    -- CTE for Stock Level Analysis by Supplier (Aggregated data)
    supplier_analysis_cte as (
        select
            product_name,
            string_agg(distinct supplier_name) as suppliers,
            sum(quantity) as total_quantity_supplied,
            round(sum(total_cost), 2) as total_value_supplied
        from supplychain_data
        group by product_name
    ),

    -- CTE for Slow-Moving Inventory Analysis
    slow_moving_inventory_cte as (
        select product_name, max(delivery_date) as last_delivery_date
        from supplychain_data
        group by product_name
        having max(delivery_date) < current_date - interval 90 day
    ),

    -- CTE for Overall Inventory Value (Single row)
    overall_inventory_cte as (
        select round(sum(total_cost), 2) as overall_inventory_value
        from supplychain_data
    ),
    -- Final Select Statement combining all CTEs
    final as (
        select
            aup.product_name,
            aup.avg_unit_price,
            tq.total_quantity_ordered,
            tiv.total_inventory_value,
            alt.avg_lead_time_days,
            sa.suppliers,
            sa.total_quantity_supplied,
            sa.total_value_supplied,
            smi.last_delivery_date,
            oiv.overall_inventory_value
        from avg_unit_price_cte aup
        left join total_quantity_cte tq on aup.product_name = tq.product_name
        left join total_inventory_value_cte tiv on aup.product_name = tiv.product_name
        left join avg_lead_time_cte alt on aup.product_name = alt.product_name
        left join supplier_analysis_cte sa on aup.product_name = sa.product_name
        left join slow_moving_inventory_cte smi on aup.product_name = smi.product_name
        left join overall_inventory_cte oiv on true  -- Single row, applies to all
        order by aup.product_name
    )

select *
from final
