### FINAL PROJECT WORKING SCRIPT
#### STEP 5. Modeling

# Load packages
library(caret)
library(randomForest)
library(xgboost)
library(e1071)      # For confusion matrix
library(pROC)       # For AUC if needed

set.seed(123)

# 1. Select features and target (drop leakage-prone variables)
model_data <- housing_model_data %>%
  select(
    -ZIP, -StateName,
    -PTI_Label, -PTI, -log_PTI,
    -AveragePrice2023, -Median_Income,
    -Median_Home_Value, -Median_Rent
  )

# 2. Split into train/test (70/30 stratified)
train_index <- createDataPartition(model_data$PTI_Binary, p = 0.7, list = FALSE)
train_data <- model_data[train_index, ]
test_data  <- model_data[-train_index, ]

# Drop rows with missing values
train_data <- na.omit(train_data)
test_data  <- na.omit(test_data)

# 3. Train Random Forest
rf_model <- randomForest(
  factor(PTI_Binary) ~ .,
  data = train_data,
  ntree = 500,
  importance = TRUE
)

# Predict and evaluate
rf_pred <- predict(rf_model, newdata = test_data)
rf_cm <- confusionMatrix(rf_pred, factor(test_data$PTI_Binary))
print(rf_cm)

# Feature importance
importance_df <- importance(rf_model)
varImpPlot(rf_model, main = "Random Forest Feature Importance")

# 4. Train XGBoost
# Prepare data
x_train <- model.matrix(PTI_Binary ~ . -1, data = train_data)
y_train <- train_data$PTI_Binary

x_test <- model.matrix(PTI_Binary ~ . -1, data = test_data)
y_test <- test_data$PTI_Binary

# Train XGBoost
xgb_model <- xgboost(
  data = x_train,
  label = y_train,
  nrounds = 100,
  objective = "binary:logistic",
  eval_metric = "error",
  verbose = 0
)

# Predict and evaluate
xgb_pred_probs <- predict(xgb_model, x_test)
xgb_pred <- ifelse(xgb_pred_probs > 0.5, 1, 0)
xgb_cm <- confusionMatrix(factor(xgb_pred), factor(y_test))
print(xgb_cm)

# AUC
xgb_roc <- roc(y_test, xgb_pred_probs)
cat("XGBoost AUC (No Rent):", auc(xgb_roc), "\n")

# Variable importance
xgb_imp <- xgb.importance(model = xgb_model)
xgb.plot.importance(xgb_imp, main = "XGBoost Feature Importance")