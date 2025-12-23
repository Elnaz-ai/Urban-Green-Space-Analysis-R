source("scripts/00_setup.R")

library(dplyr)
library(tidyr)

# Load private data locally
Questionnaire <- load_data()

# Basic cleanup: treat empty strings as NA
Questionnaire <- Questionnaire %>%
  mutate(across(everything(), ~ na_if(.x, "")))

# Convert mental/physical health questions to ordered factors (if they exist)
if (all(c("Q1", "Q2") %in% names(Questionnaire))) {
  health_levels <- c("Excellent", "Very good", "Good", "Fair", "Poor")

  Questionnaire <- Questionnaire %>%
    mutate(
      Q1 = factor(Q1, levels = health_levels, ordered = TRUE),
      Q2 = factor(Q2, levels = health_levels, ordered = TRUE)
    )
}

# Create a clean subset for Q26 barriers/enablers
if (all(paste0("Q26_", 1:32) %in% names(Questionnaire))) {
  Q26 <- Questionnaire %>% select(Q26_1:Q26_32)
  Q26 <- Q26 %>% mutate(across(everything(), ~ na_if(.x, "")))
} else {
  Q26 <- NULL
}

# Save cleaned objects as RDS locally (optional but useful)
saveRDS(Questionnaire, file = file.path(OUT_DIR, "questionnaire_clean.rds"))
if (!is.null(Q26)) saveRDS(Q26, file = file.path(OUT_DIR, "q26_clean.rds"))

cat("✅ Cleaning complete. Outputs saved to /outputs\n")
