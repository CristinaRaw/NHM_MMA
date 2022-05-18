# Meta-meta-analysis of the impact of agricultural systems on biodiversity
Perforemed by Cristina Raw for PurvisLab

This repositoery contains all the code used to perform the meta-meta-analaysis.

## 1. Project description:

The goal of the meta-meta-analysis is to find out how the agricultural systems used to produce the world's top 15 crops impact biodiversity. 
This information will be available to advise business on how to become more biodiversity friendly.

Another goal of the project is to build a framework that can be used by other researches and built on, to robustly answer the question or similar questions. 

## 2. Data

The data coomes from meta-analyses and reviews that research the impact of agricultural systems on biodiversity. The `dataset`file contains two files:

  - `name`: original curated data extraction spreadsheet before dropping empty columns
  - `name`: curated data extraction spreadsheet used in the analysis
  - `other_data`: contains other data sets used in the project but not in the analysis, such as FAOSTAT data sets used to find ouot which are the top crops
 by value or area harvested

## 3. Scripts, what do they do?

- **00.Crops and livestock broad scoping phase.Rmd**: find out which are the top 15 crops and top 4 livestock species by area and value
- **01.Sugar_pilot_phase_and_systematic_search.Rmd**: small pilot phase to decide  whether it is best to go crop by crop or to do the crops within a broader commodity 
type
- **02.Find top 5 legumes.Rmd**: find out which are the first 5 legume crops in the top 50 crops by area harvested
- **03.Prepare_data_for_extraction.R**: in the screening phase I screened studies for relevance, classifying them as "yes" (= Include), "maybe" (= maybe include)
and "no" (= exclude). In this script I create a data frame with all the papers classified as "YES" or "Maybe" in the screening phase, then I clean it and finally I
randomise it
- **04.MetaDigitise.R**: use metaDigitise package to extract data from figures and plots
- **05.Spreadsheet_piloting.R**: pilot the data extraction spreadsheet with a random sample of 20 studies of the pool of studies classified as "yes" or "maybe"
in the screening phase
- 
