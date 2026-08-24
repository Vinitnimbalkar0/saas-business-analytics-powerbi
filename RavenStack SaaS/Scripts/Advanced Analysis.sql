
with churnbycountry as 
(
	SELECT
		country,
		COUNT(fc.churn_event_id) as total_churn,
		SUM(fc.refund_amount_usd) as total_refunded_amount,
		DENSE_RANK() OVER(ORDER BY COUNT(fc.churn_event_id) DESC) as rnk
	FROM gold.dim_accounts da
	JOIN gold.fact_churn fc
		ON da.account_id = fc.account_id
	GROUP BY country
)

SELECT
	country,
	total_churn,
	total_refunded_amount
FROM churnbycountry
ORDER BY total_refunded_amount DESC

with churnbyindustry as 
(
SELECT
		industry,
		COUNT(fc.churn_event_id) as total_churn,
		SUM(fc.refund_amount_usd) as total_refunded_amount,
		DENSE_RANK() OVER(ORDER BY COUNT(fc.churn_event_id) DESC) as rnk
	FROM gold.dim_accounts da
	JOIN gold.fact_churn fc
		ON da.account_id = fc.account_id
	GROUP BY industry

)
SELECT
	industry,
	total_churn,
	total_refunded_amount
FROM  churnbyindustry


WITH monthly_totals AS (
    SELECT
        da.account_id,
        YEAR(da.signup_date) as signup_year,
        MONTH(da.signup_date) as signup_month,             -- 1. Added numeric month
        FORMAT(da.signup_date,'MMM-yyyy') as month_year_label,
        SUM(fs.mrr_amount) as monthly_revenue
    FROM gold.dim_accounts da
    JOIN gold.fact_subscriptions fs
        ON da.account_id = fs.account_id
    GROUP BY 
        YEAR(da.signup_date),
        MONTH(da.signup_date),                             -- 2. Grouped by numeric month
        FORMAT(da.signup_date,'MMM-yyyy'),
        da.account_id
)
SELECT
    account_id,
    signup_year,
    month_year_label,
    monthly_revenue,
    SUM(monthly_revenue) OVER(ORDER BY signup_year, signup_month, account_id) as cumulative_monthly_revenue
FROM monthly_totals
ORDER BY 
    signup_year,
    signup_month,                                        
    account_id;

SELECT 
    YEAR(fs.start_date) AS rev_year,
    MONTH(fs.start_date) AS rev_month,
    FORMAT(fs.start_date, 'MMM-yyyy') AS month_year_label,
    SUM(fs.mrr_amount) AS total_mrr,
    COUNT(DISTINCT ds.account_id) AS active_customers,
    SUM(fs.mrr_amount) / NULLIF(COUNT(DISTINCT ds.account_id), 0) AS arpu
FROM gold.dim_subscriptions ds
JOIN gold.fact_subscriptions fs
    ON ds.subscription_id = fs.subscription_id
GROUP BY 
    YEAR(fs.start_date),
    MONTH(fs.start_date),
    FORMAT(fs.start_date, 'MMM-yyyy')
ORDER BY 
    rev_year, 
    rev_month;

with churn_rate as (
    SELECT
        COUNT(da.account_id) as total_account ,
        YEAR(da.signup_date) as signup_year,
        FORMAT(da.signup_date,'MMM-yyyy') as month_year_label,
        MONTH(da.signup_date) as signup_month,
        SUM(
            CASE
                WHEN churn_flag = 1 THEN 1
                ELSE 0
            END
        ) AS total_churn_acc
    FROM gold.dim_accounts da
    JOIN gold.fact_subscriptions fs
        ON da.account_id = fs.account_id
    GROUP BY 
        YEAR(da.signup_date),
        FORMAT(da.signup_date,'MMM-yyyy'),
        MONTH(da.signup_date)
)

WITH CustomerRevenue AS (
    SELECT 
        account_id,
        SUM(mrr_amount) as total_mrr
    FROM gold.fact_subscriptions
    GROUP BY account_id
)

