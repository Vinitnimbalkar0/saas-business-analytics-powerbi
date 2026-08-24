/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables
    if they already exist.

    Run this script to re-define the DDL structure of the Silver Layer.
===============================================================================
*/

--=============================================================================
-- Accounts
--=============================================================================

IF OBJECT_ID('silver.accounts', 'U') IS NOT NULL
    DROP TABLE silver.accounts;
GO

CREATE TABLE silver.accounts
(
    -- Business Columns
    account_id              VARCHAR(20),
    account_name            VARCHAR(200),
    industry                VARCHAR(100),
    country                 VARCHAR(100),
    signup_date             DATE,
    referral_source         VARCHAR(100),
    plan_tier               VARCHAR(50),
    seats                   INT,
    is_trial                BIT,
    churn_flag              BIT,

    -- Derived Columns
    signup_year             SMALLINT,
    signup_month            TINYINT,
    signup_quarter          TINYINT,
    signup_month_name       VARCHAR(15),

    customer_segment        VARCHAR(20),
    seat_band               VARCHAR(20),
    customer_status         VARCHAR(20),
    trial_status            VARCHAR(20),
    region                  VARCHAR(30),

    -- Audit Column
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO
--=============================================================================
-- Subscriptions
--=============================================================================

IF OBJECT_ID('silver.subscriptions', 'U') IS NOT NULL
    DROP TABLE silver.subscriptions;
GO

CREATE TABLE silver.subscriptions
(
    -- Business Columns
    subscription_id             VARCHAR(20),
    account_id                  VARCHAR(20),
    start_date                  DATE,
    end_date                    DATE,
    plan_tier                   VARCHAR(30),
    seats                       INT,
    mrr_amount                  DECIMAL(12,2),
    arr_amount                  DECIMAL(12,2),
    is_trial                    BIT,
    upgrade_flag                BIT,
    downgrade_flag              BIT,
    churn_flag                  BIT,
    billing_frequency           VARCHAR(20),
    auto_renew_flag             BIT,

    -- Derived Business Columns
    subscription_type           VARCHAR(20),
    renewal_status              VARCHAR(20),
    contract_duration_days      INT,
    contract_duration_months    INT,
    revenue_band                VARCHAR(20),
    -- Audit Column
    dwh_create_date             DATETIME2 DEFAULT GETDATE()
);
GO

--=============================================================================
-- Usage Events
--=============================================================================

IF OBJECT_ID('silver.feature_usage', 'U') IS NOT NULL
    DROP TABLE silver.feature_usage;
GO

CREATE TABLE silver.feature_usage
(
    usage_id                     VARCHAR(20),
    subscription_id              VARCHAR(20),
    usage_date                   DATE,
    feature_name                 VARCHAR(100),
    usage_count                  INT,
    usage_duration_secs          INT,
    error_count                  INT,
    is_beta_feature              BIT,

    usage_count_band             VARCHAR(20),
    usage_duration_band          VARCHAR(20),
    error_status                 VARCHAR(20),
    feature_status               VARCHAR(20),

    dwh_create_date              DATETIME2 DEFAULT GETDATE()
);
GO

--=============================================================================
-- Support Tickets
--=============================================================================

IF OBJECT_ID('silver.support_tickets', 'U') IS NOT NULL
    DROP TABLE silver.support_tickets;
GO

CREATE TABLE silver.support_tickets
(
    ticket_id                    VARCHAR(20),
    account_id                   VARCHAR(20),
    submitted_at                 DATETIME,
    closed_at                    DATETIME,
    resolution_time_hours        DECIMAL(10,2),
    priority                     VARCHAR(30),
    first_response_time_minutes  INT,
    satisfaction_score           TINYINT,
    escalation_flag              BIT,

    -- Business Attributes
    resolution_band              VARCHAR(30),
    response_time_band           VARCHAR(30),
    satisfaction_category        VARCHAR(30),
    ticket_status                VARCHAR(20),
    escalation_status            VARCHAR(20),

    dwh_create_date              DATETIME2 DEFAULT GETDATE()
);
GO
GO

--=============================================================================
-- Churn Events
--=============================================================================

IF OBJECT_ID('silver.churn_events', 'U') IS NOT NULL
    DROP TABLE silver.churn_events;
GO

CREATE TABLE silver.churn_events
(
    churn_event_id             VARCHAR(20),
    account_id                 VARCHAR(20),
    

    churn_date                 DATE,
    churn_reason               VARCHAR(200),
    refund_amount_usd          DECIMAL(12,2),

    preceding_upgrade_flag     BIT,
    preceding_downgrade_flag   BIT,
    is_reactivation            BIT,
    feedback_text              VARCHAR(MAX),

    -- Business Attributes
    refund_band                VARCHAR(20),
    customer_journey           VARCHAR(50),

    dwh_create_date            DATETIME2 DEFAULT GETDATE()
);
GO