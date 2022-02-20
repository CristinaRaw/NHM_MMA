
#Oil crops: Include those in the top 15 and down to the top 50 until there are around 5 crops, 
#then see how many substantially different farming systems there are – there might be some crops grown in 
#basically the same way as each other. There are already 5 oil crops in the top 15 crops list: 
#seed cotton, rapeseed, ground nuts, oil palm and sunflower seed. Therefore, I am  going to proceed with 
#the screening methodology.

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

d <- read.csv2("Raw_Data/Oil/Raw_oil_first_screen.csv", header = TRUE)


# 2. First screen of references

# Now  I have to screen the references to classify as relevant (YES), maybe relevant (maybe) or 
# not relevant (NO) to this meta-analysis.
# Initialize adds three columns: study_ID, reviewers (only me, Christina) and INCLUDE (yes, no, maybe).
# Saves automatically a copy, called "effort_Christina". 

d_initialized<-effort_distribute(d,                              #effort_Christina.csv.
                                 initialize = TRUE,              #I changed file location to: Escritorio/NHM/NHM R   
                                 reviewers = "Christina",        #/Output/Screening/Oil   
                                 save_split = TRUE)

# Load initialized data

screening<-read.csv("Outputs/Screening/Oil/effort_Christina.csv")

# Start screening the references with abstract_screener. References will be classified as yes, no, maybe             # according to the inclusion criteria 

abstract_screener(file="Outputs/Screening/Oil/effort_Christina.csv",
                  aReviewer = "Christina",
                  abstractColumnName="Abstract",
                  titleColumnName="Title",
                  highlightKeywords = c("seed cotton", "cotton seed", "cotton", "cottonseed", "rapeseed", "rape seed",
                                        "groundnuts", "ground nuts", "oil palm", "palm oil", "oilpalm", "sunflower seed",
                                        "sunflowerseed", "Brassica napus var. oleifera", "Arachis hypogaea", "Elaeis guineensis",
                                        "Helianthus annuus", "meta-analysis", "meta analysis", "review", "biodiversity", "richness",
                                        "abundance", "diversity", "ecosystem", "compar", "contrast", "differenc",  "effect", "affect",
                                        "influ", "impact", "traditional", "manual", "mechan", "burn*", "vertical", "production system", "farming system",
                                        "crop", "farm", "production", "system", "conventional", "divers", "sustainable", "ecological", "organic",
                                        "intens", "extens", "abandon", "lough", "fallow", "biotic", "hedgerow", "polycultur", "strip", "mixed",
                                        "land", "tillage", "natural habitat", "set aside", "mosaic"))



# Given the high volume of papers, first I am going to screen them by crop. If the paper does not have any of the crop terms, I 
# will classify it as NO



abstract_screener(file= "Outputs/Screening/Oil/effort_Christina.csv",
                  aReviewer = "Christina",
                  abstractColumnName="Abstract",
                  titleColumnName="Title",
                  highlightKeywords = c("seed cotton", "cotton seed", "cotton", "cottonseed", "rapeseed", "rape seed",
                                        "groundnuts", "ground nuts", "oil palm", "palm oil", "oilpalm", "sunflower seed",
                                        "sunflowerseed", "Brassica napus var. oleifera", "Arachis hypogaea", "Elaeis guineensis",
                                        "Helianthus annuus", "meta-analysis"))



# 4. I am going to create a two data frames. One with the discarded papers and one with the potentially
#    relevant papers to assess in a second screen.

d <- read.csv("Outputs/Screening/Oil/effort_Christina.csv")
excluded <- subset(d, d$INCLUDE == "NO")

write.csv(excluded, "Processed_Data/Oil/Oil_excluded.csv")
write.csv(excluded, "Outputs/Screening/Oil/Oil_excluded.csv")

library(writexl)

write_xlsx(excluded, "Processed_Data/Oil/Excel_oil_excluded.xlsx",col_names=TRUE, format_headers = TRUE)
write_xlsx(excluded, "Outputs/Screening/Oil/Excel_oil_excluded.xlsx",col_names=TRUE, format_headers = TRUE)

unique(d$INCLUDE)

second_screen <- subset(d, d$INCLUDE == "maybe")

write.csv(second_screen, "Processed_Data/Oil/Oil_second_screen.csv")
write.csv(second_screen, "Outputs/Screening/Oil/Oil_second_screen.csv")


# 5. Second screen

rm(list=ls())

d <- read.csv("Outputs/Screening/Oil/Oil_second_screen.csv", row.names = 1)
d <- d[,-c(1,2,3)]