SELECT 
    account_id,
    total_mrr,
    -- Adjusted thresholds to fit a 190 to 138k range
    CASE 
        WHEN total_mrr >= 50000 THEN '1 - Enterprise'
        WHEN total_mrr >= 10000 THEN '2 - High Value'
        WHEN total_mrr >= 2500  THEN '3 - Medium Value'
        ELSE '4 - Low Value'
    END AS customer_segment
FROM CustomerRevenue
ORDER BY total_mrr DESC;

SELECT
    signup_year,
    month_year_label,
    (total_churn_acc * 100.0) / total_account as churn_rate_percentage
FROM churn_rate
ORDER BY signup_month


SELECT
    da.country,
    SUM(fs.arr_amount) as annualy_rev,
   CONCAT(CAST((SUM(fs.arr_amount) * 100.0) / SUM(SUM(fs.arr_amount)) OVER() AS DECIMAL(10,2)),'%') as part_to_whole_revenue_contri 
FROM gold.dim_accounts da 
JOIN gold.fact_subscriptions fs 
        on da.account_id = fs.account_id
GROUP BY da.country
ORDER BY annualy_rev DESC


WITH monthly_sales as 
(
    SELECT
        YEAR(start_date) as sales_year,
        MONTH(start_date) as sales_month,
        FORMAT(start_date,'MMM-yyyy') as month_year_label,
        SUM(mrr_amount) as current_revenue
    FROM gold.fact_subscriptions
    GROUP BY 
        YEAR(start_date),
        MONTH(start_date),
        FORMAT(start_date,'MMM-yyyy')
)

SELECT
    sales_year,
    sales_month,
    month_year_label,
    current_revenue,
    LAG(current_revenue,1) OVER(ORDER BY sales_year,sales_month) as previous_momth_revenue,
    CONCAT(LEFT((current_revenue - LAG(current_revenue,1) OVER(ORDER BY sales_year,sales_month)) / NULLIF(LAG(current_revenue,1) OVER(ORDER BY sales_year,sales_month),0) *100.0,5),'%')as MoM_Growth
FROM monthly_sales
ORDER BY 
    sales_year,sales_month

WITH avg_sales as 
(
    SELECT
        YEAR(start_date) as sales_year,
        MONTH(start_date) as sales_month,
        FORMAT(start_date,'MMM-yyyy') as month_year_label,
        SUM(mrr_amount) as current_revenue
    FROM gold.fact_subscriptions
    GROUP BY 
        YEAR(start_date),
        MONTH(start_date),
        FORMAT(start_date,'MMM-yyyy')
)
SELECT
    sales_year,
    sales_month,
    month_year_label,
    current_revenue,
    AVG(current_revenue) OVER() as avg_revenue,
    current_revenue - AVG(current_revenue) OVER() as var_from_all_time_avg
FROM avg_sales
ORDER BY 
    sales_year,sales_month


WITH yearly_sales as 
(
    SELECT
        YEAR(start_date) as sales_year,
        SUM(mrr_amount) as current_revenue
    FROM gold.fact_subscriptions
    GROUP BY 
        YEAR(start_date)
)

SELECT
    sales_year,
    current_revenue,
    LAG(current_revenue,1) OVER(ORDER BY sales_year) as previous_year_revenue,
    LEFT((current_revenue - LAG(current_revenue,1) OVER(ORDER BY sales_year)) / NULLIF(LAG(current_revenue,1) OVER(ORDER BY sales_year),0) *100.0,5)as YoY_Growth
FROM yearly_sales
ORDER BY 
    sales_year

