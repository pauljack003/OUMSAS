### FINAL PROJECT WORKING SCRIPT
#### STEP 4. PTI + Over/Undervalued Classification

### Load required libraries
library(dplyr)
library(ggplot2)
library(ggpubr)   # For QQ plots
library(e1071)    # For skewness()

# 1. Compute PTI (Price-to-Income Ratio)
housing_data <- housing_data %>%
  mutate(
    PTI = AveragePrice2023 / Median_Income
  )

# 2. Distributional Analysis (Original PTI)

# Basic statistics
pti_stats <- housing_data %>%
  summarize(
    Mean = mean(PTI, na.rm = TRUE),
    Median = median(PTI, na.rm = TRUE),
    SD = sd(PTI, na.rm = TRUE),
    Skewness = skewness(PTI, na.rm = TRUE)
  )
print(pti_stats)

# Histogram + Density
ggplot(housing_data, aes(x = PTI)) +
  geom_histogram(aes(y = ..density..), bins = 50, fill = "skyblue", color = "black", alpha = 0.7) +
  geom_density(color = "darkred", size = 1.2) +
  labs(title = "Distribution of PTI (Price-to-Income Ratio)", x = "PTI", y = "Density") +
  theme_minimal()

# Q-Q Plot
ggqqplot(housing_data$PTI, title = "Q-Q Plot of PTI")

# Shapiro-Wilk Test (sampled)
set.seed(42)
shapiro.test(sample(housing_data$PTI, 5000))

# 3. Log-Transform PTI
housing_data <- housing_data %>%
  mutate(
    log_PTI = log(PTI)
  )

# Summary stats for log(PTI)
log_pti_stats <- housing_data %>%
  summarize(
    Mean_log_PTI = mean(log_PTI, na.rm = TRUE),
    Median_log_PTI = median(log_PTI, na.rm = TRUE),
    SD_log_PTI = sd(log_PTI, na.rm = TRUE),
    Skewness_log_PTI = skewness(log_PTI, na.rm = TRUE)
  )
print(log_pti_stats)

# Histogram of log(PTI)
ggplot(housing_data, aes(x = log_PTI)) +
  geom_histogram(aes(y = ..density..), bins = 50, fill = "skyblue", color = "black", alpha = 0.7) +
  geom_density(color = "darkred", size = 1.2) +
  labs(title = "Distribution of log(PTI)", x = "log(PTI)", y = "Density") +
  theme_minimal()

# Q-Q Plot for log(PTI)
ggqqplot(housing_data$log_PTI, title = "Q-Q Plot of log(PTI)")

# 4. Classify ZIP Codes Using log(PTI)

# Define thresholds
mean_log_pti <- log_pti_stats$Mean_log_PTI
sd_log_pti <- log_pti_stats$SD_log_PTI

upper_thresh <- mean_log_pti + sd_log_pti
lower_thresh <- mean_log_pti - sd_log_pti

# Label ZIP codes
housing_data <- housing_data %>%
  mutate(
    PTI_Label = case_when(
      log_PTI > upper_thresh ~ "Overvalued",
      log_PTI < lower_thresh ~ "Undervalued",
      TRUE ~ "Fairly Valued"
    )
  )

# View class counts
table(housing_data$PTI_Label)

# 5. Filter to only mispriced ZIP codes for modeling
housing_model_data <- housing_data %>%
  filter(PTI_Label != "Fairly Valued") %>%
  mutate(
    PTI_Binary = ifelse(PTI_Label == "Overvalued", 1, 0)
  )