# Visual Analysis of Patient Data: Vancomycin Therapy and Mortality Factors

This project was conducted as part of the course **"Visualisierung komplexer Datenstrukturen"** during the Winter Semester 2024/2025 at **TU Dortmund**.  
It was a **group project (4 people)** focused on analyzing patient data using R, with an emphasis on exploratory data visualization and interpretation.

## Dataset

The dataset `vancomycin.RData` is a preprocessed and anonymized subset of a retrospective cohort study from the ICU of **Klinikum Köln-Merheim**, including patients who received **continuous Vancomycin infusion** between **May 1, 2010** and **August 5, 2022**.

- 922 observations (patients)
- 63 features (demographic, clinical, biochemical, therapy-related)

The data was provided as part of the course via Moodle and used solely for academic purposes.

## Project Goals

Each team member investigated specific aspects of the dataset.  
My part of the project focused on the question:

> **Which factors influence the mortality of patients treated with Vancomycin?**

More specifically:
- Demographic factors (e.g., **age**)
- Kidney function indicators (**SCr**, **eGFR**)
- Disease severity scores (**SAPS**, **SOFA**)
- Vancomycin-related treatment data (**MD24/48/72**, **C24/48/72**)

## Key Findings (from my part of the analysis)

- **Older patients** tended to have higher mortality.
- Patients with **higher SAPS and SOFA scores**, as well as **poorer kidney function** (elevated SCr, low eGFR), had a **significantly higher mortality rate**.
- **Kidney function was strongly associated** with both Vancomycin dosage and serum levels.
- Patients who died tended to have **worse kidney function and higher serum Vancomycin levels**.

## Tools & Methods

- Language: **R**
- File: `code_Predkova.R`
- Methods: Exploratory visualization with boxplots, line plots and scatterplot matrix
- Visualizations were prepared for a group presentation and further summarized in an individual written report (not included here).

## File Overview

- `code_Predkova.R`: My R script for visual analysis
- `vancomycin.RData`: Dataset used in the project
