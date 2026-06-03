# 📈 IHSG Risk Driver and Monitoring Dashboard

## Objective

In this project, I designed and implemented an end-to-end data pipeline with the goal to identify periods of elevated market stress, classify market regimes, validate historical crisis events, and determine the dominant drivers behind market instability. The IHSG record used is from 1 January 2015 to 11 May 2026.

The framework combines four market dimensions:

- Drawdown Risk
- Volatility Risk
- Trading Activity Risk
- Price Gap Risk

These metrics are transformed into percentile ranks and aggregated into a crisis score used to classify market conditions.

---

## Business Problem

Financial markets experience periods of stress caused by different sources, such as:

- Global crises
- Geopolitical conflicts
- Monetary policy shocks
- Currency instability
- Trade disruptions

This project aims to provide a comprehensive view by combining multiple market stress indicators into a single framework.

---

## Methodology

### 1. Metrics Definition

Four market risk indicators were defined as:

| Metric | Description |
|----------|----------|
| Drawdown | Peak-to-trough decline |
| Volatility | Rolling market volatility |
| Trading Ratio | Trading activity anomaly |
| Gap Percentage | Opening gap behavior |

### 2. Percentile Ranking

Each metric is converted into a percentile rank:

```text
0.00 = Lowest historical risk
1.00 = Highest historical risk
```

### 3. Crisis Score

A composite crisis score is calculated from:

- Drawdown Rank
- Volatility Rank
- Trading Ratio Rank
- Gap Rank
```

### 4. Market Regime Classification

| Crisis Score | Market Status |
|----------|----------|
| < 30% | Normal |
| 30% – 60% | Caution |
| 60% – 90% | Stress |
| ≥ 90% | Crisis |

---

## Event Validation

| Event | Period |
|----------|----------|
| Yuan Devaluation | Jun 2015 – Feb 2016 |
| Fed Rate Hikes | Jan 2018 – Dec 2018 |
| COVID-19 Pandemic | Mar 2020 – Mar 2021 |
| US-China Trade War | Feb 2025 – Oct 2025 |
| Iran War | Feb 2026 – Apr 2026 |

---

## Key Findings

- COVID-19 generated the highest market stress levels.
- Volatility is currently the dominant risk driver.
- Different events produce distinct market stress signatures.
- Market stress can be decomposed into multiple underlying drivers.

---

## Technical Stack

### Data Processing
- Microsoft Excel/Power Query
- MySQL
- CTE & Window Function

### Analytics
- Percentile Ranking
- Market Regime Classification
- Crisis Scoring
- Event Validation

### Visualization
- Power BI
- DAX