WITH avg_sales as 
(
    SELECT
        YEAR(start_date) as sales_year,
        MONTH(start_date) as sales_month,
        FORMAT(start_date,'MMM-yyyy') as month_year_label,
        SUM(mrr_amount) as current_revenue
    FROM gold.fact_subscriptions
    GROUP BY 
        YEAR(start_date),
        MONTH(start_date),
        FORMAT(start_date,'MMM-yyyy')
)
SELECT
    sales_year,
    sales_month,
    month_year_label,
    current_revenue,
    
    -- Calculates the average of the current month and the 2 previous months
    AVG(current_revenue) OVER(
        ORDER BY sales_year, sales_month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as rolling_3_month_avg,
    
    -- The Math: Current Sales - Rolling Average
    current_revenue - AVG(current_revenue) OVER(
        ORDER BY sales_year, sales_month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as variance_from_rolling_avg

FROM avg_sales
ORDER BY 
    sales_year, 
    sales_month;


SELECT
    da.country as country,
    SUM(fs.mrr_amount) as country_revenue,
    SUM(SUM(fs.mrr_amount)) OVER() as global_total_revenue,
    CONCAT(LEFT((SUM(fs.mrr_amount) * 100.0) / SUM(SUM(fs.mrr_amount)) OVER(),5),'%') as revenue_contribution
FROM gold.dim_accounts da 
JOIN gold.fact_subscriptions fs
    on da.account_id = fs.account_id
GROUP BY da.country
ORDER BY country_revenue DESC

SELECT
    da.region as region,
    SUM(fs.mrr_amount) as region_revenue,
    SUM(SUM(fs.mrr_amount)) OVER() as global_total_revenue,
    CONCAT(LEFT((SUM(fs.mrr_amount) * 100.0) / SUM(SUM(fs.mrr_amount)) OVER(),5),'%') as revenue_contribution
FROM gold.dim_accounts da 
JOIN gold.fact_subscriptions fs
    on da.account_id = fs.account_id
GROUP BY da.region
ORDER BY region_revenue DESC

SELECT
    da.customer_segment as customer_segment,
    SUM(fs.mrr_amount) as customer_segment_revenue,
    SUM(SUM(fs.mrr_amount)) OVER() as global_total_revenue,
    CONCAT(LEFT((SUM(fs.mrr_amount) * 100.0) / SUM(SUM(fs.mrr_amount)) OVER(),5),'%') as revenue_contribution
FROM gold.dim_accounts da 
JOIN gold.fact_subscriptions fs
    on da.account_id = fs.account_id
GROUP BY da.customer_segment
ORDER BY customer_segment_revenue DESC

SELECT
    da.customer_status as customer_status,
    SUM(fs.mrr_amount) as customer_status_revenue,
    SUM(SUM(fs.mrr_amount)) OVER() as global_total_revenue,
    CONCAT(LEFT((SUM(fs.mrr_amount) * 100.0) / SUM(SUM(fs.mrr_amount)) OVER(),5),'%') as revenue_contribution
FROM gold.dim_accounts da 
JOIN gold.fact_subscriptions fs
    on da.account_id = fs.account_id
GROUP BY da.customer_status
ORDER BY customer_status_revenue DESC


SELECT
    da.plan_tier as plan_tier,
    SUM(fs.mrr_amount) as tier_revenue,
    SUM(SUM(fs.mrr_amount)) OVER() as global_total_revenue,
    CONCAT(LEFT((SUM(fs.mrr_amount) * 100.0) / SUM(SUM(fs.mrr_amount)) OVER(),5),'%') as revenue_contribution
FROM gold.dim_accounts da 
JOIN gold.fact_subscriptions fs
    on da.account_id = fs.account_id
GROUP BY da.plan_tier
ORDER BY tier_revenue DESC

SELECT 
    da.country as country,
    COUNT(churn_event_id) as country_churn,
    SUM(COUNT(churn_event_id)) OVER() as global_top_churn,
    CONCAT(LEFT((COUNT(churn_event_id) * 100.0) / SUM(COUNT(churn_event_id)) OVER(),4),'%') as churn_contribution
FROM gold.dim_accounts da 
JOIN gold.fact_churn fc
    on da.account_id = fc.account_id
GROUP BY da.country


SELECT
    *
FROM gold.dim_accounts


SELECT
    ds.subscription_type as subscription_type,
    SUM(fs.mrr_amount) as subscription_revenue,
    SUM(SUM(fs.mrr_amount)) OVER() as global_total_revenue,
    CONCAT(LEFT((SUM(fs.mrr_amount) * 100.0) / SUM(SUM(fs.mrr_amount)) OVER(),5),'%') as revenue_contribution
FROM gold.dim_subscriptions ds 
JOIN gold.fact_subscriptions fs
    on ds.subscription_id = fs.subscription_id
GROUP BY ds.subscription_type
ORDER BY subscription_revenue DESC

SELECT
    ds.plan_tier as plan_tier,
    SUM(ff.usage_count) plan_usage,
    SUM(SUM(ff.usage_count)) OVER() as global_total_usage,
    CONCAT(LEFT((SUM(ff.usage_count) * 100.0) / SUM(SUM(ff.usage_count)) OVER(),5),'%') as usage_contribution
FROM gold.dim_subscriptions ds 
JOIN gold.fact_feature_usage ff
    on ds.subscription_id = ff.subscription_id
GROUP BY ds.plan_tier
ORDER BY plan_usage DESC

SELECT
    ds.plan_tier as plan_tier,
    SUM(ff.error_count) plan_error,
    SUM(SUM(ff.error_count)) OVER() as global_total_error,
    CONCAT(LEFT((SUM(ff.error_count) * 100.0) / SUM(SUM(ff.error_count)) OVER(),5),'%') as error_contribution
FROM gold.dim_subscriptions ds 
JOIN gold.fact_feature_usage ff
    on ds.subscription_id = ff.subscription_id
GROUP BY ds.plan_tier
ORDER BY plan_error DESC

SELECT
    ds.plan_tier as plan_tier,
    SUM(ff.usage_duration_secs) plan_usage_sec,
    SUM(SUM(ff.usage_duration_secs)) OVER() as global_total_usage_secs,
    CONCAT(LEFT((SUM(ff.usage_duration_secs) * 100.0) / SUM(SUM(ff.usage_duration_secs)) OVER(),5),'%') as usage_secs_contribution
FROM gold.dim_subscriptions ds 
JOIN gold.fact_feature_usage ff
    on ds.subscription_id = ff.subscription_id
GROUP BY ds.plan_tier
ORDER BY plan_usage_sec DESC

SELECT
    da.customer_segment as customer_segement,
    COUNT(fst.ticket_id) customer_segment_ticket,
    SUM(COUNT(fst.ticket_id)) OVER() as global_top_ticket,
    CONCAT(LEFT((COUNT(fST.ticket_id) * 100.0) / SUM(COUNT(fst.ticket_id)) OVER(),5),'%') as ticket_contribution
FROM gold.dim_accounts da 
JOIN gold.fact_support_tickets fst
    on da.account_id = fst.account_id
GROUP BY da.customer_segment
ORDER BY customer_segment_ticket DESC

SELECT
    fst.priority as priority,
    COUNT(fst.ticket_id) customer_segment_ticket,
    SUM(COUNT(fst.ticket_id)) OVER() as global_top_ticket,
    CONCAT(LEFT((COUNT(fST.ticket_id) * 100.0) / SUM(COUNT(fst.ticket_id)) OVER(),5),'%') as ticket_contribution
FROM gold.fact_support_tickets fst
GROUP BY fst.priority
ORDER BY customer_segment_ticket DESC


SELECT
    fst.priority as priority,
    SUM(fst.first_response_time_minutes) as priority_response_time,
    SUM(SUM(fst.first_response_time_minutes)) OVER() as global_priority_response_time,
    CONCAT(
        LEFT(   
            (SUM(fst.first_response_time_minutes) * 100.0) / SUM(SUM(fst.first_response_time_minutes)) OVER(),5),'%') as response_time_contri
FROM gold.fact_support_tickets fst
GROUP BY fst.priority
ORDER BY priority_response_time DESC


SELECT
    fc.customer_journey as customer_journey,
    SUM(fst.first_response_time_minutes) as customer_journey_response_time,
    SUM(SUM(fst.first_response_time_minutes)) OVER() as global_response_time,
     CONCAT(LEFT((SUM(fst.first_response_time_minutes) * 100.0) /  SUM(SUM(fst.first_response_time_minutes)) OVER(),5),'%') as response_time_contribution
FROM gold.fact_churn fc
JOIN gold.fact_support_tickets fst
    on fc.account_id = fst.account_id
GROUP BY fc.customer_journey
ORDER BY customer_journey_response_time DESC



SELECT
    YEAR(submitted_at) as submitted_year,
    FORMAT(submitted_at,'MMM-yyyy') as month_year_label,
    COUNT(ticket_id) as total_tickets,
    SUM(COUNT(ticket_id)) OVER() as global_total_tickets,
    CONCAT(LEFT(COUNT(ticket_id) * 100.0 / SUM(COUNT(ticket_id)) OVER(),3),'%') as ticket_contribution
FROM gold.fact_support_tickets fst
GROUP BY 
    YEAR(submitted_at),
     MONTH(submitted_at),
     FORMAT(submitted_at,'MMM-yyyy')
ORDER BY
    total_tickets DESC


SELECT
    YEAR(start_date) as subscription_year,
    MONTH(start_date) as subscription_month,
    FORMAT(start_date,'MMM-yyyy') as month_year_label,
    SUM(mrr_amount) as total_mrr,
    SUM(SUM(mrr_amount)) OVER() as global_mrr,
    CONCAT(LEFT(SUM(mrr_amount) *100.0 / SUM(SUM(mrr_amount)) OVER(),4),'%') as mrr_contribution
FROM gold.fact_subscriptions
GROUP BY 
    YEAR(start_date),
    MONTH(start_date),
    FORMAT(start_date,'MMM-yyyy')
ORDER BY 
    total_mrr DESC

WITH reactivation_by_country as(
SELECT
    da.country as country,
    SUM(
     CASE
        WHEN is_reactivation = 1 THEN 1
        ELSE 0
    END ) AS reactivation
FROM gold.fact_churn fc
JOIN gold.dim_accounts da
    on da.account_id = fc.account_id
GROUP BY da.country
)

SELECT
    country,
    SUM(reactivation) as total_reactivation,
    SUM(SUM(reactivation)) OVER() as global_reactivation,
    CONCAT(LEFT(SUM(reactivation) * 100.0 / SUM(SUM(reactivation)) OVER(),4),'%') as reactivation_contribution
FROM reactivation_by_country
GROUP BY country
ORDER BY 
    total_reactivation DESC


SELECT
    da.country as country,
    SUM(ffu.usage_count) as total_usage,
    SUM(SUM(ffu.usage_count)) OVER() as global_total_usage,
    CONCAT(LEFT(SUM(ffu.usage_count) * 100.0 / SUM(SUM(ffu.usage_count)) OVER(),4),'%') as usage_contribution
FROM gold.fact_feature_usage ffu
JOIN gold.dim_subscriptions ds
    on ds.subscription_id = ffu.subscription_id
JOIN gold.dim_accounts da
    on da.account_id = ds.account_id
GROUP BY da.country
ORDER BY 
    total_usage DESC

SELECT
    da.country as country,
    SUM(fs.refund_amount_usd) as total_refund,
    SUM(SUM(fs.refund_amount_usd)) OVER() as global_total_refund,
    CONCAT(LEFT(SUM(fs.refund_amount_usd) * 100.0 / SUM(SUM(fs.refund_amount_usd)) OVER(),4),'%') as refund_contribution
FROM gold.fact_churn fs
JOIN gold.dim_accounts da
    ON fs.account_id = da.account_id
GROUP BY da.country
ORDER BY 
    total_refund DESC

SELECT
    feedback_text,
    COUNT(churn_event_id) as total_churn,
    SUM(COUNT(churn_event_id)) OVER() as global_churn,
    CONCAT(LEFT(COUNT(churn_event_id) * 100.0/ SUM(COUNT(churn_event_id)) OVER(),4),'%') as churn_contri
FROM gold.fact_churn
GROUP BY feedback_text
ORDER BY 
    total_churn DESC


SELECT
    feedback_text,
    SUM(refund_amount_usd) as total_refund,
    SUM(SUM(refund_amount_usd)) OVER() as global_refund,
    CONCAT(LEFT(SUM(refund_amount_usd) * 100.0/ SUM(SUM(refund_amount_usd)) OVER(),4),'%') as refund_contri
FROM gold.fact_churn
GROUP BY feedback_text
ORDER BY 
    total_refund DESC


