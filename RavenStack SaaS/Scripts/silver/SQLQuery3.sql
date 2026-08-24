INSERT INTO silver.accounts
(
    account_id,
    account_name,
    industry,
    country,
    signup_date,
    referral_source,
    plan_tier,
    seats,
    is_trial,
    churn_flag,
    signup_year,
    signup_month,
    signup_quarter,
    signup_month_name,
    customer_segment,
    seat_band,
    customer_status,
    trial_status,
    region
)

SELECT
    account_id,
    account_name,
    industry,
    country,
    signup_date,
    referral_source,
    plan_tier,
    seats,
    is_trial,
    churn_flag,

    YEAR(signup_date) AS signup_year,
    MONTH(signup_date) AS signup_month,
    DATEPART(QUARTER, signup_date) AS signup_quarter,
    DATENAME(MONTH, signup_date) AS signup_month_name,

    CASE
        WHEN seats <= 10 THEN 'Small'
        WHEN seats <= 50 THEN 'Medium'
        ELSE 'Enterprise'
    END AS customer_segment,

    CASE
        WHEN seats BETWEEN 1 AND 10 THEN '1-10'
        WHEN seats BETWEEN 11 AND 25 THEN '11-25'
        WHEN seats BETWEEN 26 AND 50 THEN '26-50'
        WHEN seats BETWEEN 51 AND 100 THEN '51-100'
        ELSE '100+'
    END AS seat_band,

    CASE
        WHEN churn_flag = 1 THEN 'Churned'
        ELSE 'Active'
    END AS customer_status,

    CASE
        WHEN is_trial = 1 THEN 'Trial'
        ELSE 'Paid'
    END AS trial_status,

    CASE
        WHEN country IN ('US','CA') THEN 'North America'
        WHEN country IN ('UK','FR','DE') THEN 'Europe'
        WHEN country IN ('AU','IN') THEN 'Asia Pacific'
        ELSE 'Other'
    END AS region

FROM
(
    SELECT
        account_id,
        TRIM(account_name) AS account_name,
        TRIM(industry) AS industry,
        TRIM(country) AS country,
        TRY_CONVERT(DATE, signup_date, 23) AS signup_date,
        TRIM(referral_source) AS referral_source,
        UPPER(TRIM(plan_tier)) AS plan_tier,
        TRY_CONVERT(INT, seats) AS seats,

        CASE
            WHEN UPPER(TRIM(is_trial)) = 'TRUE' THEN 1
            WHEN UPPER(TRIM(is_trial)) = 'FALSE' THEN 0
            ELSE NULL
        END AS is_trial,

        CASE
            WHEN UPPER(TRIM(churn_flag)) = 'TRUE' THEN 1
            WHEN UPPER(TRIM(churn_flag)) = 'FALSE' THEN 0
            ELSE NULL
        END AS churn_flag,

        ROW_NUMBER() OVER
        (
            PARTITION BY account_id
            ORDER BY TRY_CONVERT(DATE, signup_date, 23) DESC
        ) AS flag_last

    FROM bronze.accounts
) t
WHERE flag_last = 1;



INSERT INTO silver.subscriptions
(
    subscription_id,
    account_id,
    start_date,
    end_date,
    plan_tier,
    seats,
    mrr_amount,
    arr_amount,
    is_trial,
    upgrade_flag,
    downgrade_flag,
    churn_flag,
    billing_frequency,
    auto_renew_flag,

    subscription_type,
    renewal_status,
    contract_duration_days,
    contract_duration_months,
    revenue_band
)

