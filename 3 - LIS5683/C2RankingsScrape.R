# Load necessary libraries
library(httr)
library(rvest)
library(dplyr)
library(stringr)

# Authenticate into the database
login_url <- "https://log.concept2.com/login"
session <- httr::POST(login_url, body = list(username = "xxx", password = "xxx"))

# Define the base URLs for the events, seasons, and genders
base_urls <- list(
  "2025_5000m_M" = "https://log.concept2.com/rankings/2025/rower/5000?rower=rower&gender=M&status=verified",
  "2025_5000m_F" = "https://log.concept2.com/rankings/2025/rower/5000?rower=rower&gender=F&status=verified",
  "2025_2000m_M" = "https://log.concept2.com/rankings/2025/rower/2000?rower=rower&gender=M&status=verified",
  "2025_2000m_F" = "https://log.concept2.com/rankings/2025/rower/2000?rower=rower&gender=F&status=verified",
  "2024_5000m_M" = "https://log.concept2.com/rankings/2024/rower/5000?rower=rower&gender=M&status=verified",
  "2024_5000m_F" = "https://log.concept2.com/rankings/2024/rower/5000?rower=rower&gender=F&status=verified",
  "2024_2000m_M" = "https://log.concept2.com/rankings/2024/rower/2000?rower=rower&gender=M&status=verified",
  "2024_2000m_F" = "https://log.concept2.com/rankings/2024/rower/2000?rower=rower&gender=F&status=verified"
)

# Function to scrape data 
scrape_page <- function(url, season, distance, gender) {
  # Randomized delay between 2 and 5 seconds to be polite to the server
  pause_duration <- runif(1, min = 2, max = 5)
  Sys.sleep(pause_duration)
  
  # Fetch the page content and monitor HTTP status
  response <- httr::GET(url)
  status_code <- httr::status_code(response)
  
  if (status_code == 200) {
    page_content <- httr::content(response, as = "text")
    page_html <- read_html(page_content)
    
    # Extract only the rows that contain actual ranking data
    ranking_rows <- page_html %>% html_nodes("tbody tr") 
    
    # Extract data
    positions <- ranking_rows %>% html_nodes("td:nth-child(1)") %>% html_text(trim = TRUE)
    names <- ranking_rows %>% html_nodes("td:nth-child(2) a") %>% html_text(trim = TRUE)
    ages <- ranking_rows %>% html_nodes("td:nth-child(3)") %>% html_text(trim = TRUE)
    locations <- ranking_rows %>% html_nodes("td:nth-child(4)") %>% html_text(trim = TRUE)
    countries <- ranking_rows %>% html_nodes("td:nth-child(5)") %>% html_text(trim = TRUE)
    clubs <- ranking_rows %>% html_nodes("td:nth-child(6)") %>% html_text(trim = TRUE)
    times <- ranking_rows %>% html_nodes("td:nth-child(7)") %>% html_text(trim = TRUE)
    verified <- ranking_rows %>% html_nodes("td:nth-child(8)") %>% html_text(trim = TRUE)
    
    # Combine all extracted data into a data frame, adding season, distance, and gender
    data <- data.frame(
      Season = season,
      Distance = distance,
      Gender = gender,
      Position = positions,
      Name = names,
      Age = ages,
      Location = locations,
      Country = countries,
      Club = clubs,
      Time = times,
      Verified = verified,
      stringsAsFactors = FALSE
    )
    
    return(data)
  } else if (status_code == 429) {
    message("Received 429 Too Many Requests. Pausing scraping for 10 minutes.")
    Sys.sleep(600)  # Wait for 10 minutes
    return(NULL)  # Return NULL to indicate no data was fetched
  } else {
    message("Received HTTP status ", status_code, " for URL: ", url)
    return(NULL)
  }
}

# Initialize an empty list to hold each data frame from base URL list
data_frames <- list()

# Iterate over each base URL
for (name in names(base_urls)) {
  base_url <- base_urls[[name]]
  
  # Extract parameters from the name
  parts <- str_split(name, "_")[[1]]
  season <- as.integer(parts[1])
  distance <- as.integer(gsub("m", "", parts[2]))  # Remove 'm' from distance
  gender <- parts[3]
  
  # Initial request to determine the total number of pages
  initial_response <- httr::GET(base_url)
  status_code <- httr::status_code(initial_response)
  
  if (status_code == 200) {
    initial_content <- httr::content(initial_response, as = "text")
    initial_page <- read_html(initial_content)
    
    # Extract total pages from pagination 
    total_pages <- initial_page %>% 
      html_nodes(".pagination li a") %>%
      html_text() %>%
      as.numeric() %>%
      max(na.rm = TRUE)
    
    # Handle cases where there might be only one page or no pagination
    if (is.na(total_pages)) {
      total_pages <- 1
    }
    
    # Initialize an empty data frame for this dataset
    all_data <- data.frame()
    
    # Loop through each page and scrape the data
    for (page in 1:total_pages) {
      page_url <- paste0(base_url, "&page=", page)
      
      # Error handling
      page_data <- tryCatch({
        scrape_page(page_url, season, distance, gender)
      }, error = function(e) {
        message("Error on ", name, " page ", page, ": ", e$message)
        data.frame()  # Return empty data frame on error
      })
      
      # If page_data is NULL, skip to the next iteration
      if (is.null(page_data)) {
        next
      }
      
      # Append to the data frame for this dataset
      all_data <- bind_rows(all_data, page_data)
    }
    
    # Append the data frame to the list
    data_frames[[name]] <- all_data
    
    # Print progress
    message("Completed scraping: ", name)
  } else {
    message("Failed to retrieve initial page for ", name, ". HTTP status: ", status_code)
    next  # Skip to the next base URL
  }
}

# Combine all datasets into one data frame
all_data <- bind_rows(data_frames)

# Save the combined data to a CSV file
write.csv(all_data, "all_rankings_raw.csv", row.names = FALSE)