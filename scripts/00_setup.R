# ------------------------------------------------------------
# Project: Urban Green Space & Well-Being Analysis (R)
# Author: Elnaz Fathi
# Purpose: Reproducible setup for survey-based analysis
# Note: Raw data is not included due to privacy restrictions.
# ------------------------------------------------------------

# 1) Libraries
library(dplyr)
library(ggplot2)

# 2) Paths
DATA_PATH <- "data/private_dataset.csv"     
FIG_DIR   <- "figures"
OUT_DIR   <- "outputs"

# 3) Create folders if missing (so code doesn't fail)
if (!dir.exists(FIG_DIR)) dir.create(FIG_DIR, recursive = TRUE)
if (!dir.exists(OUT_DIR)) dir.create(OUT_DIR, recursive = TRUE)

# 4) Safe data loader (will stop with a clear message if data is missing)
load_data <- function(path = DATA_PATH) {
  if (!file.exists(path)) {
    stop(
      paste0(
        "Data file not found: ", path, "\n\n",
        "Because the raw dataset is private, it is not included in this repo.\n",
        "To run the analysis locally:\n",
        "1) Place your dataset at: data/private_dataset.csv\n",
        "2) Re-run the scripts.\n"
      ),
      call. = FALSE
    )
  }
  read.csv(path, stringsAsFactors = FALSE)
}

