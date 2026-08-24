# RavenStack SaaS Analytics

> **End-to-End Data Analytics & Power BI Business Intelligence Project**

**SQL Server • T-SQL • ETL • Bronze/Silver/Gold • Advanced SQL • Power BI • DAX**

---

## 📌 Project at a Glance

RavenStack SaaS Analytics is an end-to-end Business Intelligence project that transforms multi-table SaaS operational data into a business-ready analytics solution.

The project covers the complete workflow:

**Raw CSV Data → SQL Server ETL → Silver Transformation → Gold Reporting Model → SQL Analysis → Power BI + DAX → Business Insights**

The solution brings together **revenue, subscriptions, customers, product usage, customer support, and churn** into a single analytical framework.

### Business Domains

| Domain | Focus |
|---|---|
| 💰 Revenue | MRR, ARR, revenue contribution and growth |
| 📦 Subscriptions | Subscription base, upgrades and downgrades |
| 👥 Customers | Customer base, segmentation and status |
| 🔄 Churn | Churn rate, reasons, refunds and customer journey |
| 🚀 Product | Feature usage, duration and errors |
| 🎧 Support | Tickets, CSAT, response, resolution and escalation |

---

# 🎯 Business Problem

SaaS business data is distributed across multiple operational domains. Management needs a consolidated view to understand:

- How recurring revenue is performing
- Which plans, regions, industries and customer segments contribute most to revenue
- Which customers are active or churned
- Where churn is concentrated and why
- Which product features drive engagement and errors
- Where customer support workload and operational bottlenecks exist
- How support behavior can be investigated alongside retention risk

The project addresses this by creating a structured analytical pipeline and interactive Power BI reporting solution.

---

# 🚀 Project Objectives

- Build a layered **SQL Server Bronze/Silver/Gold architecture**
- Ingest raw SaaS CSV data
- Clean, standardize and deduplicate source data
- Normalize dates, numeric fields and Boolean values
- Create reusable business attributes and analytical bands
- Build a reporting-ready Gold model for Power BI
- Perform Basic and Advanced SQL analysis
- Develop business-focused DAX measures
- Create an interactive five-page Power BI report
- Convert analytical findings into actionable business recommendations

---

# 📊 Dataset

The project uses a synthetic SaaS dataset containing five related datasets.

| Dataset | Rows | Purpose |
|---|---:|---|
| `accounts.csv` | 500 | Customer/account master data |
| `subscriptions.csv` | 5,000 | Subscription, plan, seats, MRR/ARR and lifecycle data |
| `feature_usage.csv` | 25,000 | Product usage, duration and errors |
| `support_tickets.csv` | 2,000 | Support workload and service performance |
| `churn_events.csv` | 600 | Churn reasons, refunds, plan changes and feedback |

The source documentation describes the dataset as synthetic, with no PII, and containing temporal logic, relationships, nulls and edge cases.

---

# 🏗️ Architecture

```text
                 CSV SOURCE DATA
                       │
                       ▼
              ┌─────────────────┐
              │  BRONZE LAYER   │
              │  Raw Ingestion  │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │  SILVER LAYER   │
              │ Clean + Transform│
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │   GOLD LAYER    │
              │ Reporting Model │
              └────────┬────────┘
                       │
             ┌─────────┴─────────┐
             ▼                   ▼
      Advanced SQL          Power BI
                              │
                              ▼
                       DAX + Dashboards
                              │
                              ▼
                     Business Decisions
```

---

# 🔄 ETL Process

## Bronze

Raw CSV files are loaded into SQL Server while preserving the source structure.

## Silver

The Silver layer performs:

- Data type conversion
- Text standardization
- Boolean normalization
- Null handling
- Duplicate handling
- Business classification
- Analytical band creation

Examples include:

- Customer segment
- Seat band
- Revenue band
- Renewal status
- Usage count band
- Usage duration band
- Error status
- Resolution band
- Satisfaction category
- Refund band
- Customer journey

## Gold

The Gold layer provides reporting-ready dimensions and fact tables for Power BI.

### Gold Model

```text
dim_accounts
dim_date
dim_subscriptions

        ↓

fact_subscriptions
fact_feature_usage
fact_support_tickets
fact_churn
```

---

# 🧠 SQL Analysis

The project uses both **Basic SQL** and **Advanced SQL**.

### Basic Analysis

- Aggregations
- GROUP BY
- Business segmentation
- Revenue analysis
- Customer analysis
- Churn analysis
- Product usage analysis
- Support analysis

### Advanced Analysis

- CTEs
- Window functions
- `LAG`
- `RANK`
- `DENSE_RANK`
- Contribution-to-total analysis
- Cumulative revenue
- ARPU
- Customer value segmentation
- MoM growth
- YoY growth
- Rolling averages
- Cross-domain analysis

This extends the project beyond dashboard creation into analytical problem solving.

---

# 📈 Power BI Dashboard

The Power BI report contains five analytical areas:

### 1. Executive Overview

Provides a high-level view of business performance using core KPIs.

### 2. Revenue & Subscription

Analyzes:

- MRR
- ARR
- Subscription mix
- Revenue contribution
- Plan performance
- Customer attributes
- Upgrade/downgrade behavior
- Revenue trends

### 3. Customer & Churn

Analyzes:

- Total customers
- Active customers
- Churned customers
- Churn rate
- Churn reasons
- Customer segments
- Refunds
- Customer journey
- Reactivation

### 4. Product Usage

Analyzes:

- Total usage
- Average usage
- Usage duration
- Feature performance
- Error rate
- Beta vs stable features
- Usage by plan and customer segment

### 5. Customer Support

Analyzes:

- Ticket volume
- Priority
- CSAT
- Response time
- Resolution time
- Escalation rate
- Account-level support activity

---

