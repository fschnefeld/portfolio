-- models/pnl_analysis.sql
with sales_orders_table as {{ ref('core_orders')}}
,    opex as {{ ref('core_opex')}} 

, revenue AS (
    SELECT
        order_date,
        SUM(order_amount) AS total_revenue
    FROM
        sales_orders_table
    WHERE
        status = 'completed'
    GROUP BY
        order_date
),

cogs AS (
    SELECT
        order_date,
        SUM(cost_of_goods_sold) AS total_cogs
    FROM
        raw.sales_orders
    WHERE
        status = 'completed'
    GROUP BY
        order_date
),

gross_profit AS (
    SELECT
        r.order_date,
        r.total_revenue,
        c.total_cogs,
        (r.total_revenue - c.total_cogs) AS gross_profit
    FROM
        revenue AS r
    LEFT JOIN
        cogs AS c
    ON
        r.order_date = c.order_date
),

operating_expenses AS (
    SELECT
        expense_date,
        SUM(expense_amount) AS total_operating_expenses
    FROM
        opex
    GROUP BY
        expense_date
),

net_profit AS (
    SELECT
        gp.order_date,
        gp.total_revenue,
        gp.total_cogs,
        gp.gross_profit,
        oe.total_operating_expenses,
        (gp.gross_profit - oe.total_operating_expenses) AS net_profit
    FROM
        gross_profit AS gp
    LEFT JOIN
        opex AS oe
    ON
        gp.order_date = oe.expense_date
)

SELECT
    order_date AS date,
    total_revenue,
    total_cogs,
    gross_profit,
    total_operating_expenses,
    net_profit
FROM
    net_profit
ORDER BY
    date;
