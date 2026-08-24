--=============================================================================
-- Dimension: Accounts
--=============================================================================

SELECT
	distinct industry
FROM gold.dim_accounts

SELECT
	distinct country
FROM gold.dim_accounts	

SELECT
	distinct region 
FROM gold.dim_accounts	

SELECT
	distinct customer_segment 
FROM gold.dim_accounts	

SELECT
	distinct customer_status 
FROM gold.dim_accounts	

SELECT
	distinct trial_status 
FROM gold.dim_accounts

SELECT
	distinct plan_tier 
FROM gold.dim_accounts

SELECT
	MIN(signup_date) as earliest_signup_date,
	MAX(signup_date) as latest_signup_date
FROM gold.dim_accounts

SELECT
	MIN(signup_year) as earliest_signup_year,
	MAX(signup_year) as latest_signup_year
FROM gold.dim_accounts

SELECT
	industry,
	COUNT(account_id) as total_accounts
FROM gold.dim_accounts
GROUP BY industry


SELECT
	country,
	COUNT(account_id) as total_accounts
FROM gold.dim_accounts
GROUP BY country


SELECT
	region,
	COUNT(account_id) as total_accounts
FROM gold.dim_accounts
GROUP BY region


SELECT 
    'Industry' AS dimension_name, 
    industry AS dimension_value, 
    COUNT(account_id) AS total_accounts
FROM gold.dim_accounts
GROUP BY industry

UNION ALL

SELECT 
    'Country', 
    country, 
    COUNT(account_id)
FROM gold.dim_accounts
GROUP BY country

UNION ALL

SELECT 
    'Region', 
    region, 
    COUNT(account_id)
FROM gold.dim_accounts
GROUP BY region

UNION ALL

SELECT
	'Customer Segment',
	customer_segment,
	COUNT(account_id) as total_accounts
FROM gold.dim_accounts
GROUP BY customer_segment

UNION ALL 

SELECT
	'Trial Status',
	trial_status,
	COUNT(account_id) as total_accounts
FROM gold.dim_accounts
GROUP BY trial_status

UNION ALL

SELECT
	'Plan Tier',
	plan_tier,
	COUNT(account_id) as total_accounts
FROM gold.dim_accounts
GROUP BY plan_tier

UNION ALL 

SELECT
	'Seat Band',	
	seat_band,
	COUNT(account_id) as total_accounts
FROM gold.dim_accounts
GROUP BY seat_band

SELECT 
    region, -- Dimension 1
    plan_tier, -- Dimension 2
    COUNT(account_id) AS total_accounts -- Measure
FROM gold.dim_accounts
GROUP BY 
    region, 
    plan_tier
ORDER BY 
    region ASC, 
    total_accounts DESC;

SELECT 
    signup_year, 
    signup_quarter, 
    COUNT(account_id) AS new_signups 
FROM gold.dim_accounts
GROUP BY 
    signup_year, 
    signup_quarter
ORDER BY 
    signup_year ASC, 
    signup_quarter ASC;

SELECT
	country,
	industry,
	plan_tier,
	FORMAT(signup_date,'yyyy-MM') as signup_year_month,
	COUNT(account_id) AS new_signups
FROM gold.dim_accounts
GROUP BY country,industry,plan_tier,FORMAT(signup_date,'yyyy-MM')

SELECT 
    industry,
    COUNT(account_id) AS total_accounts,
    RANK() OVER(ORDER BY COUNT(account_id) DESC) AS industry_rank
FROM gold.dim_accounts
GROUP BY industry;

WITH TierCounts AS (
    SELECT 
        country,
        plan_tier,
        COUNT(account_id) AS total_accounts
    FROM gold.dim_accounts
    GROUP BY 
        country, 
        plan_tier
)
SELECT 
    country,
    plan_tier,
    total_accounts,
    RANK() OVER(PARTITION BY country ORDER BY total_accounts DESC) AS rank_in_country
