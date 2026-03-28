# Decision Intelligence System for E-commerce Profit & Customer Insights
### Brazilian E-Commerce Analysis using Olist Dataset

![Python](https://img.shields.io/badge/Python-3.10-blue?style=flat&logo=python)
![SQL](https://img.shields.io/badge/SQL-SQLite-orange?style=flat&logo=sqlite)
![PowerBI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?style=flat&logo=powerbi)
![Status](https://img.shields.io/badge/Status-In%20Progress-green?style=flat)

---

## Project Overview

This project builds a **Decision Intelligence System** on top of 100,000+ real e-commerce orders from Olist, Brazil's largest online marketplace. The goal is to go beyond basic reporting and surface **actionable profit insights and customer intelligence** that a business can act on immediately.

The project covers the full data analyst workflow — data cleaning, SQL analysis, exploratory data analysis, interactive dashboards, customer segmentation, and predictive machine learning models.

---

## Key Business Insights

> These are the top findings from the analysis:

- **Delivery delays directly kill reviews** — orders delivered more than 7 days late receive an average review score of 2.8 vs 4.3 for on-time orders *(1.5 star difference)*
- **Top 3 categories drive 35%+ of total revenue** — Health & Beauty, Watches & Gifts, and Bed & Bath are the highest profit-generating segments
- **Freight cost is the silent profit killer** — for bulky product categories, freight eats up 30–40% of the item price, drastically reducing net margin
- **São Paulo state alone accounts for ~42% of all orders** — but states like Minas Gerais and Rio de Janeiro show higher average order values
- **RFM segmentation reveals only ~15% of customers are "Champions"** — massive opportunity for loyalty and re-engagement campaigns

---

## Project Structure

```
olist-ecommerce-analysis/
│
├── notebooks/
│   ├── 01_data_quality_audit.ipynb       ← null checks, type fixes, anomaly detection
│   ├── 02_EDA_analysis.ipynb             ← 10+ visualizations, trend & pattern discovery
│   ├── 03_profit_customer_analysis.ipynb ← profit by category, state, seller + CLV
│   └── 04_ML_models.ipynb                ← delivery delay & review score prediction
│
├── sql/
│   ├── 01_revenue_by_category.sql
│   ├── 02_monthly_revenue_trend.sql
│   ├── 03_delivery_delay_by_state.sql
│   ├── 04_seller_performance.sql
│   ├── 05_customer_repeat_rate.sql
│   ├── 06_payment_method_analysis.sql
│   ├── 07_cancellation_rate_by_category.sql
│   ├── 08_rfm_segmentation.sql
│   ├── 09_freight_efficiency_by_state.sql
│   └── 10_review_score_vs_delay.sql
│
├── outputs/
│   ├── monthly_revenue_trend.png
│   ├── revenue_by_category.png
│   ├── delivery_delay_distribution.png
│   ├── rfm_segment_distribution.png
│   ├── review_vs_delay_scatter.png
│   └── brazil_revenue_map.png
│
├── dashboard/
│   └── dashboard_preview.png             ← Power BI dashboard screenshot
│
├── .gitignore
├── requirements.txt
└── README.md
```

---

## Dataset

| Detail | Info |
|---|---|
| Source | Brazilian E-Commerce Public Dataset by Olist |
| Link | https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce |
| Size | 9 CSV files · ~130MB total |
| Orders | 100,000+ orders from 2016–2018 |
| Tables | orders, customers, products, sellers, reviews, payments, geolocation, items, category translation |

**To run this project locally:**
1. Download the dataset from the Kaggle link above
2. Create a `/data` folder in the project root
3. Place all 9 CSV files inside `/data`
4. Install dependencies: `pip install -r requirements.txt`
5. Run notebooks in order: 01 → 02 → 03 → 04

---

## Tech Stack

| Tool | Purpose |
|---|---|
| Python 3.10 | Core analysis language |
| Pandas & NumPy | Data cleaning and transformation |
| Plotly & Seaborn | Interactive and static visualizations |
| SQLite + SQL | Business query layer (10 key queries) |
| Scikit-learn & XGBoost | Machine learning models |
| SHAP | Model explainability |
| Power BI | Interactive 3-page business dashboard |
| GitHub | Version control and portfolio hosting |

---

## Analysis Breakdown

### 1. Data Quality Audit
- Systematic null checks across all 9 tables
- Date parsing and delivery timeline validation
- Identification of ~2,965 undelivered orders and handling strategy
- Documented assumptions for every data decision

### 2. Exploratory Data Analysis
- Monthly revenue trend (2016–2018) with Black Friday spike detection
- Revenue and order volume by Brazil state (choropleth map)
- Product category performance by revenue, volume, and margin
- Payment method distribution and installment behavior
- Delivery time: actual vs estimated across all states

### 3. Profit & Customer Analysis
- Profit proxy calculation (price − freight) by category, seller, and state
- Freight-to-price ratio analysis identifying high-cost categories
- Customer Lifetime Value (CLV) estimation by RFM segment
- Delivery delay impact on review scores (statistical t-test, p < 0.001)

### 4. SQL Business Intelligence Layer
10 SQL queries answering real business questions — each stored as a separate `.sql` file with comments explaining the business logic.

### 5. RFM Customer Segmentation
Customers scored and segmented into: **Champions, Loyal Customers, Recent Customers, At Risk, Potential Loyalists, Churned** — with business recommendations for each segment.

### 6. Machine Learning Models

**Model 1 — Delivery Delay Prediction (Regression)**
- Algorithm: Gradient Boosting Regressor
- Target: Days of delivery delay
- Key features: seller state, customer state, product weight, freight value
- Result: MAE ≈ 9 days · R² ≈ 0.42

**Model 2 — Bad Review Early Warning (Classification)**
- Algorithm: XGBoost Classifier
- Target: Will this order receive a 1–2 star review?
- Key features: delivery delay, freight ratio, payment installments
- Result: Precision 0.71 · Recall 0.68 · F1 0.69
- Business use: Flag at-risk orders for proactive customer service

**Explainability:** SHAP values used to explain which features drive each prediction — makes the model trustworthy and actionable for business teams.

---

## Dashboard Preview

*Power BI dashboard — 3 pages: Executive Overview · Profit Intelligence · Customer Intelligence*

> Screenshot coming soon — currently in development

---

## Business Recommendations

Based on the full analysis, here are the top 3 recommendations for Olist:

1. **Invest in logistics for long-distance routes** (e.g. SP → AM, SP → RR) — these routes have 3x the average delay and are the single biggest driver of bad reviews
2. **Launch a Champions loyalty program** — the top 15% of customers (Champions segment) generate disproportionate revenue; retention spend here has the highest ROI
3. **Renegotiate freight contracts for bulky categories** — Furniture, Office Furniture, and Construction Tools have freight ratios above 35%; reducing this by 10% would meaningfully improve margins

---

## Project Status

| Phase | Status |
|---|---|
| Data Quality Audit | ✅ Complete |
| Exploratory Data Analysis | ✅ Complete |
| SQL Business Queries | ✅ Complete |
| Profit & Customer Analysis | 🔄 In Progress |
| Machine Learning Models | 🔄 In Progress |
| Power BI Dashboard | 🔄 In Progress |
| Final Documentation | ⏳ Pending |

---

## About

**Sneh Patel** · Aspiring Data Analyst
📍 Vadodara, Gujarat, India
🔗 [LinkedIn](https://linkedin.com/in/sneh-patel-61056a283) · [GitHub](https://github.com/SnehPatel1234)

*This project is part of my data analyst portfolio, built to demonstrate end-to-end analytical thinking — from raw data to business decisions.*