# 📌 Key KPIs

## Revenue

- MRR
- ARR
- Average MRR
- Average ARR
- Revenue Growth

## Customer

- Total Customers
- Active Customers
- Churned Customers
- Churn Rate

## Subscription

- Total Subscriptions
- Upgrade Count
- Downgrade Count

## Product

- Total Usage
- Average Usage
- Usage Duration
- Total Errors
- Error Rate

## Support

- Total Tickets
- Average CSAT
- Average Response Time
- Average Resolution Time
- Escalation Rate

---

# 💡 Key Analytical Insights

The project enables analysis of several important business themes.

### Revenue Concentration

Revenue contribution can be evaluated by plan, country, region, industry and customer segment.

### Revenue Momentum

MoM, YoY and rolling-three-month analysis can be used together to distinguish short-term movement from sustained revenue trends.

### Customer Value

Customers can be segmented into:

- Enterprise
- High Value
- Medium Value
- Low Value

based on total MRR.

### Churn Concentration

Churn can be investigated by:

- Geography
- Industry
- Year
- Refund band
- Feedback
- Customer journey
- Reactivation
- Preceding plan changes

### Product Engagement

Feature usage can be evaluated through usage volume, duration, adoption, beta/stable status and errors.

### Support Performance

Support workload can be evaluated through ticket volume, priority, response time, resolution time, CSAT and escalation.

> **Important:** Final numerical findings should be taken directly from the published Power BI report. The project documentation does not invent dashboard values.

---

# 🎯 Business Recommendations

### 1. Monitor Revenue Concentration

Track dependency on high-contribution plans, regions and customer segments.

### 2. Prioritize High-Risk Churn Segments

Combine churn reason, customer journey, feature usage and support behavior when investigating retention risk.

### 3. Investigate Product Errors

Identify features with high adoption but high error contribution.

### 4. Improve Support Operations

Use response time, resolution time, CSAT and escalation to identify operational bottlenecks.

### 5. Monitor Revenue Trends

Use MoM, YoY and rolling averages together rather than relying on one period comparison.

### 6. Measure Business Impact

Track the same KPIs before and after an intervention to determine whether the recommendation improved performance.

---

# 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| **SQL Server** | Data warehouse and relational storage |
| **T-SQL** | ETL, cleaning and analysis |
| **Power BI** | Semantic model and dashboards |
| **DAX** | Business measures and KPI calculations |
| **Git/GitHub** | Version control and portfolio delivery |

---

# 📁 Repository Structure

```text
RavenStack-SaaS-Analytics/
│
├── README.md
│
├── data/
│   └── README.md
│
├── sql/
│   ├── 01_init_database.sql
│   ├── 02_bronze/
│   ├── 03_silver/
│   ├── 04_gold/
│   ├── 05_basic_analysis.sql
│   └── 06_advanced_analysis.sql
│
├── powerbi/
│   ├── RavenStack_SaaS_Analytics.pbix
│   └── screenshots/
│
├── dax/
│   └── Measures.md
│
└── Documentation/
    ├── Business_Problem.md
    ├── Data_Model.md
    ├── ETL.md
    ├── KPIs.md
    ├── Insights.md
    └── Recommendations.md
```

---

# 👨‍💻 Skills Demonstrated

### Data Engineering

- Layered data warehouse architecture
- ETL
- Data cleaning
- Data validation
- Deduplication
- Data transformation

### SQL

- Joins
- CTEs
- CASE
- Aggregations
- Date logic
- Window functions
- Ranking
- Contribution analysis
- Time-series analysis

### Power BI

- Data modeling
- Semantic model design
- Interactive dashboards
- KPI cards
- Slicers
- Drill-down analysis
- Business storytelling

### DAX

- KPI development
- Filter context
- Business calculations
- Time-based analysis
- Dynamic reporting

### Business Analytics

- Revenue analysis
- Customer segmentation
- Churn analysis
- Product engagement
- Support operations
- Root-cause investigation
- Recommendation development

---

# 📌 Portfolio Value

This project is **not only a dashboard project**.

It demonstrates an end-to-end analytics workflow:

```text
Raw Operational Data
        ↓
Data Engineering
        ↓
Data Cleaning
        ↓
Data Modeling
        ↓
SQL Analysis
        ↓
DAX KPI Development
        ↓
Power BI Dashboard
        ↓
Business Insights
        ↓
Actionable Recommendations
```

The project connects **Finance/Revenue, Customer Success, Product, and Support** into one analytical solution.

---

# ⚠️ Analytical Notes

Some SQL analysis blocks are exploratory and should be validated before being deployed as production objects.

For example, the supplied analysis documentation notes that a calculation labeled `total_downgrade` in Basic Analysis SQL should be reviewed against the intended `downgrade_flag` logic before being treated as a production KPI.

Relationships between support behavior and churn are analytical hypotheses and should not be presented as causal without additional evidence.

---

# 📚 Documentation

Detailed project documentation is available in:

```text
Documentation/
├── Business_Problem.md
├── Data_Model.md
├── ETL.md
├── KPIs.md
├── Insights.md
└── Recommendations.md
```

---

# 📊 Project Outcome

The final solution provides a single analytical framework connecting:

**Revenue + Customers + Subscriptions + Product Usage + Support + Churn**

This enables management to move from:

**"What happened?"**

to

**"Where did it happen?"**

to

**"What might be driving it?"**

to

**"What should we investigate or improve?"**

---

## Dataset Attribution

The supplied dataset documentation identifies **River @ Rivalytics** as the dataset author and requests attribution for educational/portfolio use.

---

## 👤 Author

**Vinit Nimbalkar**

**Data Analytics / Business Intelligence Portfolio Project**

**Tools:** SQL Server | T-SQL | Power BI | DAX | Git/GitHub