FROM TierCounts;

WITH TierCountsIndustry AS (
    SELECT 
        industry,
        plan_tier,
        COUNT(account_id) AS total_accounts
    FROM gold.dim_accounts
    GROUP BY 
        industry, 
        plan_tier
)
SELECT 
    industry,
    plan_tier,
    total_accounts,
    RANK() OVER(PARTITION BY industry ORDER BY total_accounts DESC) AS rank_in_country
FROM TierCountsIndustry;



--=============================================================================
-- Dimension: Subscriptions
--=============================================================================
SELECT
	distinct plan_tier
FROM gold.dim_subscriptions

SELECT
	distinct billing_frequency
FROM gold.dim_subscriptions

SELECT
	 distinct subscription_type
FROM gold.dim_subscriptions

SELECT
	 distinct renewal_status
FROM gold.dim_subscriptions



SELECT
	ds.plan_tier,
	ds.subscription_type,
	fs.start_date,
	fs.end_date,
	ds.revenue_band,
	fs.mrr_amount,
	fs.arr_amount,
	ds.renewal_status,
	ds.billing_frequency,
	fs.seats,
	fs.contract_duration_days,
	fs.contract_duration_months,
	CASE
		WHEN upgrade_flag = 1 THEN 'Upgraded'
		ELSE 'No Upgrade'
	END  as upgrade_status,
	CASE
		WHEN churn_flag = 1 THEN 'Churned'
		ELSE 'Not churned'
	END  as churned_status
FROM gold.dim_subscriptions ds
JOIN gold.fact_subscriptions fs
		on	ds.subscription_id = fs.subscription_id



--=============================================================================
-- Mix : Subscription
--=============================================================================
SELECT
	ds.plan_tier,
	FORMAT(fs.start_date,'MMM-yy') as month_name,
	SUM(fs.mrr_amount) as monthly_revenue,
	YEAR(fs.start_date) as year,
	SUM(fs.arr_amount) as annualy_revenue
FROM gold.dim_subscriptions ds
JOIN gold.fact_subscriptions fs
		on	ds.subscription_id = fs.subscription_id
GROUP BY MONTH(fs.start_date),FORMAT(fs.start_date,'MMM-yy'),YEAR(fs.start_date),ds.plan_tier
ORDER BY  MONTH(fs.start_date)


SELECT
	ds.renewal_status,
	SUM(fs.seats) as total_seats,
	COUNT(ds.account_id) as total_accounts
FROM gold.dim_subscriptions ds
JOIN gold.fact_subscriptions fs
		on	ds.subscription_id = fs.subscription_id
GROUP BY ds.renewal_status
ORDER BY total_accounts DESC,total_seats DESC

SELECT
	ds.billing_frequency,
	SUM(fs.seats) as total_seats,
	SUM(fs.contract_duration_days) as total_contract_days,
	COUNT(ds.account_id) as total_accounts
FROM gold.dim_subscriptions ds
JOIN gold.fact_subscriptions fs
	on	ds.subscription_id = fs.subscription_id
GROUP BY ds.billing_frequency
ORDER BY total_contract_days DESC, total_seats DESC,total_accounts DESC


SELECT 
	ds.subscription_type,
	FORMAT(fs.start_date,'MMM-yy') as month_year,	
	SUM(fs.mrr_amount) as monthly_revenue
FROM  gold.dim_subscriptions ds
JOIN gold.fact_subscriptions fs
	on	ds.subscription_id = fs.subscription_id
GROUP BY 
	ds.subscription_type,
	 MONTH(fs.start_date),
	 FORMAT(fs.start_date,'MMM-yy')
ORDER BY  MONTH(fs.start_date)


SELECT 
	ds.subscription_type,
	YEAR(fs.start_date) as year,	
	SUM(fs.arr_amount) as annualy_revenue
FROM  gold.dim_subscriptions ds
JOIN gold.fact_subscriptions fs
	on	ds.subscription_id = fs.subscription_id
