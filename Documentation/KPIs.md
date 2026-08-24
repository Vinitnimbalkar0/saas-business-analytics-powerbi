# KPIs

## RavenStack SaaS Analytics

The KPI framework translates the Gold data model into business-facing measures for Power BI.

## Executive KPIs

| KPI | Business Purpose |
|---|---|
| Active Customers | Monitor the active customer base |
| MRR | Monitor recurring monthly revenue |
| ARR | Monitor annual recurring revenue |
| Churn Rate | Monitor customer retention |
| Average CSAT | Monitor customer satisfaction |

## Revenue & Subscription KPIs

| KPI | Business Purpose |
|---|---|
| MRR | Measure recurring monthly revenue |
| ARR | Measure annual recurring revenue |
| Average MRR | Compare average recurring revenue |
| Average ARR | Compare average annual recurring revenue |
| Total Subscription | Measure the subscription base |
| Upgrade Count | Monitor positive subscription movement |
| Downgrade Count | Monitor negative subscription movement |

## Customer & Churn KPIs

| KPI | Business Purpose |
|---|---|
| Total Customers | Measure the customer base |
| Active Customers | Measure active customers |
| Churned Customers | Measure customer loss |
| Churn Rate | Measure retention risk |
| Total Churn Events | Measure churn-event volume |
| Total Refund | Measure the financial impact of churn |

## Product Usage KPIs

| KPI | Business Purpose |
|---|---|
| Total Usage | Measure product engagement |
| Average Usage | Compare usage intensity |
| Usage Duration | Measure engagement depth |
| Total Error | Monitor product issues |
| Error Rate | Monitor errors relative to usage |

## Customer Support KPIs

| KPI | Business Purpose |
|---|---|
| Total Tickets | Measure support workload |
| Average CSAT | Measure customer satisfaction |
| Avg Response Time | Measure support responsiveness |
| Avg Resolution Time | Measure resolution efficiency |
| Escalation Rate | Measure support complexity |

## KPI Design Principle

The KPI framework is organized around business questions rather than individual visuals:

```text
Revenue
   ↓
Customer Retention
   ↓
Product Engagement
   ↓
Support Performance
   ↓
Business Decision
```

> **Important:** Final numerical values and business-specific KPI definitions should be taken from the final PBIX report and validated against the implemented DAX measures.
