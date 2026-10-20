
# Final Analysis
# Housing Prices in King County
# Housing Characteristics Analysis
# By Tianyue Jia
#============================================================

# Be sure to set your working directory

#============================================================
# Data about housing prices and characteristics
#============================================================

# Load dataset
library(readxl)
house <- read_excel("data.xlsx")

# Examine structure of the dataset
str(house)

# Summary statistics
summary(house)

#============================================================
# Isolate the variables needed for analysis
#============================================================

# Select relevant variables:
# price, living area, bedrooms, bathrooms, grade, zipcode, date
house_red <- house[, c("price",
                       "sqft_living",
                       "bedrooms",
                       "bathrooms",
                       "grade",
                       "zipcode",
                       "date")]

# Check structure of reduced dataset
str(house_red)

#============================================================
# Create new variable: log of price
#============================================================

# Log transformation of price
house_red$price <- as.numeric(house_red$price)
house_red$log_price <- log(house_red$price)

# Check summary of new variable
summary(house_red$log_price)

#============================================================
# Scatter plot: living area vs log price
#============================================================

# x = living area (predictor)
# y = log price (response variable)
plot(house_red$sqft_living,
     house_red$log_price,
     main = "Living Area and Log Housing Price",
     xlab = "Living Area (sqft)",
     ylab = "Log Price",
     pch = 16,
     col = "steelblue")

# Line of best fit (linear model)
abline(lm(log_price ~ sqft_living, data = house_red),
       col = "red",
       lwd = 2)

#============================================================
# Multiple linear regression model
#============================================================

# Model:
# log_price ~ housing characteristics + controls
model <- lm(log_price ~ sqft_living +
              bedrooms +
              bathrooms +
              grade +
              zipcode,
            data = house_red)

# View regression results
summary(model)

#============================================================
# Model Diagnostics: Residual Analysis
#============================================================

# Residual vs Fitted plot
# Scale-Location plot
par(mfrow = c(1, 2))

plot(model, which = 1)
plot(model, which = 3)

par(mfrow = c(1, 1))

# Breusch-Pagan test for heteroskedasticity
if (!requireNamespace("lmtest", quietly = TRUE)) {
  install.packages("lmtest")
}

bp_test <- lmtest::bptest(model)

print(bp_test)

#============================================================
# Weighted Least Squares (WLS)
#============================================================

# Use the same observations as the OLS model
model_data <- model.frame(model)

# Estimate error variance using OLS residuals
variance_model <- lm(
  log(residuals(model)^2 + 1e-6) ~ fitted(model)
)

# Calculate inverse-variance weights
estimated_variance <- exp(fitted(variance_model))

wls_weights <- 1 / estimated_variance

# Fit the WLS model
wls_model <- lm(
  formula(model),
  data = model_data,
  weights = wls_weights
)

# View WLS regression results
summary(wls_model)

#============================================================
# Compare OLS and WLS Model Fit
#============================================================

# Compare R-squared values
# Note: Weighted and unweighted R-squared
# values are not directly comparable.

model_fit <- data.frame(
  Model = c("OLS", "WLS"),
  R_squared = c(
    summary(model)$r.squared,
    summary(wls_model)$r.squared
  )
)

print(model_fit)

#============================================================
# Predictive Accuracy: OLS vs WLS
#============================================================

# Split data into training (80%) and testing (20%)
set.seed(2026)

train_index <- sample(
  seq_len(nrow(model_data)),
  size = floor(0.8 * nrow(model_data))
)

train <- model_data[train_index, ]
test <- model_data[-train_index, ]

# Fit OLS using training data
ols_train <- lm(
  formula(model),
  data = train
)

# Estimate conditional error variance
# using training data only
variance_train <- lm(
  log(residuals(ols_train)^2 + 1e-6) ~ fitted(ols_train)
)

# Calculate training weights
train_weights <- 1 / exp(fitted(variance_train))

# Fit WLS using training data
wls_train <- lm(
  formula(model),
  data = train,
  weights = train_weights
)

# Predict log prices on the testing dataset
ols_pred <- predict(
  ols_train,
  newdata = test
)

wls_pred <- predict(
  wls_train,
  newdata = test
)

# Calculate Root Mean Squared Error (RMSE)
ols_rmse <- sqrt(
  mean((test$log_price - ols_pred)^2)
)

wls_rmse <- sqrt(
  mean((test$log_price - wls_pred)^2)
)

# Calculate Mean Absolute Error (MAE)
ols_mae <- mean(
  abs(test$log_price - ols_pred)
)

wls_mae <- mean(
  abs(test$log_price - wls_pred)
)

# Compare predictive performance
comparison <- data.frame(
  Model = c("OLS", "WLS"),
  RMSE = c(ols_rmse, wls_rmse),
  MAE = c(ols_mae, wls_mae)
)

print(comparison)

# Evaluate prediction improvement
if (wls_rmse < ols_rmse) {
  print("WLS improved predictive accuracy based on test RMSE.")
} else {
  print("WLS did not improve predictive accuracy based on test RMSE.")
}

#============================================================
# End of Analysis
#============================================================