GROUP BY 
	ds.subscription_type,
	YEAR(fs.start_date)
ORDER BY YEAR(fs.start_date)

WITH Churn_status as
(
	SELECT
		CASE
			WHEN fs.churn_flag = 1 THEN 'Churned'
			ELSE 'Not churned'
		END  as churned_status,
		fs.mrr_amount,
		fs.arr_amount,
		ds.account_id
	FROM gold.dim_subscriptions ds
	JOIN gold.fact_subscriptions fs
		on	ds.subscription_id = fs.subscription_id
)

SELECT
	churned_status,
	SUM(mrr_amount) as monthly_revenue,
	SUM(arr_amount) as annualy_revenue,
	COUNT(account_id) as total_account
FROM Churn_status
GROUP BY churned_status
ORDER BY 
	monthly_revenue DESC,
	annualy_revenue DESC,
	total_account DESC

WITH upgrade_status as
(
	SELECT
		CASE
			WHEN fs.upgrade_flag = 1 THEN 'Upgraded'
			ELSE 'No Upgrade'
		END  as upgrade_status,
		fs.mrr_amount,
		fs.arr_amount,
		ds.account_id 
	FROM gold.dim_subscriptions ds
		JOIN gold.fact_subscriptions fs
			on	ds.subscription_id = fs.subscription_id
)

SELECT
	upgrade_status,
	SUM(mrr_amount) as monthly_revenue,
	SUM(arr_amount) as annualy_revenue,
	COUNT(account_id) as total_account
FROM upgrade_status
GROUP BY upgrade_status
ORDER BY 
	monthly_revenue DESC,
	annualy_revenue DESC,
	total_account DESC



SELECT	
	YEAR(fs.start_date) as year,
	SUM(fs.mrr_amount) as Revenue
FROM gold.dim_subscriptions ds
JOIN gold.fact_subscriptions fs
	on	ds.subscription_id = fs.subscription_id
GROUP BY YEAR(fs.start_date)
	
SELECT	
	YEAR(fs.start_date) as year,
	SUM(fs.seats) as seats
FROM gold.dim_subscriptions ds
JOIN gold.fact_subscriptions fs
	on	ds.subscription_id = fs.subscription_id
GROUP BY YEAR(fs.start_date)

--=============================================================================
-- Fact: Subscriptions
--=============================================================================

SELECT
	 MIN(start_date) as earliest_subscription_start_date,
	 MIN(end_date) as earliest_subscription_end_date,
	 MAX(start_date) as latest_subscription_start_date ,
	 MAX(end_date) as  latest_subscription_end_date
FROM gold.fact_subscriptions


SELECT
	SUM(seats) as total_seats,
	SUM(mrr_amount) as monthly_revenue,
	SUM(arr_amount) as annual_revenue,
	AVG(mrr_amount) as avg_monthly_revenue,
	AVG(arr_amount) as avg_annual_revenue,
	SUM(
		CASE	
			WHEN upgrade_flag = 1 THEN 1 
			ELSE 0
		END 
	) as total_upgrades,
	SUM(
		CASE	
			WHEN upgrade_flag = 0 THEN 1 
			ELSE 0
		END 
	) as total_downgrade,
	SUM(
		CASE	
			WHEN churn_flag = 1 THEN 1
			ELSE 0
		END 
	) as total_churns
FROM gold.fact_subscriptions

WITH RevenueBuckets AS (
    SELECT 
        account_id,
        CASE 
            WHEN mrr_amount < 500 THEN 'Under $500'
            WHEN mrr_amount BETWEEN 500 AND 1000 THEN '$500 - $1,000'
            WHEN mrr_amount BETWEEN 1001 AND 5000 THEN '$1,001 - $5,000'
            ELSE 'Over $5,000'
        END AS mrr_tier
    FROM gold.fact_subscriptions
)
SELECT 
    mrr_tier,
    COUNT(account_id) AS total_accounts
