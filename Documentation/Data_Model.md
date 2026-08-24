# Data Model

## RavenStack SaaS Analytics

The Gold layer provides a reporting-oriented model for Power BI. The project separates reusable dimensions from event/fact data so that business analysis can be performed across customers, subscriptions, product usage, support, churn, and time.

## Gold Tables

### Dimensions

| Table | Purpose |
|---|---|
| `gold.dim_accounts` | Customer/account attributes |
| `gold.dim_date` | Date analysis and time intelligence |
| `gold.dim_subscriptions` | Subscription-level descriptive attributes |

### Fact Tables

| Table | Purpose |
|---|---|
| `gold.fact_subscriptions` | Subscription and recurring-revenue events |
| `gold.fact_feature_usage` | Product feature usage events |
| `gold.fact_support_tickets` | Customer support activity |
| `gold.fact_churn` | Customer churn events |

## Core Relationships

```text
dim_accounts
     │
     ├──────────────< fact_subscriptions
     │
     ├──────────────< fact_support_tickets
     │
     └──────────────< fact_churn

dim_subscriptions
     │
     ├──────────────< fact_subscriptions
     │
     └──────────────< fact_feature_usage

dim_date
     │
     ├──────────────< fact_subscriptions
     ├──────────────< fact_feature_usage
     ├──────────────< fact_support_tickets
     └──────────────< fact_churn
```

## Modeling Objective

The model is designed to support:

- Revenue analysis
- Subscription movement
- Customer segmentation
- Churn analysis
- Product engagement
- Support performance
- Time-based analysis

## Business Dimensions

Key slicing dimensions include:

- Plan Tier
- Region
- Country
- Industry
- Customer Segment
- Seat Band
- Trial Status
- Customer Status
- Feature
- Support Priority
- Customer Journey
- Date

## Power BI Usage

The Gold model is consumed by Power BI for DAX calculations, interactive filtering, KPI cards, trend analysis, and drill-down reporting.