d_initialized<-effort_distribute(d,                              #effort_Christina.csv.
                                 initialize = TRUE,              #I changed file location to: Escritorio/NHM/NHM R   
                                 reviewers = "Christina",        #/Output/Screening/Oil/effort_Christina_2.csv   
                                 save_split = TRUE)



abstract_screener(file="Outputs/Screening/Oil/effort_Christina_2.csv",
                  aReviewer = "Christina",
                  abstractColumnName="Abstract",
                  titleColumnName="Title",
                  highlightKeywords = c("seed cotton", "cotton seed", "cotton", "cottonseed", "rapeseed", "rape seed",
                                        "groundnuts", "ground nuts", "oil palm", "palm oil", "oilpalm", "sunflower seed",
                                        "sunflowerseed", "sunflower", "Brassica napus var. oleifera", "Arachis hypogaea", "Elaeis guineensis",
                                        "Helianthus annuus", "meta-analysis", "meta analysis", "review", "biodiversity", "richness",
                                        "abundance", "diversity", "ecosystem", "compar", "contrast", "differenc",  "effect", "affect",
                                        "influ", "impact", "traditional", "manual", "mechan", "burn*", "vertical", "production system", "farming system",
                                        "crop", "farm", "production", "system", "conventional", "divers", "sustainable", "ecological", "organic",
                                        "intens", "extens", "abandon", "lough", "fallow", "biotic", "hedgerow", "polycultur", "strip", "mixed",
                                        "land", "tillage", "natural habitat", "set aside", "mosaic"))



# 6. Add the studies excluded in the second screen to the excluded data frame and add an exclusion reason.
#    Then, create a data frame of papers included in the second screen, to asess in a third screen at full text


d <- read.csv("Outputs/Screening/Oil/effort_Christina_2.csv")
excluded <- subset(d, d$INCLUDE == "NO")

first_screen_excluded <- read.csv("Processed_Data/Oil/Oil_excluded.csv", row.names = 1)

second_screen_excluded <- rbind(first_screen_excluded, excluded)

        # Add exclusion reason

exclusion_reason<-rep("Not_relevant", length(second_screen_excluded$STUDY_ID))
second_screen_excluded<-cbind(second_screen_excluded, exclusion_reason) 

write.csv(second_screen_excluded, "Processed_Data/Oil/Oil_excluded.csv")
write.csv(second_screen_excluded, "Outputs/Screening/Oil/Oil_excluded.csv")

library(writexl)

write_xlsx(second_screen_excluded, "Processed_Data/Oil/Excel_oil_excluded.xlsx",col_names=TRUE, format_headers = TRUE)
write_xlsx(second_screen_excluded, "Outputs/Screening/Oil/Excel_oil_excluded.xlsx",col_names=TRUE, format_headers = TRUE)

        # Create a data frame of papers included in the second screen, to asess in a third screen at full text

setwd("C:/Users/raw_c/OneDrive/Escritorio/NHM/NHM R Project")

unique(d$INCLUDE)

included <- subset(d, d$INCLUDE == "maybe")

write.csv(included, "Outputs/Screening/Oil/Oil_third_screen.csv")
write_xlsx(included, "Outputs/Screening/Oil/Excel_oil_third_screen.xlsx",col_names=TRUE, format_headers = TRUE)


# Add the papers excluded at full text to the excluded data frame and create a data frame of included 
# (a priori) papers

library(readxl)

third_screen <- read_excel("Outputs/Screening/Oil/Excel_oil_third_screen.xlsx")
excluded <- read.csv("Outputs/Screening/Oil/Oil_excluded.csv", row.names = 1)

    # Make column names of both dataframes match so I can merfe them using rbind

colnames(excluded)
colnames(third_screen)

excluded <- excluded[,-c(1,2)]
excluded <- excluded[,-13]

third_screen <- third_screen[,-3]

colnames(third_screen)[1] <- "INCLUDE"

library(dplyr)

excluded <- relocate(excluded, exclusion_reason, .after = INCLUDE)
colnames(excluded)[2] <- "Exlusion_reason"

    # Add the full text excluded papers to the excluded data frame

unique(third_screen$INCLUDE)
full_excluded <- subset(third_screen, third_screen$INCLUDE == "No")

oil_excluded <- rbind(excluded, full_excluded)

write.csv(oil_excluded, "Outputs/Screening/Oil/Oil_excluded.csv")

    # Create a data frame of included (a priori) papers

full_included <- subset(third_screen, third_screen$INCLUDE == "Yes" | third_screen$INCLUDE == "Maybe")

library(writexl)

write.csv(full_included, "Outputs/Screening/Oil/Oil_included.csv")
write_xlsx(full_included, "Outputs/Screening/Oil/Excel_oil_included.xlsx",col_names=TRUE, format_headers = TRUE)


