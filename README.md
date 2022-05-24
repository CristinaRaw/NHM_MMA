# Meta-meta-analysis of the impact of agricultural systems on biodiversity
Perforemed by Cristina Raw for PurvisLab

This repositoery contains all the code used to perform the meta-meta-analaysis.

## 1. Project description:

The goal of the meta-meta-analysis is to find out how the agricultural systems used to produce the world's top 15 crops impact biodiversity. 
This information will be available to advise business on how to become more biodiversity friendly.

Another goal of the project is to build a framework that can be used by other researches and built on, to robustly answer the question or similar questions. 

## 2. Data

The data coomes from meta-analyses and reviews that research the impact of agricultural systems on biodiversity. The data sets are stored in the `Git_Datasets` folder., where you can find three files:

  - `v3_LONG_Data_extraction_spreadsheet.xlsx`: Raw data extraction spreadsheet before dropping empty columns
  - `05.Excel_Dataset_to_model_Percentage.xlsx`: curated data extraction spreadsheet used in the percentage change analysis 
  - `v3_LONG_Data_extraction_spreadsheet.xlsx`: curated data extraction spreadsheet used in the Log Response Ratio analysis 

## 3. Scripts, what do they each do?

`/00.Scope`

- **00.Crops and livestock broad scoping phase.Rmd**: find out which are the top 15 crops and top 4 livestock species by area and value
- **01.Sugar_pilot_phase_and_systematic_search.Rmd**: small pilot phase to decide  whether it is best to go crop by crop or to do the crops within a broader commodity 
type
- **02.Find top 5 legumes.Rmd**: find out which are the first 5 legume crops in the top 50 crops by area harvested

`/02.Screening`

- **00.Cerals_screen.R**: screen cereal crops studies
- **01.Legumes_screen.R**: screen legume crops studies
- **02.Oil_screen.R**: screen oil crops studies
- **03.Sugar_creen.R**: screen sugar crop studies 

`/03.Data_extraction`

- **03.Prepare_data_for_extraction.R**: in the screening phase I screened studies for relevance, classifying them as "yes" (= Include), "maybe" (= maybe include)
and "no" (= exclude). In this script I create a data frame with all the papers classified as "YES" or "Maybe" in the screening phase, then I clean it and finally I
randomise it
- **04.MetaDigitise.R**: use metaDigitise package to extract data from figures and plots
- **05.Spreadsheet_piloting.R**: pilot the data extraction spreadsheet with a random sample of 10 studies of the pool of studies classified as "yes" or "maybe"
in the screening phase

`/04.Data curation`

- **06.Spreadsheet_curation.R**:  clean the data set: drop unnecesary columns, corece columns into right format, fix typos, etc.
- **07.Functional_groups.R**: input funcional gorup information
- **12.Inputing_magpie_classes.R**: the magpie classes are a commodity classification for crops made by the business VividEconomics, which  is slightly
different from the commodity classification made by FAO. In this script I input a column with the magpie categories. I also corrected a typo 
- **20.PreparingDatasetForModelling_Percentage.R**: transform Log Response Ratio (LRR) into percentage to model percentage change data
- **22.PreparingDatasetForModelling_LRR.R**: prepare the data set for the new modelling approach. Instead of using the data in percentage change format, I use it in LRR. Therefore, this scripts transforms percentage change data into LRR format. There is also some data set cleaning.

`/05.Analysis`

- **21.Percentage_change_analysis.Rmd**: analyse percentage change data
- **23.Approaches_to_LRR_Analysis.Rmd**: more of a EDA script, to see how to approach the LRR analysis
- **26.Analysis_LRR.Rmd**:  Bayesian analysis of the LRR data to see how different agricultural systems impact biodiversity. Also some data set cleaning
- **28. Model_diagnostic_with_influence.ME_and_Robust_analysis.Rmd**: there were influential observations in the model (script 26). This script I assess the presence of influential observations using the package influence.ME. The second part performs a robust analysis that accouts for the influential data using the package robustlmm.

`/06.Wrting`

- **01. Data proportions and annexes.R**: get data proportions by different goups (e.g., taxa, crops...)
- **29.Making_summary_tables.R**: make analysis summary tables

`07.Other/Data digest`

- **08.Data digest.Rmd**: digest the crop data I have extracted from syntheses on agricultural production systems on biodiversity. The aim is to provide an easy overview of the data set.
- **13.Crops_quantitative_data_digest.Rmd**: show number of observations per crop and, within class, number of observations per production system 
- **14.VividEconomics_data_digest.Rmd**: after having inputed the magpie classes, show number of observations per magpie class and, within class, number of 
observations per production system 
- **19.WeightedMeansDigest.Rmd**: simmarise biodiversity weighted means under different crops and agricultural systems

`/07.Other/Cotton`

The aim of these scripts was to provide a time estimate of how long each step of the meta-analysis takes. To do so, I focused on one single crop, sugar, and 
recorded how long the scope, screen, and data extraction phases take

- **09. Making_cotton_dataset.R**: extract all the cotton quantitative and qualitative data from the curated data set and save as excel to have a cotton data set to work on and input more data from the cotton papers.
- **10.MetaDigitise_cotton.R**: use metaDigitise package to extract data from figures and plots from cotton studies
- **11.Cotton_spreadsheet_curation.R**: clean the top cotton quantitative data extraction spreadsheet

