# Recommendations

## RavenStack SaaS Analytics

Recommendations should be tied to verified findings from the final Power BI report and SQL analysis.

Use the following structure:

```text
Finding
   ↓
Root-Cause Hypothesis
   ↓
Action
   ↓
Success Metric
```

## 1. Monitor Revenue Concentration

Use revenue contribution analysis to monitor dependency on high-contribution:

- Plans
- Regions
- Industries
- Customer segments

### Suggested Success Metrics

- MRR
- ARR
- Revenue contribution %
- Revenue growth

---

## 2. Prioritize High-Risk Churn Segments

Prioritize churn investigation where churn contribution and refund contribution are simultaneously high.

Combine:

- Churn reason
- Customer journey
- Feature usage
- Support behavior
- Reactivation
- Plan changes

### Suggested Success Metrics

- Churn Rate
- Churned Customers
- Refund Amount
- Reactivation Rate

---

## 3. Investigate Product Adoption and Errors

Use usage and error analysis to identify features with:

- High adoption and high errors
- Low adoption
- Long usage duration
- Strong beta-feature activity

### Suggested Actions

- Investigate high-error/high-usage features
- Compare feature behavior across plans and customer segments
- Use adoption gaps to guide product or onboarding analysis

### Suggested Success Metrics

- Feature Usage
- Usage Duration
- Error Rate
- Feature Adoption

---

## 4. Improve Support Operations

Use support priority, response time, resolution time, CSAT, and escalation analysis to identify operational bottlenecks.

### Suggested Actions

- Prioritize high-volume or high-escalation support categories
- Investigate long response and resolution times
- Monitor support workload at account level

### Suggested Success Metrics

- Average Response Time
- Average Resolution Time
- CSAT
- Escalation Rate
- Ticket Volume

---

## 5. Monitor Revenue Trends Using Multiple Time Views

Monitor:

- MoM growth
- YoY growth
- Rolling three-month average

rather than relying on a single-period movement.

### Business Benefit

This provides a more reliable view of revenue momentum and helps distinguish temporary changes from sustained trends.

---

## 6. Measure Recommendation Impact

Track the same KPIs used in the dashboard after implementing an intervention.

```text
Recommendation
      ↓
Target Segment
      ↓
KPI Baseline
      ↓
Intervention
      ↓
Post-Intervention KPI
      ↓
Business Impact
```

This makes recommendations measurable rather than purely descriptive.

---

## Important Analytical Note

Support and churn relationships in the project are analytical hypotheses to investigate. They should not be described as causal relationships unless additional evidence supports causality.

The recommendations should therefore be framed as actions for investigation, prioritization, and measurement rather than unsupported causal claims.
