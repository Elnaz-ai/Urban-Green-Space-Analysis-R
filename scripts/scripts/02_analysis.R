source("scripts/00_setup.R")

library(dplyr)

# Load cleaned data (created by 01_clean.R)
Questionnaire <- readRDS(file.path(OUT_DIR, "questionnaire_clean.rds"))

# 1) Contingency table: Mental health (Q1) vs Physical health (Q2)
# This shows how many people fall into each combination of categories.
contingency_q1_q2 <- table(Questionnaire$Q1, Questionnaire$Q2)
print(contingency_q1_q2)

write.csv(contingency_q1_q2, file = file.path(OUT_DIR, "contingency_q1_q2.csv"), row.names = TRUE)

# Optional: chi-square test 
chisq_q1_q2 <- chisq.test(contingency_q1_q2)
print(chisq_q1_q2)

# Save test output to a text file
capture.output(chisq_q1_q2, file = file.path(OUT_DIR, "chisq_q1_q2.txt"))


# 2) Contingency table: Mental health (Q1) vs Gender (Q33)  (only if you want it)
# NOTE: If this relationship is not part of your story, delete this block.
if ("Q33" %in% names(Questionnaire)) {
  contingency_q1_q33 <- table(Questionnaire$Q1, Questionnaire$Q33)
  print(contingency_q1_q33)
  write.csv(contingency_q1_q33, file = file.path(OUT_DIR, "contingency_q1_q33.csv"), row.names = TRUE)
}


# 3) Chi-square tests: each Q26 barrier vs Gender (Q33)
# This checks whether responses to each barrier item differ by gender.
if (all(c("Q33", paste0("Q26_", 1:32)) %in% names(Questionnaire))) {

  # Keep only needed columns and remove rows with missing values
  df <- Questionnaire %>%
    select(Q33, Q26_1:Q26_32) %>%
    na.omit()

  results <- data.frame(
    Item = character(),
    P_value = numeric(),
    Significant_0_05 = character(),
    stringsAsFactors = FALSE
  )

  for (i in 1:32) {
    col_name <- paste0("Q26_", i)
    tab <- table(df$Q33, df[[col_name]])

    test <- suppressWarnings(chisq.test(tab))
    p <- test$p.value

    results <- rbind(results, data.frame(
      Item = col_name,
      P_value = p,
      Significant_0_05 = ifelse(p < 0.05, "Yes", "No")
    ))
  }

  print(results)

  # Save results (simple)
  write.csv(results, file = file.path(OUT_DIR, "chisq_q26_by_gender.csv"), row.names = FALSE)
}

cat("✅ Done. Check the /outputs folder.\n")
