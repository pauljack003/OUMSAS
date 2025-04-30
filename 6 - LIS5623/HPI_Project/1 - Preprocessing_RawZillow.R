### FINAL PROJECT WORKING SCRIPT
#### STEP 1. Zillow Data

zhvi<- read.csv("ZILLOW_ZHVI.csv")
str(zhvi)
colnames(zhvi)

### PREPROCESSING ZILLOW DATA

library(dplyr)

# 1. Select necessary columns: RegionName, StateName, and 2023 monthly prices
zhvi_2023 <- zhvi %>%
  select(RegionName, StateName,
         X2023.01.31, X2023.02.28, X2023.03.31, X2023.04.30,
         X2023.05.31, X2023.06.30, X2023.07.31, X2023.08.31,
         X2023.09.30, X2023.10.31, X2023.11.30, X2023.12.31)

# 2. Calculate the 2023 average home price
zhvi_2023 <- zhvi_2023 %>%
  rowwise() %>%
  mutate(AveragePrice2023 = mean(c_across(starts_with("X2023")), na.rm = TRUE)) %>%
  ungroup()

# 3. Keep only RegionName, StateName, and AveragePrice2023
zhvi_2023 <- zhvi_2023 %>%
  select(RegionName, StateName, AveragePrice2023)

# 4. Convert RegionName (ZIP code) to a 5-character string with leading zeros
zhvi_2023 <- zhvi_2023 %>%
  mutate(ZIP = sprintf("%05d", RegionName)) %>%
  select(ZIP, StateName, AveragePrice2023)

# 5. Sanity check
head(zhvi_2023)
