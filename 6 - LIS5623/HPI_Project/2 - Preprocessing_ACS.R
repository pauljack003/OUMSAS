### FINAL PROJECT WORKING SCRIPT
#### STEP 2. ACS data

# Load libraries
library(dplyr)
library(readr)
library(purrr)

# Cleaning function
clean_acs <- function(file_path, var_codes, new_names) {
  df <- read_csv(file_path, show_col_types = FALSE) %>%
    filter(NAME != "Geographic Area Name") %>%
    mutate(
      ZIP = substr(NAME, 7, 11)
    ) %>%
    select(ZIP, all_of(var_codes)) %>%
    mutate(across(all_of(var_codes), as.numeric))
  
  # Rename columns
  names(df)[2:(length(new_names)+1)] <- new_names
  
  return(df)
}

# Clean each dataset individually
b01002_clean <- clean_acs("ACSDT5Y2023.B01002-Data.csv", c("B01002_001E"), c("Median_Age"))
b01003_clean <- clean_acs("ACSDT5Y2023.B01003-Data.csv", c("B01003_001E"), c("Total_Population"))
b05002_clean <- clean_acs("ACSDT5Y2023.B05002-Data.csv", c("B05002_013E"), c("Pct_Foreign_Born"))
b07003_clean <- clean_acs("ACSDT5Y2023.B07003-Data.csv", c("B07003_001E", "B07003_007E"), c("Total_Residents", "Moved_Past_Year"))
b08303_clean <- clean_acs("ACSDT5Y2023.B08303-Data.csv", c("B08303_001E"), c("Mean_Commute_Time"))
b15003_clean <- clean_acs("ACSDT5Y2023.B15003-Data.csv", sprintf("B15003_%03dE", 1:25), paste0("Edu_", 1:25))  # Will derive % BA later
b17001_clean <- clean_acs("ACSDT5Y2023.B17001-Data.csv", c("B17001_001E", "B17001_002E"), c("Poverty_Universe", "Below_Poverty"))
b19013_clean <- clean_acs("ACSDT5Y2023.B19013-Data.csv", c("B19013_001E"), c("Median_Income"))
b23025_clean <- clean_acs("ACSDT5Y2023.B23025-Data.csv", c("B23025_003E", "B23025_005E"), c("Labor_Force", "Employed"))
b25001_clean <- clean_acs("ACSDT5Y2023.B25001-Data.csv", c("B25001_001E"), c("Housing_Units"))
b25003_clean <- clean_acs("ACSDT5Y2023.B25003-Data.csv", c("B25003_002E", "B25003_003E"), c("Owner_Occupied", "Renter_Occupied"))
b25004_clean <- clean_acs("ACSDT5Y2023.B25004-Data.csv", c("B25004_001E", "B25004_003E"), c("Total_Units_Vacancy", "Vacant"))
b25010_clean <- clean_acs("ACSDT5Y2023.B25010-Data.csv", c("B25010_001E"), c("Avg_Household_Size"))
b25034_clean <- clean_acs("ACSDT5Y2023.B25034-Data.csv", c("B25034_010E"), c("Pre1980_Units"))
b25064_clean <- clean_acs("ACSDT5Y2023.B25064-Data.csv", c("B25064_001E"), c("Median_Rent"))
b25077_clean <- clean_acs("ACSDT5Y2023.B25077-Data.csv", c("B25077_001E"), c("Median_Home_Value"))

# Merge them all together by ZIP
acs_combined <- reduce(
  list(
    b01002_clean, b01003_clean, b05002_clean, b07003_clean, b08303_clean,
    b15003_clean, b17001_clean, b19013_clean, b23025_clean, b25001_clean,
    b25003_clean, b25004_clean, b25010_clean, b25034_clean, b25064_clean, b25077_clean
  ),
  full_join,
  by = "ZIP"
)

# Feature Engineering
acs_features <- acs_combined %>%
  mutate(
    # Safe % moved calculation
    Pct_Moved = ifelse(!is.na(Moved_Past_Year) & !is.na(Total_Residents) & Total_Residents != 0,
                       Moved_Past_Year / Total_Residents,
                       NA),

    # % Bachelor's or higher
    Pct_Bachelors_Higher = rowSums(across(starts_with("Edu_"))[21:25], na.rm = TRUE) / 
                           rowSums(across(starts_with("Edu_")), na.rm = TRUE),

    # % below poverty
    Pct_Poverty = Below_Poverty / Poverty_Universe,

    # % employed
    Pct_Employed = Employed / Labor_Force,

    # Homeownership rate
    Homeownership_Rate = Owner_Occupied / (Owner_Occupied + Renter_Occupied),

    # Vacancy rate
    Vacancy_Rate = Vacant / Total_Units_Vacancy
  ) %>%
  select(
    ZIP, Median_Age, Total_Population, Pct_Foreign_Born, Mean_Commute_Time,
    Avg_Household_Size, Pre1980_Units, Median_Rent, Median_Home_Value,
    Pct_Moved, Pct_Bachelors_Higher, Pct_Poverty, Pct_Employed,
    Homeownership_Rate, Vacancy_Rate, Median_Income
  )