FROM RevenueBuckets
GROUP BY mrr_tier
ORDER BY mrr_tier;
--=============================================================================
-- Fact: Fact Feature Usage
--=============================================================================
SELECT
	distinct usage_count_band
FROM gold.fact_feature_usage

SELECT
	distinct usage_duration_band
FROM gold.fact_feature_usage

SELECT
	distinct error_status
FROM gold.fact_feature_usage

SELECT
	distinct feature_status
FROM gold.fact_feature_usage


SELECT
	MIN(usage_date) as earliest_usage_date,
	MAX(usage_date) as latest_usage_date,
	FLOOR(SUM(usage_duration_secs) / 60.0)  as total_usage_duration_in_Min,
	FLOOR(SUM(usage_duration_secs) / 86400.0)  as total_usage_duration_in_Days,
	FLOOR(SUM(usage_duration_secs) / 2592000.0)  as total_usage_duration_in_Months,
	SUM(error_count) as total_error_count
FROM gold.fact_feature_usage


SELECT 
	error_status,
	SUM(error_count) as total_errors
FROM gold.fact_feature_usage
GROUP BY error_status

SELECT
    feature_status,
	SUM(usage_count) as total_usage_count,
    SUM(usage_duration_secs) as total_duration_in_secs,
    SUM(usage_duration_secs / 60.0) as total_duration_in_mins,
    FLOOR(SUM(usage_duration_secs / 3600.0)) as total_duration_in_hours,
    FLOOR(SUM(usage_duration_secs / 86400.0)) as total_duration_in_days
FROM gold.fact_feature_usage
GROUP BY 
    feature_status;


SELECT
	YEAR(usage_date) AS usage_year,
    MONTH(usage_date) AS usage_month,
    FORMAT(usage_date, 'MMM-yy') AS month_year_label,
    COUNT(usage_count) AS total_usage_count
FROM gold.fact_feature_usage
GROUP BY 
	YEAR(usage_date),
    MONTH(usage_date),
    FORMAT(usage_date, 'MMM-yy')


SELECT
	YEAR(usage_date) AS usage_year,
    MONTH(usage_date) AS usage_month,
    FORMAT(usage_date, 'MMM-yy') AS month_year_label,
    COUNT(usage_id) AS total_users,
	SUM(error_count) as total_error_count
FROM gold.fact_feature_usage
GROUP BY 
	YEAR(usage_date),
    MONTH(usage_date),
    FORMAT(usage_date, 'MMM-yy')


SELECT
	*
FROM gold.fact_feature_usage

SELECT 
    feature_name,
    SUM(usage_count) AS total_usage_count,
    FLOOR(SUM(usage_duration_secs) / 86400.0) AS total_duration_days,
    SUM(error_count) AS total_errors
FROM gold.fact_feature_usage
GROUP BY 
    feature_name
ORDER BY 
    total_usage_count DESC;

SELECT
	subscription_id,
	SUM(usage_count) as total_usage_count,
	DENSE_RANK() OVER(ORDER BY SUM(usage_count) DESC) as rnk
FROM gold.fact_feature_usage
GROUP BY subscription_id
ORDER BY rnk
	
--=============================================================================
-- Fact: Fact Support Tickets
--=============================================================================

SELECT
	distinct priority
FROM gold.fact_support_tickets

SELECT
	distinct resolution_band
FROM gold.fact_support_tickets

SELECT
	distinct response_time_band
FROM gold.fact_support_tickets

SELECT
	distinct satisfaction_category
FROM gold.fact_support_tickets

SELECT
	distinct ticket_status
FROM gold.fact_support_tickets

SELECT
	distinct escalation_status
FROM gold.fact_support_tickets



