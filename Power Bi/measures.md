# DAX Measures

## RavenStack SaaS Business Analytics

This document contains the key DAX measures used in the Power BI semantic model.

The measures are organized according to the major business areas of the project:

- Revenue & Subscription
- Customer & Churn
- Product Usage
- Customer Support
- Executive KPIs

---

# 1. Executive KPIs

## Active Customers

```DAX
Active Customers =
CALCULATE(
    [Total Customers],
    dim_accounts[customer_status] = "Active"
)
```

**Definition:**  
Number of customers currently classified as active.

**Business Purpose:**  
Measures the current active customer base.

**Dashboard:**  
Executive Overview

---

## Total Customers

```DAX
Total Customers =
DISTINCTCOUNT(
    dim_accounts[account_id]
)
```

**Definition:**  
Total number of unique customer accounts.

**Business Purpose:**  
Measures the overall customer base.

**Dashboard:**  
Executive Overview

---

## Churned Customers

```DAX
Churned Customers =
CALCULATE(
    [Total Customers],
    dim_accounts[customer_status] = "Churned"
)
```

**Definition:**  
Number of customers classified as churned.

**Business Purpose:**  
Measures the size of the lost customer base.

**Dashboard:**  
Customer & Churn

---

# 2. Revenue Measures

## MRR

```DAX
MRR =
SUM(
    fact_subscriptions[mrr_amount]
)
```

**Definition:**  
Monthly Recurring Revenue generated from subscriptions.

**Business Purpose:**  
Measures recurring monthly revenue performance.

**Dashboard:**  
Executive Overview  
Revenue & Subscription

---

## ARR

```DAX
ARR =
SUM(
    fact_subscriptions[arr_amount]
)
```

**Definition:**  
Annual Recurring Revenue generated from subscriptions.

**Business Purpose:**  
Measures the annualized recurring revenue base.

**Dashboard:**  
Executive Overview  
Revenue & Subscription

---

## Average MRR

```DAX
Avg MRR =
AVERAGE(
    fact_subscriptions[mrr_amount]
)
```

**Definition:**  
Average MRR across subscription records.

**Business Purpose:**  
Helps compare average recurring revenue across segments.

---

## Average ARR

```DAX
Avg ARR =
AVERAGE(
    fact_subscriptions[arr_amount]
)
```

**Definition:**  
Average ARR across subscription records.

**Business Purpose:**  
Helps compare average annual recurring revenue across segments.

---

# 3. Subscription Measures

## Total Subscription

```DAX
Total Subscription =
COUNTROWS(
    fact_subscriptions
)
```

**Definition:**  
Total number of subscription records.

**Business Purpose:**  
Measures the size of the subscription base.

---

## Upgrade Count

```DAX
Upgrade Count =
CALCULATE(
    COUNTROWS(fact_subscriptions),
    fact_subscriptions[upgrade_flag] = 1
)
```

**Definition:**  
Number of subscription records associated with an upgrade.

**Business Purpose:**  
Measures positive subscription movement.

**Dashboard:**  
Revenue & Subscription

---

## Downgrade Count

```DAX
Downgrade Count =
CALCULATE(
    COUNTROWS(fact_subscriptions),
    fact_subscriptions[downgrade_flag] = 1
)
```

**Definition:**  
Number of subscription records associated with a downgrade.

**Business Purpose:**  
Measures negative subscription movement.

**Dashboard:**  
Revenue & Subscription

---

# 4. Churn Measures

## Churn Rate

```DAX
Churn Rate =
DIVIDE(
    [Churned Customers],
    [Total Customers],
    0
)
```

**Definition:**  
Percentage of customers classified as churned.

**Business Purpose:**  
Primary customer retention KPI.

**Business Question:**  
> How significant is customer attrition?

**Dashboard:**  
Executive Overview  
Customer & Churn

---

## Total Churn Events

```DAX
Total Churn Events =
COUNTROWS(
    fact_churn
)
```

**Definition:**  
Total number of recorded churn events.

**Business Purpose:**  
Measures churn-event volume.

---

## Total Refund

```DAX
Total Refund =
SUM(
    fact_churn[refund_amount_usd]
)
```

**Definition:**  
Total refund amount associated with churn events.

**Business Purpose:**  
Measures the financial impact of churn.

**Dashboard:**  
Customer & Churn

---

# 5. Product Usage Measures

## Total Usage

```DAX
Total Usage =
SUM(
    fact_feature_usage[usage_count]
)
```

**Definition:**  
Total recorded product feature usage.

**Business Purpose:**  
Measures overall product engagement.

**Dashboard:**  
Product Usage

---

## Average Usage

```DAX
Avg Usage =
AVERAGE(
    fact_feature_usage[usage_count]
)
```

**Definition:**  
Average usage per usage record.

**Business Purpose:**  
Helps compare engagement levels across features, plans and customer segments.

---

## Usage Duration

```DAX
Usage Duration =
SUM(
    fact_feature_usage[usage_duration_secs]
)
```

**Definition:**  
Total recorded feature-usage duration in seconds.

**Business Purpose:**  
Measures depth of product engagement.

---

## Total Error

```DAX
Total Error =
SUM(
    fact_feature_usage[error_count]
)
```

