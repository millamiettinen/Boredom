# Step 2: Data preprocessing
# Preprocess the imported data without modifying the raw files.
#
# The dataset contains different types of files from PsychoPy and VR/eye-tracking,
# as well as derived balance-output data.
# Missing values are retained because some are intentional parts of the data structure.
# No imputation, outlier removal, or row deletion is performed at this stage.

# Define the preprocessing function
preprocess_data <- function(data) {
  
  # Check that the input is a data frame
  stopifnot(is.data.frame(data))
  
  # Keep all rows and columns.
  # Missing values are retained because they can be intentional in the data.
  data_cleaned <- data
  
  return(data_cleaned)
}

# Apply preprocessing to the complete imported CSV datasets
cleaned_data_2024 <- lapply(data_2024, preprocess_data)
cleaned_data_2026 <- lapply(data_2026, preprocess_data)

# Apply preprocessing to the balance-output datasets
cleaned_balance_2024 <- preprocess_data(balance_output_2024)
cleaned_balance_2026 <- preprocess_data(balance_output_2026)

# Apply preprocessing to the 2024 LimeSurvey dataset
cleaned_limesurvey_2024 <- preprocess_data(limesurvey_2024)

# RemnantPower variables are converted to numeric because the 2024 Excel file
# imports these values as character, whereas the 2026 file imports them as numeric.
cleaned_balance_2024 <- cleaned_balance_2024 %>%
  mutate(across(starts_with("RemnantPower"), as.numeric))

cleaned_balance_2026 <- cleaned_balance_2026 %>%
  mutate(across(starts_with("RemnantPower"), as.numeric))

# Check that the number of imported CSV files is unchanged
stopifnot(length(cleaned_data_2024) == length(data_2024))
stopifnot(length(cleaned_data_2026) == length(data_2026))

# Check that the number of rows in the CSV files is unchanged
stopifnot(
  all(sapply(cleaned_data_2024, nrow) == sapply(data_2024, nrow))
)

stopifnot(
  all(sapply(cleaned_data_2026, nrow) == sapply(data_2026, nrow))
)

# Check that the balance-output dimensions are unchanged
stopifnot(
  identical(dim(cleaned_balance_2024), dim(balance_output_2024))
)

stopifnot(
  identical(dim(cleaned_balance_2026), dim(balance_output_2026))
)
# Check that the 2024 LimeSurvey dimensions are unchanged
stopifnot(
  identical(dim(cleaned_limesurvey_2024), dim(limesurvey_2024))
)

# Check that the cleaned datasets contain the expected number of CSV files
stopifnot(length(cleaned_data_2024) == 282)
stopifnot(length(cleaned_data_2026) == 199)

# Check the expected dimensions of the balance-output datasets
stopifnot(all(dim(cleaned_balance_2024) == c(27, 51)))
stopifnot(all(dim(cleaned_balance_2026) == c(14, 51)))
stopifnot(all(dim(cleaned_limesurvey_2024) == c(32, 100)))