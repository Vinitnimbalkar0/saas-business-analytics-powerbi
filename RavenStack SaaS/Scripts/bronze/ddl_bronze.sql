--========================================
-- Accounts
--========================================
IF OBJECT_ID('bronze.accounts', 'U') IS NOT NULL
    DROP TABLE bronze.accounts;
GO

CREATE TABLE bronze.accounts (
    account_id VARCHAR(20),
    account_name VARCHAR(100),
    industry VARCHAR(50),
    country VARCHAR(50),
    signup_date VARCHAR(20),
    referral_source VARCHAR(50),
    plan_tier VARCHAR(20),
    seats INT,
    is_trial VARCHAR(10),
    churn_flag VARCHAR(10)
);
GO

--========================================
-- Churn Events
--========================================
IF OBJECT_ID('bronze.churn_events', 'U') IS NOT NULL
    DROP TABLE bronze.churn_events;
GO

CREATE TABLE bronze.churn_events (
    churn_event_id VARCHAR(20),
    account_id VARCHAR(20),
    churn_date VARCHAR(20),
    reason_code VARCHAR(50),
    refund_amount_usd DECIMAL(10,2),
    preceding_upgrade_flag VARCHAR(10),
    preceding_downgrade_flag VARCHAR(10),
    is_reactivation VARCHAR(10),
    feedback_text VARCHAR(255)
);
GO

--========================================
-- Usage Events
--========================================
IF OBJECT_ID('bronze.feature_usage', 'U') IS NOT NULL
    DROP TABLE bronze.feature_usage;
GO

CREATE TABLE bronze.feature_usage (
    usage_id VARCHAR(20),
    subscription_id VARCHAR(20),
    usage_date VARCHAR(20),
    feature_name VARCHAR(100),
    usage_count INT,
    usage_duration_secs INT,
    error_count INT,
    is_beta_feature VARCHAR(10)
);
GO

--========================================
-- Subscriptions
--========================================
IF OBJECT_ID('bronze.subscriptions', 'U') IS NOT NULL
    DROP TABLE bronze.subscriptions;
GO

CREATE TABLE bronze.subscriptions (
    subscription_id VARCHAR(20),
    account_id VARCHAR(20),
    start_date VARCHAR(20),
    end_date VARCHAR(20),
    plan_tier VARCHAR(20),
    seats INT,
    mrr_amount DECIMAL(10,2),
    arr_amount DECIMAL(12,2),
    is_trial VARCHAR(10),
    upgrade_flag VARCHAR(10),
    downgrade_flag VARCHAR(10),
    churn_flag VARCHAR(10),
    billing_frequency VARCHAR(20),
    auto_renew_flag VARCHAR(10)
);
GO

--========================================
-- Support Tickets
--========================================
IF OBJECT_ID('bronze.support_tickets', 'U') IS NOT NULL
    DROP TABLE bronze.support_tickets;
GO

CREATE TABLE bronze.support_tickets (
    ticket_id VARCHAR(20),
    account_id VARCHAR(20),
    submitted_at VARCHAR(30),
    closed_at VARCHAR(30),
    resolution_time_hours DECIMAL(10,2),
    priority VARCHAR(20),
    first_response_time_minutes INT,
    satisfaction_score DECIMAL(3,1) NULL,
    escalation_flag VARCHAR(10)
);
GO