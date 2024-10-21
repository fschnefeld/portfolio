WITH source AS (
    SELECT * FROM {{ ref('stg_coloplast__supplychaindata') }}
),

-- Calculate the average unit price using window functions and DISTINCT product names
avg_unit_price_calc AS (
    SELECT 
        DISTINCT product_name,
        ROUND(AVG(unit_price) OVER (PARTITION BY product_name), 2) AS avg_unit_price
    FROM source
),

-- Calculate the total quantity ordered using window functions and DISTINCT product names
total_quantity_calc AS (
    SELECT 
        DISTINCT product_name,
        SUM(quantity) OVER (PARTITION BY product_name) AS total_quantity_ordered
    FROM source
),

-- Combine results, using COALESCE to handle nulls, ensuring uniqueness
final AS (
    SELECT 
        aup.product_name,
        COALESCE(aup.avg_unit_price, 0) AS avg_unit_price,
        COALESCE(tq.total_quantity_ordered, 0) AS total_quantity_ordered
    FROM avg_unit_price_calc aup
    LEFT JOIN total_quantity_calc tq 
    ON aup.product_name = tq.product_name
    ORDER BY total_quantity_ordered DESC
    LIMIT 10
)

-- Apply the LIMIT after the join and ordering, ensuring distinct products
SELECT DISTINCT *
FROM final
