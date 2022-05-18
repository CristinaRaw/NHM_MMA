rm(list=ls())

library(metagear)

# Steps:
#   1. Load data set of merged references downloaded from Scopus and WOS for cereals
#   2. First screen of references
#   3. Add exclusion reason column 
#   4. Create two data frames: one with first screen excluded studies and one with the studies that will go through
#      a second screen
#   5. Second screen of studies
#   6. Add the studies excluded in the second screen to the excluded data frame and create a data frame of included
#      studies

# 1. Load data set of merged references downloaded from Scopus and WOS for cereals

d <- read.csv2("Raw_Data/Legumes/Legumes_first_screen.csv", header = TRUE)


# 2. First screen of references

# Now  I have to screen the references to classify as relevant (YES), maybe relevant (maybe) or 
# not relevant (NO) to this meta-analysis.
# Initialize adds three columns: study_ID, reviewers (only me, Christina) and INCLUDE (yes, no, maybe).
# Saves automatically a copy, called "effort_Christina". 

d_initialized<-effort_distribute(d,                              #effort_Christina.csv.
                                 initialize = TRUE,              #I changed file location to: Escritorio/NHM/NHM R   
                                 reviewers = "Christina",        #/Output/Screening/Cereals   
                                 save_split = TRUE)

      # Load initialized data

screening<-read.csv("Outputs/Screening/Cereals/effort_Christina.csv")

      # Start screening the references with abstract_screener. References will be classified as yes, no, maybe             # according to the inclusion criteria 

abstract_screener(file="Outputs/Screening/Cereals/effort_Christina.csv",
                  aReviewer = "Christina",
                  abstractColumnName="Abstract",
                  titleColumnName="Title",
                  highlightKeywords = c("Wheat", "maize","rice","paddy","rice paddy","soybean", "soy", "soy bean", "barley", "sorghum", "millet", 
                                        "cereal", "grain", "meta-analysis", "meta analysis", "review", "biodiversity", "richness",
                                        "abundance", "diversity", "ecosystem", "compar", "contrast", "differenc",  "effect", "affect",
                                        "influ", "impact", "traditional", "manual", "mechan", "burn*", "vertical", "production system", "farming system",
                                        "crop", "farm", "production", "system", "conventional", "divers", "sustainable", "ecological", "organic",
                                        "intens", "extens", "abandon", "lough", "fallow", "biotic", "hedgerow", "polycultur", "strip", "mixed",
                                        "land", "tillage", "natural habitat", "set aside", "mosaic"))

      # Given the high volume of papers, first I am going to screen them by crop. If the paper does not have any of the crop terms, I 
      # will classify it as NO



abstract_screener(file= "Outputs/Screening/Cereals/effort_Christina.csv",
                  aReviewer = "Christina",
                  abstractColumnName="Abstract",
                  titleColumnName="Title",
                  highlightKeywords = c("Wheat", "maize","rice","paddy","rice paddy","soybean", "soy", "soy bean", "barley", "sorghum", "millet", 
                                        "cereal", "grain"))

        
      # I am going to create a two data frames. One with the discarded papers and one with the potentially
      # relevant papers to assess in a second screen.

d <- read.csv("Outputs/Screening/Cereals/effort_Christina.csv")
excluded <- subset(d, d$INCLUDE == "NO")

write.csv(excluded, "Processed_Data/Cereals/Cereal_excluded.csv")
write.csv(excluded, "Outputs/Screening/Cereals/Cereal_excluded.csv")

library(writexl)

write_xlsx(excluded, "Processed_Data/Cereals/Excel_cereal_excluded.xlsx",col_names=TRUE, format_headers = TRUE)
write_xlsx(excluded, "Outputs/Screening/Cereals/Excel_cereal_excluded.xlsx",col_names=TRUE, format_headers = TRUE)

unique(d$INCLUDE)

second_screen <- subset(d, d$INCLUDE == "YES" | d$INCLUDE == "maybe")

write.csv(second_screen, "Processed_Data/Cereals/Cereal_second_screen.csv")
write.csv(second_screen, "Outputs/Screening/Cereals/Cereal_second_screen.csv")


# 3. Second screen

rm(list=ls())

d <- read.csv("Outputs/Screening/Cereals/Cereal_second_screen.csv")
d <- d[,-c(1,2,3,4)]

d_initialized<-effort_distribute(d,                              #effort_Christina.csv.
                                 initialize = TRUE,              #I changed file location to: Escritorio/NHM/NHM R   
                                 reviewers = "Christina",        #/Output/Screening/Cereals/effort_Christina_2.csv   
                                 save_split = TRUE)



abstract_screener(file="Outputs/Screening/Cereals/effort_Christina_2.csv",
                  aReviewer = "Christina",
                  abstractColumnName="Abstract",
                  titleColumnName="Title",
                  highlightKeywords = c("wheat", "maize","rice","paddy","rice paddy","soybean", "soy", "soy bean", "barley", "sorghum", "millet", 
                                        "cereal", "grain", "meta-analysis", "meta analysis", "review", "biodiversity", "richness",
                                        "abundance", "diversity", "ecosystem", "compar", "contrast", "differenc",  "effect", "affect",
                                        "influ", "impact", "traditional", "manual", "mechan", "burn*", "vertical", "production system", "farming system",
                                        "crop", "farm", "production", "system", "conventional", "divers", "sustainable", "ecological", "organic",
                                        "intens", "extens", "abandon", "lough", "fallow", "biotic", "hedgerow", "polycultur", "strip", "mixed",
                                        "land", "tillage", "natural habitat", "set aside", "mosaic"))






