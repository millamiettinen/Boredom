# Step 1: Data ingestion
# Import the raw data without modifying the original files

# Load necessary libraries
library(dplyr)
library(readr)
library(readxl)

# Define the path to the raw data directory
raw_data_path <- "raw data"

# Function to read all CSV files from a directory and its subfolders
read_raw_csv_data <- function(directory) {
  files <- list.files(
    directory,
    pattern = "\\.csv$",
    full.names = TRUE,
    recursive = TRUE
  )

  data_list <- lapply(files, read_csv)

  return(data_list)
}

# Read CSV data from 2024 and 2026 directories
data_2024 <- read_raw_csv_data(file.path(raw_data_path, "2024"))
data_2026 <- read_raw_csv_data(file.path(raw_data_path, "2026"))

# Read balance output Excel files
balance_output_2024 <- read_excel(
  file.path(raw_data_path, "2024", "balance_output_2024.xlsx")
)

balance_output_2026 <- read_excel(
  file.path(raw_data_path, "2026", "balance_output_2026.xlsx")
)

# Check the structure of the ingested data
str(data_2024)
str(data_2026)
str(balance_output_2024)
str(balance_output_2026)