**Definition:**  
Total number of recorded product errors.

**Business Purpose:**  
Helps identify product-quality issues.

---

## Error Rate

```DAX
Error Rate =
DIVIDE(
    [Total Error],
    [Total Usage],
    0
)
```

**Definition:**  
Errors relative to recorded product usage.

**Business Purpose:**  
Provides a normalized product-quality indicator.

---

# 6. Customer Support Measures

## Total Tickets

```DAX
Total Tickets =
COUNTROWS(
    fact_support_tickets
)
```

**Definition:**  
Total number of customer-support tickets.

**Business Purpose:**  
Measures support workload.

**Dashboard:**  
Customer Support

---

## Average CSAT

```DAX
Average CSAT =
AVERAGE(
    fact_support_tickets[satisfaction_score]
)
```

**Definition:**  
Average customer satisfaction score.

**Business Purpose:**  
Measures customer satisfaction with support interactions.

**Dashboard:**  
Executive Overview  
Customer Support

---

## Average Response Time

```DAX
Avg Response Time =
AVERAGE(
    fact_support_tickets[first_response_time_minutes]
)
```

**Definition:**  
Average time taken to provide the first response.

**Business Purpose:**  
Measures support responsiveness.

**Dashboard:**  
Customer Support

---

## Average Resolution Time

```DAX
Avg Resolution Time =
AVERAGE(
    fact_support_tickets[resolution_time_hours]
)
```

**Definition:**  
Average time required to resolve a support ticket.

**Business Purpose:**  
Measures support-resolution efficiency.

**Dashboard:**  
Customer Support

---

## Escalation Rate

```DAX
Escalation Rate =
DIVIDE(
    CALCULATE(
        COUNTROWS(fact_support_tickets),
        fact_support_tickets[escalation_flag] = 1
    ),
    [Total Tickets],
    0
)
```

**Definition:**  
Percentage of support tickets that were escalated.

**Business Purpose:**  
Measures support complexity and service risk.

**Dashboard:**  
Customer Support

---

# 7. KPI Summary

| Business Area | KPI | Purpose |
|---|---|---|
| Executive | Active Customers | Monitor active customer base |
| Executive | MRR | Monitor recurring revenue |
| Executive | ARR | Monitor annual recurring revenue |
| Executive | Churn Rate | Monitor retention |
| Executive | Average CSAT | Monitor customer satisfaction |
| Revenue | MRR | Measure recurring revenue |
| Revenue | ARR | Measure annualized revenue |
| Subscription | Total Subscription | Measure subscription base |
| Subscription | Upgrade Count | Monitor upgrades |
| Subscription | Downgrade Count | Monitor downgrades |
| Customer | Total Customers | Measure customer base |
| Customer | Churned Customers | Measure customer loss |
| Churn | Churn Rate | Measure retention risk |
| Churn | Total Refund | Measure financial churn impact |
| Product | Total Usage | Measure product engagement |
| Product | Usage Duration | Measure engagement depth |
| Product | Error Rate | Monitor product quality |
| Support | Total Tickets | Measure support workload |
| Support | Average CSAT | Measure satisfaction |
| Support | Avg Response Time | Measure responsiveness |
| Support | Avg Resolution Time | Measure resolution efficiency |
| Support | Escalation Rate | Measure support complexity |

---

# 8. Business Questions Answered

### Revenue

- How much recurring revenue are we generating?
- What is the annual recurring revenue base?
- How does revenue vary across customer segments?

### Customers & Churn

- How large is the customer base?
- How many customers are active?
- How many customers have churned?
- How significant is customer attrition?
- What is the financial impact of churn?

### Product Usage

- How actively are customers using the product?
- What is the average usage level?
- How much time are customers spending using features?
- Are product errors significant relative to usage?

### Customer Support

- How much support demand exists?
- How satisfied are customers?
- How quickly does support respond?
- How quickly are issues resolved?
- How frequently are tickets escalated?

---

# 9. DAX → Business Value

The DAX layer converts the Gold data model into a business-facing KPI layer.

```text
Gold Data Model
       ↓
   DAX Measures
       ↓
   Business KPIs
       ↓
 Power BI Dashboard
       ↓
 Business Insights
       ↓
 Business Decisions
```

The measures enable management to monitor:

- Revenue performance
- Customer retention
- Subscription movement
- Product engagement
- Product quality
- Customer support performance

---

# 10. DAX Design Principles

### Reusable Measures

Business calculations are created as reusable measures and used across multiple visuals.

### Filter-Aware Analysis

Measures respond dynamically to Power BI filters and slicers such as:

- Date
- Plan Tier
- Region
- Industry
- Customer Segment
- Trial Status
- Feature
- Support Priority

### Safe Ratio Calculations

`DIVIDE()` is used for ratio and percentage calculations to safely handle zero denominators.

### Business-Oriented Metrics

The DAX layer is designed around business questions rather than calculations created only for individual visuals.

---

## Note

The formulas documented here should remain synchronized with the final Power BI `.pbix` model.

Business-specific KPIs such as Churn Rate, Activation Rate and Error Rate should be validated against the final agreed business definitions before being used for decision-making.
