# Boredom and Body Sway Study

This repository contains the reproducible data-processing and analysis pipeline for the boredom study.

## Research Question

Does remnant power differ between high- and low-boredom conditions?

## Repository Structure

- `01_import.R` – imports the raw 2024 and 2026 datasets, the balance-output Excel files, and the 2024 LimeSurvey export.
- `02-preprocess.R` – preprocesses the imported datasets and performs consistency checks without modifying the original raw files.
- `03-analysis.R` – performs the Remnant Power analysis and generates the final outputs.
- `analysis/` – contains the generated figure and numerical results.
- `renv.lock` – records the R package environment required to reproduce the analysis.
- `README.md` – provides instructions for reproducing the pipeline.

## Raw Data

The raw data are not stored in this GitHub repository.

To run the pipeline, the raw data must be placed in a folder called:

`raw data/`

The data are organized into separate subfolders for the 2024 and 2026 datasets:

- `raw data/2024/`
- `raw data/2026/`

The balance-output files used in the analysis should be located at:

- `raw data/2024/balance_output_2024.xlsx`
- `raw data/2026/balance_output_2026.xlsx`

The 2024 LimeSurvey export should be located at:

- `raw data/results-limesurvey_Balance_VR.csv`

The scripts use relative paths, so no user-specific file paths need to be changed.

## Reproducing the Analysis

### 1. Clone the repository

Clone the GitHub repository and open the project in R or Positron.

### 2. Restore the R environment

The project uses `renv` to record the required R packages and their versions.

Run:

```r
renv::restore()
```

### 3. Add the raw data

Place the raw data in the `raw data/` directory using the folder structure described above.

Raw data should not be manually edited.

### 4. Run the pipeline

Run the scripts in the following order:

```r
source("01_import.R")
source("02-preprocess.R")
source("03-analysis.R")
```

The scripts must be run in this order because each step uses objects created by the previous step.

## Step 1: Data Ingestion

`01_import.R` imports the raw datasets without modifying the source files.

CSV files from the 2024 and 2026 directories and their subdirectories are imported recursively.

The balance-output Excel files for 2024 and 2026 are also imported separately.

The 2024 LimeSurvey export is also imported separately. Because this source file contains an extra pair of quotation marks around each complete row, the quoting is corrected in memory during import before the data are parsed. The original raw file is not modified.

The expected imported CSV file counts are:

- 2024: 282 CSV files
- 2026: 199 CSV files

The balance-output datasets contain:

- 2024: 27 rows × 51 columns
- 2026: 14 rows × 51 columns

The imported 2024 LimeSurvey dataset contains 32 rows × 100 columns.

## Step 2: Data Preprocessing

`02-preprocess.R` preprocesses the imported datasets and performs consistency checks without modifying the raw files.

All rows and columns are retained. Missing values are preserved because some missing values are intentional parts of the data structure. No imputation, outlier removal, or row deletion is performed during preprocessing.

The script includes checks to ensure that the number of imported files and rows remains unchanged.

The RemnantPower variables in the balance-output datasets are converted to numeric. This is necessary because the 2024 Excel file imports these variables as character values, whereas the 2026 file imports them as numeric values. Converting them to a consistent type allows the datasets to be combined for analysis.

The original raw files remain unchanged.

## Step 3: Data Analysis

`03-analysis.R` addresses the research question:

**Does remnant power differ between high- and low-boredom conditions?**

The 2024 and 2026 balance-output datasets are combined for the analysis.

For each participant, mean Remnant Power is calculated separately for:

- High-boredom (HB) condition
- Low-boredom (LB) condition

The means are calculated using the available non-missing trials.

Participants with no valid Remnant Power data in one of the two conditions cannot contribute to the paired comparison and are excluded from the analysis.

The combined dataset contains 41 participants. Three participants have no valid Remnant Power data for one of the two conditions, leaving 38 participants in the paired analysis.

The distribution of the within-participant differences is inspected using summary statistics, a histogram, and a Q-Q plot. Because the differences show a clear deviation from normality, a paired Wilcoxon signed-rank test is used to compare the high- and low-boredom conditions.

## Results

For the 38 participants included in the paired analysis:

- High boredom: median Remnant Power = 0.0942, IQR = 0.120
- Low boredom: median Remnant Power = 0.0841, IQR = 0.0825

The paired Wilcoxon signed-rank test produced:

- V = 462
- p = 0.1869

The analysis therefore did not find a statistically significant difference in Remnant Power between the high- and low-boredom conditions.

## Generated Outputs

Running `03-analysis.R` generates the following files:

- `analysis/remnant_power_conditions.png` – paired visualization of mean Remnant Power in the high- and low-boredom conditions.
- `analysis/remnant_power_results.csv` – summary statistics and the Wilcoxon test result.

The `analysis/` directory is created automatically by the analysis script if it does not already exist.

These outputs are generated by the analysis script and can therefore be reproduced from the raw data by running the pipeline.