# Step 1: Data ingestion
#Import the raw data without modifying the original files

# Load necessary libraries
library(dplyr)
library(readr)

# Define the path to the raw data directory
raw_data_path <- "C:/Users/milla/OneDrive/Desktop/Universität Konstanz/Project seminar S2/Boredom/raw data/"


# Function to read all CSV files from a directory and its subfolders
read_raw_data <- function(directory) {
  files <- list.files(
    directory,
    pattern = "\\.csv$",
    full.names = TRUE,
    recursive = TRUE
  )

  data_list <- lapply(files, read_csv)

  return(data_list)
}

# Read data from 2024 and 2026 directories
data_2024 <- read_raw_data(file.path(raw_data_path, "2024"))
data_2026 <- read_raw_data(file.path(raw_data_path, "2026"))

# Check the structure of the ingested data
str(data_2024)
str(data_2026)

