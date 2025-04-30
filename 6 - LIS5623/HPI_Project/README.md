# ZIP Code Housing Market Mispricing Analysis

This project investigates patterns of housing market mispricing across U.S. ZIP codes using a Price-to-Income (PTI) ratio as the key metric. We define overvalued and undervalued ZIP codes based on log-transformed PTI and develop classification models to understand the drivers of mispricing.

## Problem

Many housing markets in the U.S. appear misaligned with local income levels. This project aims to classify ZIP codes as:
- Overvalued
- Undervalued
- Fairly Valued

based on the Price-to-Income Ratio (PTI), using Zillow housing price data and demographic and economic features from the U.S. Census American Community Survey (ACS).

## Project Structure

Project/
├── 1 - Preprocessing_RawZillow.R
├── 2 - Preprocessing_ACS.R
├── 3 - Preprocessing_MergeZillowACS.R
├── 4 - Method_PTI.R
├── 5 - Model__1.R
├── ZILLOW_ZHVI.csv
├── ACSDT5Y2023.B[...]-Data.csv
├── LICENSE.txt
└── README.md

## Data Sources

Zillow Home Value Index (ZHVI)  
https://www.zillow.com/research/data/

U.S. Census Bureau – American Community Survey (ACS) 2023  
https://data.census.gov/

All data used is publicly available and has been cleaned and merged for reproducibility.

## How to Reproduce

1. Clone this repo.
2. Run the .R scripts in numerical order (1 through 5) to:
   - Preprocess data
   - Calculate PTI
   - Classify ZIP codes
   - Train and evaluate models

Make sure required R packages are installed:
dplyr, ggplot2, randomForest, xgboost, caret, pROC, e1071, ggpubr, readr, purrr

## Models Used

- Random Forest Classifier
- XGBoost Classifier

Both were trained to predict overvaluation (1 = overvalued, 0 = undervalued), using socioeconomic and housing-related features.

## Outputs

- Confusion matrices
- AUC scores
- Feature importance plots
- PTI distribution visualizations (raw and log-transformed)

## Author

Paul Jackson  
MIT License — see LICENSE.txt for usage terms.

## Attribution

If you use or build upon this project, please credit the author by linking back to the repository or citing the work.

This work was submitted as part of a Masters-level applied data analytics course capstone project at the University of Oklahoma.