SELECT
    subscription_id,
    account_id,
    start_date,
    end_date,
    plan_tier,
    seats,
    mrr_amount,
    arr_amount,
    is_trial,
    upgrade_flag,
    downgrade_flag,
    churn_flag,
    billing_frequency,
    auto_renew_flag,

    CASE
        WHEN upgrade_flag = 1 THEN 'Upgrade'
        WHEN downgrade_flag = 1 THEN 'Downgrade'
        ELSE 'Standard'
    END AS subscription_type,

    CASE
        WHEN auto_renew_flag = 1 THEN 'Auto Renew'
        ELSE 'Manual Renew'
    END AS renewal_status,

    DATEDIFF(DAY, start_date, ISNULL(end_date, GETDATE()))
        AS contract_duration_days,

    DATEDIFF(MONTH, start_date, ISNULL(end_date, GETDATE()))
        AS contract_duration_months,

    CASE
        WHEN mrr_amount < 100 THEN 'Low'
        WHEN mrr_amount < 500 THEN 'Medium'
        WHEN mrr_amount < 1000 THEN 'High'
        ELSE 'Enterprise'
    END AS revenue_band

FROM
(
    SELECT
        subscription_id,
        account_id,

        TRY_CONVERT(DATE, start_date, 23) AS start_date,
        TRY_CONVERT(DATE, end_date, 23) AS end_date,

        UPPER(TRIM(plan_tier)) AS plan_tier,

        TRY_CONVERT(INT, seats) AS seats,

        TRY_CONVERT(DECIMAL(12,1), mrr_amount) AS mrr_amount,
        TRY_CONVERT(DECIMAL(12,1), arr_amount) AS arr_amount,

        CASE
            WHEN UPPER(TRIM(is_trial)) = 'TRUE' THEN 1
            WHEN UPPER(TRIM(is_trial)) = 'FALSE' THEN 0
            ELSE NULL
        END AS is_trial,

        CASE
            WHEN UPPER(TRIM(upgrade_flag)) = 'TRUE' THEN 1
            WHEN UPPER(TRIM(upgrade_flag)) = 'FALSE' THEN 0
            ELSE NULL
        END AS upgrade_flag,

        CASE
            WHEN UPPER(TRIM(downgrade_flag)) = 'TRUE' THEN 1
            WHEN UPPER(TRIM(downgrade_flag)) = 'FALSE' THEN 0
            ELSE NULL
        END AS downgrade_flag,

        CASE
            WHEN UPPER(TRIM(churn_flag)) = 'TRUE' THEN 1
            WHEN UPPER(TRIM(churn_flag)) = 'FALSE' THEN 0
            ELSE NULL
        END AS churn_flag,

        UPPER(TRIM(billing_frequency)) AS billing_frequency,

        CASE
            WHEN UPPER(TRIM(auto_renew_flag)) = 'TRUE' THEN 1
            WHEN UPPER(TRIM(auto_renew_flag)) = 'FALSE' THEN 0
            ELSE NULL
        END AS auto_renew_flag,

        ROW_NUMBER() OVER
        (
            PARTITION BY subscription_id
            ORDER BY TRY_CONVERT(DATE, start_date, 23) DESC
        ) AS flag_last

    FROM bronze.subscriptions

) t

WHERE flag_last = 1;




INSERT INTO silver.churn_events
(
    churn_event_id,
    account_id,
    churn_date,
    churn_reason,
    refund_amount_usd,
    preceding_upgrade_flag,
    preceding_downgrade_flag,
    is_reactivation,
    feedback_text,
    refund_band,
    customer_journey
)

SELECT
    churn_event_id,
    account_id,
    churn_date,
    churn_reason,
    refund_amount_usd,
    preceding_upgrade_flag,
    preceding_downgrade_flag,
    is_reactivation,
    feedback_text,

    CASE
        WHEN refund_amount_usd = 0 THEN 'No Refund'
        WHEN refund_amount_usd < 100 THEN 'Low'
        WHEN refund_amount_usd < 500 THEN 'Medium'
        ELSE 'High'
    END AS refund_band,

    CASE
        WHEN is_reactivation = 1 THEN 'Reactivated'
        WHEN preceding_upgrade_flag = 1 THEN 'Upgrade Before Churn'
        WHEN preceding_downgrade_flag = 1 THEN 'Downgrade Before Churn'
        ELSE 'No Plan Change'
    END AS customer_journey

