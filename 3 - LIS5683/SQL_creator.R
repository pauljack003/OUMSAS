# Load the cleaned athletes.csv
athletes <- read.csv("data/athletes.csv", 
                     stringsAsFactors = FALSE)

# Function to escape single quotes and handle NA values in the INSERT statement
write_insert <- function(row) {
  name <- ifelse(is.na(row["Name"]), "NULL", sprintf("'%s'", gsub("'", "\\\\'", row["Name"])))
  location <- ifelse(is.na(row["Location"]), "NULL", sprintf("'%s'", gsub("'", "\\\\'", row["Location"])))
  country <- ifelse(is.na(row["Country"]), "NULL", sprintf("'%s'", gsub("'", "\\\\'", row["Country"])))
  
  sprintf(
    "INSERT INTO Athletes (Name, Location, Country) VALUES (%s, %s, %s);",
    name, location, country
  )
}

# Generate all INSERT statements
insert_statements <- apply(athletes, 1, write_insert)

# Write the SQL statements to a file
writeLines(insert_statements, 
           "data/insert_athletes.sql")

cat("Athletes SQL script generated successfully!")


# Load the cleaned events.csv
events <- read.csv("data/events.csv", 
                   stringsAsFactors = FALSE)

# Function to escape single quotes and handle NA values in the INSERT statement
write_insert_events <- function(row) {
  season <- ifelse(is.na(row["Season"]), "NULL", sprintf("'%s'", row["Season"]))
  distance <- ifelse(is.na(row["Distance"]), "NULL", sprintf("'%s'", row["Distance"]))
  gender <- ifelse(is.na(row["Gender"]), "NULL", sprintf("'%s'", row["Gender"]))
  
  sprintf(
    "INSERT INTO Events (Season, Distance, Gender) VALUES (%s, %s, %s);",
    season, distance, gender
  )
}

# Generate all INSERT statements for events
insert_statements_events <- apply(events, 1, write_insert_events)

# Write the SQL statements to a file
writeLines(insert_statements_events, 
           "data/insert_events.sql")

cat("Events SQL script for events generated successfully!")



# Load the cleaned clubs.csv
clubs <- read.csv("Data/clubs.csv", 
                  stringsAsFactors = FALSE)

# Function to escape single quotes and handle NA values in the INSERT statement
write_insert_clubs <- function(row) {
  club_name <- ifelse(is.na(row["Club"]), "NULL", sprintf("'%s'", gsub("'", "\\\\'", row["Club"])))
  
  sprintf(
    "INSERT INTO Clubs (ClubName) VALUES (%s);",
    club_name
  )
}

# Generate all INSERT statements for clubs
insert_statements_clubs <- apply(clubs, 1, write_insert_clubs)

# Write the SQL statements to a file
writeLines(insert_statements_clubs, 
           "Data/insert_clubs.sql")

cat("Clubs SQL script for clubs generated successfully!")



# Load the cleaned results.csv
results <- read.csv("Data/results.csv", stringsAsFactors = FALSE)

# Function to handle NULLs and generate INSERT statements for Results
write_insert_results <- function(row) {
  club_id <- ifelse(is.na(row["ClubID"]), "NULL", row["ClubID"])
  
  sprintf(
    "INSERT INTO Results (AthleteID, EventID, ClubID, TimeSeconds, Age) VALUES (%d, %d, %s, %.2f, %d);",
    row["AthleteID"],
    row["EventID"],
    club_id,
    row["TimeSeconds"],
    row["Age"]
  )
}

# Generate all INSERT statements for the Results table
insert_statements_results <- apply(results, 1, write_insert_results)

# Write the SQL statements to a file
writeLines(insert_statements_results, 
           "Data/insert_results.sql")

cat("Results SQL script for results generated successfully!")