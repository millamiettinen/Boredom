# Step 3: Analysis
# Research question:
# Does remnant power differ between high- and low-boredom conditions?

library(dplyr)
library(ggplot2)
library(tidyr)

# Select participant ID and RemnantPower variables needed for the analysis
remnant_2024 <- cleaned_balance_2024 %>%
  select(ID, starts_with("RemnantPower")) %>%
  mutate(year = 2024)

remnant_2026 <- cleaned_balance_2026 %>%
  select(ID, starts_with("RemnantPower")) %>%
  mutate(year = 2026)

# Combine the 2024 and 2026 datasets
remnant_data <- bind_rows(remnant_2024, remnant_2026)

# Calculate mean RemnantPower for each condition
# using the available non-missing trials
analysis_data <- remnant_data %>%
  mutate(
    HB_mean = rowMeans(
      select(., starts_with("RemnantPower HB")),
      na.rm = TRUE
    ),
    LB_mean = rowMeans(
      select(., starts_with("RemnantPower LB")),
      na.rm = TRUE
    ),
    HB_valid = rowSums(
      !is.na(select(., starts_with("RemnantPower HB")))
    ),
    LB_valid = rowSums(
      !is.na(select(., starts_with("RemnantPower LB")))
    )
  ) %>%
  # Exclude participants with no valid data in either condition
  filter(HB_valid > 0, LB_valid > 0)

# Check final analysis sample
dim(analysis_data)

# Identify excluded participants
excluded_participants <- remnant_data %>%
  mutate(
    HB_valid = rowSums(
      !is.na(select(., starts_with("RemnantPower HB")))
    ),
    LB_valid = rowSums(
      !is.na(select(., starts_with("RemnantPower LB")))
    )
  ) %>%
  filter(HB_valid == 0 | LB_valid == 0) %>%
  select(ID, year, HB_valid, LB_valid)

excluded_participants

# Calculate within-participant difference
analysis_data <- analysis_data %>%
  mutate(difference = HB_mean - LB_mean)

# Inspect the distribution of the paired differences
summary(analysis_data$difference)

hist(
  analysis_data$difference,
  main = "Distribution of HB - LB RemnantPower differences",
  xlab = "Difference in RemnantPower (HB - LB)"
)

qqnorm(analysis_data$difference)
qqline(analysis_data$difference)

# Descriptive statistics
analysis_data %>%
  summarise(
    HB_median = median(HB_mean),
    HB_IQR = IQR(HB_mean),
    LB_median = median(LB_mean),
    LB_IQR = IQR(LB_mean)
  )

# Paired Wilcoxon signed-rank test
wilcox_test <- wilcox.test(
  analysis_data$HB_mean,
  analysis_data$LB_mean,
  paired = TRUE,
  exact = FALSE
)

wilcox_test

# Save summary statistics and test result

results_summary <- data.frame(
  HB_median = median(analysis_data$HB_mean),
  HB_IQR = IQR(analysis_data$HB_mean),
  LB_median = median(analysis_data$LB_mean),
  LB_IQR = IQR(analysis_data$LB_mean),
  Wilcoxon_V = unname(wilcox_test$statistic),
  p_value = wilcox_test$p.value,
  n = nrow(analysis_data)
)

write.csv(
  results_summary,
  "analysis/remnant_power_results.csv",
  row.names = FALSE
)

# Prepare data for visualization
plot_data <- analysis_data %>%
  select(ID, HB_mean, LB_mean) %>%
  pivot_longer(
    cols = c(HB_mean, LB_mean),
    names_to = "condition",
    values_to = "RemnantPower"
  ) %>%
  mutate(
    condition = recode(
      condition,
      HB_mean = "High boredom",
      LB_mean = "Low boredom"
    )
  )

# Plot paired RemnantPower values
remnant_plot <- ggplot(
  plot_data,
  aes(
    x = condition,
    y = RemnantPower,
    group = ID
  )
) +
  geom_line(alpha = 0.4) +
  geom_point(size = 2) +
  labs(
    x = "Condition",
    y = "Mean Remnant Power",
    title = "Remnant Power in High- and Low-Boredom Conditions"
  ) +
  theme_minimal()

remnant_plot

# Save the figure
ggsave(
  filename = "analysis/remnant_power_conditions.png",
  plot = remnant_plot,
  width = 7,
  height = 5,
  dpi = 300
)