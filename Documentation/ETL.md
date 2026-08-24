# ETL

## RavenStack SaaS Analytics

The project follows a layered SQL Server architecture:

```text
CSV Sources
    ↓
Bronze
    ↓
Silver
    ↓
Gold
    ↓
Power BI
```

## 1. Bronze Layer

The Bronze layer is the raw ingestion stage.

### Purpose

- Load source CSV data
- Preserve the source structure
- Avoid applying business logic too early
- Provide a raw layer for downstream transformation

The database initialization creates the `bronze`, `silver`, and `gold` schemas.

## 2. Silver Layer

The Silver layer performs cleaning, standardization, type conversion, deduplication, and reusable business transformations.

### Accounts

Transformations include:

- `TRIM()` text fields
- `UPPER(TRIM(plan_tier))`
- `TRY_CONVERT()` for dates and numeric fields
- Boolean normalization to `1/0`
- Deduplication using `ROW_NUMBER()`
- Signup year/month/quarter attributes
- Customer segment
- Seat band
- Customer status
- Trial status
- Region

### Subscriptions

Transformations include:

- Date and numeric conversion
- Plan and billing standardization
- Boolean normalization
- Subscription type
- Renewal status
- Contract duration
- Revenue band

### Feature Usage

Transformations include:

- Usage date conversion
- Feature-name standardization
- Beta-feature normalization
- Usage count band
- Usage duration band
- Error status
- Feature status

### Support Tickets

Transformations include:

- Date conversion
- Escalation-flag normalization
- Resolution band
- Response-time band
- Satisfaction category
- Ticket status
- Escalation status

### Churn Events

Transformations include:

- Churn-date conversion
- Refund conversion
- Plan-change flags
- Reactivation flag
- Blank feedback handling with `NULLIF`
- Refund band
- Customer journey

## 3. Gold Layer

The Gold layer exposes reporting-ready dimensions and facts for Power BI.

Gold objects include:

- `gold.dim_accounts`
- `gold.dim_date`
- `gold.dim_subscriptions`
- `gold.fact_subscriptions`
- `gold.fact_feature_usage`
- `gold.fact_support_tickets`
- `gold.fact_churn`

## 4. Data Quality

The Silver transformation uses techniques such as:

- `TRY_CONVERT()` for safe type conversion
- `NULLIF()` for empty text handling
- `CASE` for controlled classification
- `ROW_NUMBER()` for duplicate handling
- Explicit Boolean normalization

The source data intentionally includes nulls and edge cases, so transformation logic is used to make the reporting layer consistent.

## 5. Analytical Layer

After ETL, Basic SQL and Advanced SQL analysis provide:

- Descriptive analysis
- Revenue contribution
- Rankings
- Cumulative revenue
- ARPU
- Customer-value segmentation
- MoM/YoY growth
- Rolling averages
- Churn/refund analysis
- Product engagement analysis
- Support-dependency analysis