SELECT 
    AVG(resolution_time_hours) AS avg_resolution_hours,
    AVG(first_response_time_minutes / 60.0) AS avg_first_response_hours,
	AVG(satisfaction_score) as avg_satisfaction_score,
    
    MIN(resolution_time_hours) AS min_resolution_hours,
    MAX(resolution_time_hours) AS max_resolution_hours,
    
    MIN(first_response_time_minutes) AS min_response_mins,
    MAX(first_response_time_minutes) AS max_response_mins
FROM gold.fact_support_tickets;




SELECT
	priority,
	COUNT(ticket_id) as total_tickets,
	FLOOR(AVG(resolution_time_hours)) as avg_resolution_hrs,
	FLOOR(AVG(first_response_time_minutes)) as avg_response_time_min
FROM gold.fact_support_tickets
GROUP BY priority
ORDER BY 
	total_tickets DESC;

SELECT
	satisfaction_category,
	COUNT(ticket_id) as total_tickets,
	FLOOR(AVG(resolution_time_hours)) as avg_resolution_hrs,
	FLOOR(AVG(first_response_time_minutes)) as avg_response_time_min
FROM gold.fact_support_tickets
GROUP BY satisfaction_category
ORDER BY 
	total_tickets DESC;

SELECT
	ticket_status,
	COUNT(ticket_id) as total_tickets,
	FLOOR(AVG(resolution_time_hours)) as avg_resolution_hrs,
	FLOOR(AVG(first_response_time_minutes)) as avg_response_time_min
FROM gold.fact_support_tickets
GROUP BY ticket_status
ORDER BY 
	total_tickets DESC;

SELECT
	escalation_status,
	COUNT(ticket_id) as total_tickets,
	FLOOR(AVG(resolution_time_hours)) as avg_resolution_hrs,
	FLOOR(AVG(first_response_time_minutes)) as avg_response_time_min
FROM gold.fact_support_tickets
GROUP BY escalation_status
ORDER BY 
	total_tickets DESC;

SELECT
	account_id,
	COUNT(ticket_id) as total_tickets,
	DENSE_RANK() OVER (ORDER BY COUNT(ticket_id) DESC) AS account_volume_rank
FROM gold.fact_support_tickets
GROUP BY account_id
ORDER BY account_volume_rank



SELECT 
    YEAR(submitted_at) AS ticket_year,
    MONTH(submitted_at) AS ticket_month,
    FORMAT(submitted_at, 'MMM-yy') AS month_year_label,
    COUNT(ticket_id) AS total_tickets,
    FLOOR(AVG(CAST(satisfaction_score AS FLOAT))) AS avg_satisfaction_score
FROM gold.fact_support_tickets
GROUP BY 
    YEAR(submitted_at),
    MONTH(submitted_at),
    FORMAT(submitted_at, 'MMM-yy')
ORDER BY 
    ticket_year,
    ticket_month;



SELECT
	distinct refund_band
FROM gold.fact_churn

SELECT
	distinct customer_journey
FROM gold.fact_churn

SELECT
	distinct feedback_text
FROM gold.fact_churn

SELECT
	MIN(churn_date) as earliest_date,
	MAX(churn_date) as latest_date,
	SUM(refund_amount_usd) as total_refunded_amount,
	AVG(refund_amount_usd) as avg_refunded_amount,
	SUM(
		CASE
			WHEN preceding_upgrade_flag = 1 THEN 1
			ELSE 0 
		END
		) AS total_preceding_upgrade,
	SUM(
		CASE
			WHEN preceding_downgrade_flag = 1 THEN 1
			ELSE 0 
		END
		) AS total_preceding_downgrade,
	SUM(
		CASE
			WHEN is_reactivation = 1 THEN 1
			ELSE 0 
		END
		) AS total_reactivation,
	SUM(
		CASE
			WHEN is_reactivation = 0 THEN 1
			ELSE 0
		END
		) AS total_non_activation
FROM gold.fact_churn

SELECT
	YEAR(churn_date) as churn_year,
	COUNT(account_id) as total_churn
