/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates business-ready views in the 'gold' schema.

    The Gold layer follows a Star Schema design and is optimized for
    reporting, dashboarding, and Power BI.

    Run this script after the Silver layer has been loaded successfully.
===============================================================================
*/

--=============================================================================
-- Create Gold Schema
--=============================================================================

IF NOT EXISTS
(
    SELECT *
    FROM sys.schemas
    WHERE name = 'gold'
)
EXEC ('CREATE SCHEMA gold');
GO

--=============================================================================
-- Dimension: Accounts
--=============================================================================
IF OBJECT_ID('gold.dim_accounts', 'V') IS NOT NULL
    DROP VIEW gold.dim_accounts;
GO
CREATE OR ALTER VIEW gold.dim_accounts
AS
SELECT
    ROW_NUMBER() OVER(ORDER BY account_id) AS account_key,

    account_id,
    account_name,
    industry,
    country,
    region,
    customer_segment,
    seat_band,
    customer_status,
    trial_status,
    plan_tier,

    signup_date,
    signup_year,
    signup_month,
    signup_quarter,
    signup_month_name

FROM silver.accounts;
GO

--=============================================================================
-- Dimension: Subscriptions
--=============================================================================
IF OBJECT_ID('gold.dim_subscriptions', 'V') IS NOT NULL
    DROP VIEW gold.dim_subscriptions;
GO
CREATE OR ALTER VIEW gold.dim_subscriptions
AS
SELECT

    ROW_NUMBER() OVER(ORDER BY subscription_id) AS subscription_key,

    subscription_id,
    account_id,
    plan_tier,
    billing_frequency,
    subscription_type,
    renewal_status,
    revenue_band

FROM silver.subscriptions;
GO



--=============================================================================
-- Fact: Subscriptions
--=============================================================================
IF OBJECT_ID('gold.fact_subscriptions', 'V') IS NOT NULL
    DROP VIEW gold.fact_subscriptions;
GO
CREATE OR ALTER VIEW gold.fact_subscriptions
AS

SELECT

    subscription_id,
    account_id,

    start_date,
    end_date,

    seats,

    mrr_amount,
    arr_amount,

    contract_duration_days,
    contract_duration_months,

    upgrade_flag,
    downgrade_flag,
    churn_flag

FROM silver.subscriptions;
GO

--=============================================================================
-- Fact: Feature Usage
--=============================================================================
IF OBJECT_ID('gold.fact_feature_usage', 'V') IS NOT NULL
    DROP VIEW gold.fact_feature_usage;
GO
CREATE OR ALTER VIEW gold.fact_feature_usage
AS

SELECT

    usage_id,
    subscription_id,
    usage_date,

    feature_name,

    usage_count,
    usage_duration_secs,
    error_count,

    usage_count_band,
    usage_duration_band,
    error_status,
    feature_status

FROM silver.feature_usage;
GO

--=============================================================================
-- Fact: Support Tickets
--=============================================================================
IF OBJECT_ID('gold.fact_support_tickets', 'V') IS NOT NULL
    DROP VIEW gold.fact_support_tickets;
GO
CREATE OR ALTER VIEW gold.fact_support_tickets
AS

SELECT

    ticket_id,
    account_id,

    submitted_at,
    closed_at,

    resolution_time_hours,
    first_response_time_minutes,
    satisfaction_score,

    priority,

    resolution_band,
    response_time_band,
    satisfaction_category,
    ticket_status,
    escalation_status

FROM silver.support_tickets;
GO

--=============================================================================
-- Fact: Churn
--=============================================================================
IF OBJECT_ID('gold.fact_churn', 'V') IS NOT NULL
    DROP VIEW gold.fact_churn;
GO
CREATE OR ALTER VIEW gold.fact_churn
AS

SELECT

    churn_event_id,
    account_id,
    

    churn_date,

    refund_amount_usd,

    refund_band,

    customer_journey,

    preceding_upgrade_flag,
    preceding_downgrade_flag,
    is_reactivation,

    feedback_text

FROM silver.churn_events;
GO


