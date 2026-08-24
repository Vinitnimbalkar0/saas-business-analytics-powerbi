# Insights

## RavenStack SaaS Analytics

The project establishes several evidence-backed analytical themes. The documentation does not invent numerical findings; final numerical values should be taken from the published Power BI report.

## 1. Revenue Concentration

Revenue is analyzed across:

- Plan Tier
- Country
- Region
- Industry
- Customer Segment
- Customer Status

Advanced SQL calculates contribution to total MRR/ARR for these groups.

### Business Implication

Management can identify which plans, regions, industries, and customer segments have the greatest influence on recurring revenue.

---

## 2. Revenue Momentum

The project analyzes:

- MoM growth
- YoY growth
- Rolling three-month averages
- Variance from average revenue

### Business Implication

Using multiple time-based measures helps distinguish short-term movement from sustained revenue trends.

---

## 3. Customer Value

Advanced analysis segments customers according to total MRR into:

- Enterprise
- High Value
- Medium Value
- Low Value

### Business Implication

Customer-success and revenue teams can prioritize analysis of high-value accounts and understand how revenue is distributed across the customer base.

---

## 4. Churn Concentration

Churn is analyzed by:

- Country
- Industry
- Year
- Refund Band
- Feedback
- Customer Journey
- Reactivation
- Preceding Plan Changes

### Business Implication

Churn should be investigated at the segment and customer-journey level rather than relying only on an overall churn rate.

---

## 5. Product Engagement

Feature usage is analyzed by:

- Feature
- Plan
- Customer Segment
- Beta/Stable status
- Usage Duration
- Errors

### Business Implication

The business can identify highly adopted features, low-engagement areas, and features where high adoption is accompanied by high error contribution.

---

## 6. Support Workload

Support analysis covers:

- Ticket volume
- Priority
- First-response time
- Resolution time
- CSAT
- Escalation
- Account-level workload

### Business Implication

Support teams can identify operational bottlenecks and customer groups generating significant service demand.

---

## 7. Support and Churn Relationship

The SQL analysis investigates support dependency across churn and connects customer journey with support response time.

These are analytical relationships and hypotheses to investigate, **not proof of causality**.

### Business Implication

Support behavior can be used as an additional dimension when investigating retention risk.

---

## Insight Validation Framework

For each final dashboard insight, document:

1. **Observation** — What changed or differs?
2. **Segmentation** — Which plan, region, industry, customer segment, feature, or priority is involved?
3. **Comparison** — How does it compare with another group or period?
4. **Potential Driver** — What additional evidence could validate the cause?
5. **Business Impact** — Why does the finding matter?