FROM gold.fact_churn
GROUP BY YEAR(churn_date)
ORDER BY total_churn DESC

SELECT
	YEAR(churn_date) as churn_year,
	SUM(refund_amount_usd) as total_refunded_amount
FROM gold.fact_churn
GROUP BY YEAR(churn_date)
ORDER BY total_refunded_amount DESC

SELECT
	YEAR(churn_date) as churn_year,
	refund_band,
	COUNT(account_id) as total_churn
FROM gold.fact_churn
GROUP BY YEAR(churn_date),refund_band

SELECT
	CASE
		WHEN preceding_upgrade_flag = 1 THEN 'Upgrade'
		ELSE 'No Upgrade' 
	END AS preceding_status,
	COUNT(account_id) as total_churn
FROM gold.fact_churn
GROUP BY CASE
		WHEN preceding_upgrade_flag = 1 THEN 'Upgrade'
		ELSE 'No Upgrade' 
	END 

SELECT 
	refund_band,
	SUM(refund_amount_usd) as total_refund
FROM gold.fact_churn
GROUP BY refund_band

SELECT
	feedback_text,
	COUNT(account_id) as total_churn,
	SUM(refund_amount_usd) as total_refund
FROM gold.fact_churn
GROUP BY feedback_text

SELECT
	CASE
		WHEN is_reactivation = 1 THEN 'Yes'
		ELSE 'No'
	END as Reactivation_status,
	COUNT(account_id) as total_churn,
	SUM(refund_amount_usd) AS total_refunded_amount
FROM gold.fact_churn
GROUP BY CASE
		WHEN is_reactivation = 1 THEN 'Yes'
		ELSE 'No'
	END 

SELECT
	customer_journey,
	feedback_text,
	YEAR(churn_date) AS churn_year,
    MONTH(churn_date) AS churn_month,
    FORMAT(churn_date, 'MMM-yy') AS month_year_label,
	COUNT(account_id) as total_churn,
	SUM(refund_amount_usd) AS total_refunded_amount
FROM gold.fact_churn
GROUP BY 
	customer_journey,
	feedback_text,
	YEAR(churn_date),
    MONTH(churn_date),
    FORMAT(churn_date, 'MMM-yy')
ORDER BY
		churn_year,
		churn_month


WITH SupportVolume AS (
    SELECT 
        account_id,
        COUNT(ticket_id) AS total_tickets
    FROM gold.fact_support_tickets
    GROUP BY account_id
),
AccountChurn AS (
    SELECT 
        a.account_id,
        CASE WHEN c.account_id IS NOT NULL THEN 1 ELSE 0 END AS has_churned
    FROM gold.dim_accounts a
    LEFT JOIN gold.fact_churn c 
        ON a.account_id = c.account_id
)
SELECT 
    CASE 
        WHEN s.total_tickets IS NULL THEN '0 Tickets'
        WHEN s.total_tickets BETWEEN 1 AND 3 THEN '1-3 Tickets'
        WHEN s.total_tickets BETWEEN 4 AND 10 THEN '4-10 Tickets'
        ELSE '10+ Tickets'
    END AS support_dependency,
    COUNT(ac.account_id) AS total_accounts_in_tier,
    SUM(ac.has_churned) AS churned_accounts,
    CAST(SUM(ac.has_churned) AS FLOAT) / COUNT(ac.account_id) * 100 AS churn_rate_percentage
FROM AccountChurn ac
LEFT JOIN SupportVolume s 
    ON ac.account_id = s.account_id
GROUP BY 
    CASE 
        WHEN s.total_tickets IS NULL THEN '0 Tickets'
        WHEN s.total_tickets BETWEEN 1 AND 3 THEN '1-3 Tickets'
        WHEN s.total_tickets BETWEEN 4 AND 10 THEN '4-10 Tickets'
        ELSE '10+ Tickets'
    END
ORDER BY churn_rate_percentage DESC;