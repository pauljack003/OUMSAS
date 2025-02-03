# Load necessary libraries
library(dplyr)
library(stringr)

## Load data/all_rankings_raw.csv as all_data
all_data <- read.csv("data/all_rankings_raw.csv", stringsAsFactors = FALSE)

# Data Cleaning and Transformation

# Convert Age to integer
all_data$Age <- as.integer(all_data$Age)

# Function to convert time in mm:ss.xx to total seconds
convert_time_to_seconds <- function(time_str) {
  time_parts <- unlist(strsplit(time_str, "[:.]"))
  minutes <- as.numeric(time_parts[1])
  seconds <- as.numeric(time_parts[2])
  tenths <- ifelse(length(time_parts) == 3, as.numeric(time_parts[3]) / 10, 0)
  
  total_seconds <- (minutes * 60) + seconds + tenths
  return(total_seconds)
}

# Apply the function to convert all time values in the dataset
all_data$TimeSeconds <- sapply(all_data$Time, convert_time_to_seconds)

# Standardize text fields and trim whitespace
all_data <- all_data %>%
  mutate(
    Name = str_to_lower(str_trim(Name)),
    Location = str_to_lower(str_trim(Location)),
    Country = str_to_lower(str_trim(Country)),
    Club = str_to_lower(str_trim(Club))  # Standardize Club names to lowercase
  )

# Replace empty strings with NA to prevent NULL
all_data[all_data == ""] <- NA

# Save the cleaned data (optional)
write.csv(all_data, "data/all_rankings_cleaned.csv", row.names = FALSE)

# Data Normalization

# Create Athletes table (remove Age from here)
athletes <- all_data %>%
  select(Name, Location, Country) %>%
  distinct() %>%
  arrange(Name, Location, Country) %>%
  mutate(AthleteID = row_number())

# Create Events table
events <- all_data %>%
  select(Season, Distance, Gender) %>%
  distinct() %>%
  arrange(Season, Distance, Gender) %>%
  mutate(EventID = row_number())

# Create Clubs table (handle duplicates)
clubs <- all_data %>%
  select(Club) %>%
  distinct() %>%
  arrange(Club) %>%
  mutate(ClubID = row_number())

# Map AthleteID, EventID, and ClubID back to all_data
all_data <- all_data %>%
  left_join(athletes, by = c("Name", "Location", "Country")) %>%
  left_join(events, by = c("Season", "Distance", "Gender")) %>%
  left_join(clubs, by = "Club")

# Create Results table (removing Position and Verified)
results <- all_data %>%
  select(AthleteID, EventID, ClubID, TimeSeconds, Age) %>%
  mutate(ResultID = row_number())

# Export tables to CSV files
write.csv(athletes, "data/athletes.csv", row.names = FALSE)
write.csv(events, "data/events.csv", row.names = FALSE)
write.csv(clubs, "data/clubs.csv", row.names = FALSE)
write.csv(results, "data/results.csv", row.names = FALSE)

# Print sample data to verify
print("Sample Athletes Data:")
print(head(athletes))

print("Sample Events Data:")
print(head(events))

print("Sample Clubs Data:")
print(head(clubs))

print("Sample Results Data:")
print(head(results))
