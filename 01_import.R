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

  data_list <- lapply(
  files,
  function(file) read_csv(file, show_col_types = FALSE)
)

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

# Read the 2024 LimeSurvey export.
# The file contains an extra pair of quotation marks around each complete row,
# so the quoting is corrected in memory before parsing.
limesurvey_2024_path <- file.path(
  raw_data_path,
  "results-limesurvey_Balance_VR.csv"
)

limesurvey_2024_lines <- readLines(
  limesurvey_2024_path,
  encoding = "UTF-8"
)

limesurvey_2024_lines <- sub('^"', '', limesurvey_2024_lines)
limesurvey_2024_lines <- sub('"$', '', limesurvey_2024_lines)
limesurvey_2024_lines <- gsub('""', '"', limesurvey_2024_lines, fixed = TRUE)

limesurvey_2024 <- read_csv(
  I(paste(limesurvey_2024_lines, collapse = "\n")),
  show_col_types = FALSE
)

# Check the ingested data
length(data_2024)
length(data_2026)
dim(balance_output_2024)
dim(balance_output_2026)
dim(limesurvey_2024)
