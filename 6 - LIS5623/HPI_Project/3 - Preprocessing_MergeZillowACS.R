### FINAL PROJECT WORKING SCRIPT
#### STEP 3. Merge Zillow + ACS data

# Requires earlier scripts so `zhvi_2023` and `acs_features` are already created

# Merge Zillow 2023 avg price data with ACS features
housing_data <- zhvi_2023 %>%
  inner_join(acs_features, by = "ZIP")

# Quick look at merged dataset
glimpse(housing_data)