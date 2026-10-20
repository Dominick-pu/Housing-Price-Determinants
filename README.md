# Housing Price Determinants

## Project Overview

This project investigates the determinants of residential property prices in King County, Washington, using R and econometric modeling techniques. The analysis examines how housing quality, living area, bedrooms, bathrooms, and geographic location are associated with property sale prices.

The project uses a dataset containing 21,613 housing transactions and applies multiple linear regression, residual diagnostics, and Weighted Least Squares (WLS).

## Methodology

**1. Data Preparation and Exploratory Analysis**
- Examined housing characteristics and descriptive statistics.
- Applied a logarithmic transformation to housing prices.
- Visualized the relationship between living area and log-transformed housing prices.

**2. Multiple Linear Regression**
- Developed an Ordinary Least Squares (OLS) regression model.
- Included living area, bedrooms, bathrooms, housing grade, and ZIP code as explanatory variables.
- Evaluated model fit and regression coefficient significance.

**3. Model Diagnostics and WLS**
- Conducted residual analysis to evaluate model assumptions.
- Applied the Breusch-Pagan test to detect heteroskedasticity.
- Implemented Weighted Least Squares (WLS) using estimated inverse-variance weights.
- Compared OLS and WLS predictive performance using an 80/20 training-testing split.

## Key Findings

- The OLS model achieved an R² of **0.5694**, explaining approximately 57% of the variation in log housing prices.
- Housing grade was a highly significant predictor, with a coefficient of **0.1881** (p < 0.001).
- The Breusch-Pagan test identified statistically significant heteroskedasticity (p < 2.2 × 10⁻¹⁶).
- WLS produced marginally lower prediction errors than OLS on the test dataset.

### Model Performance

| Model | Test RMSE | Test MAE |
|---|---|---|
| OLS | 0.3472992 | 0.2797388 |
| WLS | 0.3472988 | 0.2796930 |

Prediction errors are evaluated on the log-price scale. The improvement from WLS was negligible.

## Tools and Techniques

- **Programming Language:** R
- **Statistical Methods:** Multiple Linear Regression, Ordinary Least Squares, Weighted Least Squares
- **Diagnostics:** Residual Analysis, Breusch-Pagan Test
- **Evaluation:** R², RMSE, MAE
- **Libraries:** readxl, lmtest

## Author

**Tianyue Jia**  
Purdue University  
B.S. in Agribusiness — Agri Finance Concentration