FROM
(
    SELECT
        churn_event_id,
        account_id,

        TRY_CONVERT(DATE, churn_date, 23) AS churn_date,

        TRIM(reason_code) AS churn_reason,

        TRY_CONVERT(DECIMAL(12,2), refund_amount_usd) AS refund_amount_usd,

        CASE
            WHEN UPPER(TRIM(preceding_upgrade_flag)) = 'TRUE' THEN 1
            WHEN UPPER(TRIM(preceding_upgrade_flag)) = 'FALSE' THEN 0
            ELSE NULL
        END AS preceding_upgrade_flag,

        CASE
            WHEN UPPER(TRIM(preceding_downgrade_flag)) = 'TRUE' THEN 1
            WHEN UPPER(TRIM(preceding_downgrade_flag)) = 'FALSE' THEN 0
            ELSE NULL
        END AS preceding_downgrade_flag,

        CASE
            WHEN UPPER(TRIM(is_reactivation)) = 'TRUE' THEN 1
            WHEN UPPER(TRIM(is_reactivation)) = 'FALSE' THEN 0
            ELSE NULL
        END AS is_reactivation,

        NULLIF(TRIM(feedback_text), '') AS feedback_text,

        ROW_NUMBER() OVER
        (
            PARTITION BY churn_event_id
            ORDER BY TRY_CONVERT(DATE, churn_date, 23) DESC
        ) AS flag_last

    FROM bronze.churn_events

) AS t

WHERE flag_last = 1;



INSERT INTO silver.support_tickets
(
    ticket_id,
    account_id,
    submitted_at,
    closed_at,
    resolution_time_hours,
    priority,
    first_response_time_minutes,
    satisfaction_score,
    escalation_flag,
    resolution_band,
    response_time_band,
    satisfaction_category,
    ticket_status,
    escalation_status
)

SELECT
	ticket_id,
	account_id,
	submitted_at,
	closed_at,
	resolution_time_hours,
	priority,
	first_response_time_minutes,
	satisfaction_score,
	escalation_flag,
		CASE 
		WHEN resolution_time_hours <= 4 THEN 'Fast'
		WHEN resolution_time_hours <= 24 THEN 'Normal'
		ELSE 'Slow'
	END AS resolution_band,
	CASE
		WHEN first_response_time_minutes <= 30 THEN 'Excellent'
		WHEN first_response_time_minutes <= 120 THEN 'Good'
		ELSE 'Poor'
	END AS response_time_band,
	CASE
		WHEN satisfaction_score >= 4.0 THEN 'Satisfied'
		WHEN satisfaction_score = 3.0 THEN 'Neutral'
		ELSE 'Unsatisfied'
	END AS satisfication_category,
	CASE
		WHEN closed_at IS NULL THEN 'Open'
		ELSE 'Closed'
	END AS ticket_status,
	CASE
		WHEN escalation_flag = 1 THEN 'Escalated'
		ELSE 'Normal'
	END AS escalation_status
FROM
(SELECT
	ticket_id,
	account_id,
	TRY_CONVERT(DATE,submitted_at,23) as submitted_at,
	TRY_CONVERT(DATE,closed_at,23) as closed_at,
	resolution_time_hours,
	priority,
	first_response_time_minutes,
	satisfaction_score,
	CASE
		WHEN TRIM(UPPER(escalation_flag)) = 'TRUE' THEN 1
		WHEN TRIM(UPPER(escalation_flag)) = 'FALSE' THEN 0
		ELSE NULL	
	END AS escalation_flag,
	ROW_NUMBER() OVER(PARTITION BY ticket_id ORDER BY TRY_CONVERT(DATE,submitted_at,23) DESC ) AS flag_last
FROM bronze.support_tickets
) t
WHERE flag_last = 1