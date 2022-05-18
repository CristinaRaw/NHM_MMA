rm(list=ls())
setwd("C:/Users/raw_c/OneDrive/Escritorio/NHM/NHM R Project")
library(metagear)

# Steps:
#   1. Load data set of merged references downloaded from Scopus and WOS for cereals
#   2. First screen of references
#   3. Add exclusion reason column 
#   4. Create two data frames: one with first screen excluded studies and one with the studies that will go through
#      a second screen
#   5. Second screen of studies
#   6. Create two data frames: one with first screen excluded studies and one with the studies that will go through
#      a third screen
#   7. Third screen
#   8. Add the studies excluded in the third screen to the excluded data frame and create a data frame of included
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
                                 reviewers = "Christina",        #/Output/Screening/Legumes   
                                 save_split = TRUE)

# Load initialized data

screening<-read.csv("Outputs/Screening/Legumes/effort_Christina.csv")

# 3. Start screening the references with abstract_screener. References will be classified as yes, no, maybe             
# according to the inclusion criteria. Given the high volume of papers, first I am going to screen them by crop. 
# If the paper does not have any of the crop terms, I will classify it as NO

abstract_screener(file= "Outputs/Screening/Legumes/effort_Christina.csv",
                  aReviewer = "Christina",
                  abstractColumnName="Abstract",
                  titleColumnName="Title",
                  highlightKeywords = c("legume", "bean"  ,  "cow pea"  ,  "chick pea"  ,  " pea "  ,  " pulse"  ,  "Phaseolus spp"  ,  " haricot bean "  ,  "kidney", 
                                        "Phaseolus vulgaris "  ,  " lima bean "  ,  " butter bean "  ,  " adzuki bean "  ,  " Phaseolus lunatus ",  
                                        " mungo bean "  ,  " golden bean "  ,  " Phaseolus angularis "  ,  "green gram "  ,  " black gram ",  
                                        " urd bean "  ,  " Phaseolus aureus "  ,  " Phaseolus mungo "  ,  " scarlet runner bean "  ,  
                                        " Phaseolus coccineus "  ,  " rice bean "  ,  " Phaseolus calcaratus "  ,  " Phaseolus aconitifolius " ,  
                                        " moth beabean "  ,  " tepary bean "  ,  " Phaseolus acutifolius "  ,  "cowpea"  ,  " Vigna sinensis " ,
                                        "Dolichos sinensis "  ,  " blackeye pea "  ,  " blackeye bean"  ,  " Bengal gram "  ,  " Cicer arietinum ",
                                        " garden pea "  ,  " Pisum sativum "  ,  " field pea "  ,  " Pisum arvense "  ,  " hyacinth bean ",  
                                        " Dolichos spp."  ,  " sw,d bean "  ,  "chickpea"  ,  "garbanzos"  ,  " winged bean ",  
                                        " Psophocarpus tetragonolobus "  ,  " Canavalia spp."  ,  " guar bean "  ,  " Cyamopsis tetragonoloba ",
                                        " velvet bean "  ,  " Stizolobiumspp."  ,  " yam bean "  ,  " Pachyrrhizus erosus "  ,  "lablab"  ,  "jack"))


# 4. I am going to create a two data frames. One with the discarded papers and one with the potentially
# relevant papers to assess in a second screen.

d <- read.csv("Outputs/Screening/Legumes/effort_Christina.csv")
excluded <- subset(d, d$INCLUDE == "NO")

write.csv(excluded, "Processed_Data/Legumes/Legumes_excluded.csv")
write.csv(excluded, "Outputs/Screening/Legumes/Legumes_excluded.csv")

library(writexl)

write_xlsx(excluded, "Processed_Data/Legumes/Excel_legumes_excluded.xlsx",col_names=TRUE, format_headers = TRUE)
write_xlsx(excluded, "Outputs/Screening/Legumes/Excel_legumes_excluded.xlsx",col_names=TRUE, format_headers = TRUE)

unique(d$INCLUDE)

second_screen <- subset(d, d$INCLUDE == "maybe")

write.csv(second_screen, "Processed_Data/Legumes/Legumes_second_screen.csv")
write.csv(second_screen, "Outputs/Screening/Legumes/Legumes_second_screen.csv")


# 5. Second screen

rm(list=ls())

d <- read.csv("Outputs/Screening/Legumes/Legumes_second_screen.csv")
d <- d[,-c(1,2,3,4)]

d_initialized<-effort_distribute(d,                              #effort_Christina.csv.
                                 initialize = TRUE,              #I changed file location to: Escritorio/NHM/NHM R   
                                 reviewers = "Christina",        #/Output/Screening/Legumes/effort_Christina_2.csv   
                                 save_split = TRUE)



abstract_screener(file="Outputs/Screening/Legumes/effort_Christina_2.csv",
                  aReviewer = "Christina",
                  abstractColumnName="Abstract",
                  titleColumnName="Title",
                  highlightKeywords = c("legume", "bean"  ,  "cow pea"  ,  "chick pea"  ,  " pea "  ,  " pulse"  ,  "Phaseolus spp"  ,  " haricot bean "  ,  "kidney", 
                                        "Phaseolus vulgaris "  ,  " lima bean "  ,  " butter bean "  ,  " adzuki bean "  ,  " Phaseolus lunatus ",  
                                        " mungo bean "  ,  " golden bean "  ,  " Phaseolus angularis "  ,  "green gram "  ,  " black gram ",  
                                        " urd bean "  ,  " Phaseolus aureus "  ,  " Phaseolus mungo "  ,  " scarlet runner bean "  ,  
                                        " Phaseolus coccineus "  ,  " rice bean "  ,  " Phaseolus calcaratus "  ,  " Phaseolus aconitifolius " ,  
                                        " moth beabean "  ,  " tepary bean "  ,  " Phaseolus acutifolius "  ,  "cowpea"  ,  " Vigna sinensis " ,
                                        "Dolichos sinensis "  ,  " blackeye pea "  ,  " blackeye bean"  ,  " Bengal gram "  ,  " Cicer arietinum ",
                                        " garden pea "  ,  " Pisum sativum "  ,  " field pea "  ,  " Pisum arvense "  ,  " hyacinth bean ",  
                                        " Dolichos spp."  ,  " sw,d bean "  ,  "chickpea"  ,  "garbanzos"  ,  " winged bean ",  
                                        " Psophocarpus tetragonolobus "  ,  " Canavalia spp."  ,  " guar bean "  ,  " Cyamopsis tetragonoloba ",
                                        " velvet bean "  ,  " Stizolobiumspp."  ,  " yam bean "  ,  " Pachyrrhizus erosus "  ,  "lablab"  ,  "jack", "meta-analysis", "meta analysis", "review", "biodiversity", "richness",
                                        "abundance", "diversity", "ecosystem", "compar", "contrast", "differenc",  "effect", "affect",
                                        "influ", "impact", "traditional", "manual", "mechan", "burn*", "vertical", "production system", "farming system",
                                        "crop", "farm", "production", "system", "conventional", "divers", "sustainable", "ecological", "organic",
                                        "intens", "extens", "abandon", "lough", "fallow", "biotic", "hedgerow", "polycultur", "strip", "mixed",
                                        "land", "tillage", "natural habitat", "set aside", "mosaic"))


# 6. Add the studies excluded in the second screen to the excluded data frame and add an exclusion reason.

d <- read.csv("Outputs/Screening/Legumes/effort_Christina_2.csv")
excluded <- subset(d, d$INCLUDE == "NO")

first_screen_excluded <- read.csv("Processed_Data/Legumes/Legumes_excluded.csv", row.names = 1)

second_screen_excluded <- rbind(first_screen_excluded, excluded)

        # Add exclusion reason

exclusion_reason<-rep("Not_relevant", length(second_screen_excluded$STUDY_ID))
second_screen_excluded<-cbind(second_screen_excluded, exclusion_reason) 

write.csv(second_screen_excluded, "Processed_Data/Legumes/Legumes_excluded.csv")
write.csv(second_screen_excluded, "Outputs/Screening/Legumes/Legumes_excluded.csv")

library(writexl)

write_xlsx(second_screen_excluded, "Processed_Data/Legumes/Excel_legumes_excluded.xlsx",col_names=TRUE, format_headers = TRUE)
write_xlsx(second_screen_excluded, "Outputs/Screening/Legumes/Excel_legumes_excluded.xlsx",col_names=TRUE, format_headers = TRUE)

        # Create a data frame of papers included in the second screen, to asess in a third screen at full text

setwd("C:/Users/raw_c/OneDrive/Escritorio/NHM/NHM R Project")

unique(d$INCLUDE)

included <- subset(d, d$INCLUDE == "maybe")

write.csv(included, "Outputs/Screening/Legumes/Legumes_third_screen.csv")
write_xlsx(included, "Outputs/Screening/Legumes/Excel_legumes_third_screen.xlsx",col_names=TRUE, format_headers = TRUE)


# 7. Third screen: full text screen

# 8. Add the studies excluded in the third screen to the excluded data frame and create a data frame of included
#    studies

rm(list=ls())

library(readxl)

unique(d$Include)

d <- read_excel("Outputs/Screening/Legumes/Excel_legumes_third_screen.xlsx")
excluded <- subset(d, d$Include == "No")

first_screen_excluded <- read.csv("Processed_Data/Legumes/Legumes_excluded.csv", row.names = 1)

    # Match column names to rbind

library(dplyr)

colnames(first_screen_excluded)
colnames(excluded)

first_screen_excluded <- first_screen_excluded[,-c(1,2)]
colnames(first_screen_excluded)[1] <- "Include"
first_screen_excluded <- relocate(first_screen_excluded, exclusion_reason, .after = Include)
colnames(first_screen_excluded)[2] <- "Exclusion_reason"

nrow(first_screen_excluded)
Comments <- rep("", 1218)
first_screen_excluded$Comments <- rep("", 1218)
first_screen_excluded <- relocate(first_screen_excluded, Comments, .after = Exclusion_reason)

colnames(first_screen_excluded)
colnames(excluded)

    # rbind third screen excluded papers to excluded data frame

third_screen_excluded <- rbind(first_screen_excluded, excluded)

write.csv(third_screen_excluded, "Processed_Data/Legumes/Legumes_excluded.csv")
write.csv(third_screen_excluded, "Outputs/Screening/Legumes/Legumes_excluded.csv")

library(writexl)

write_xlsx(third_screen_excluded, "Processed_Data/Legumes/Excel_legumes_excluded.xlsx",col_names=TRUE, format_headers = TRUE)
write_xlsx(third_screen_excluded, "Outputs/Screening/Legumes/Excel_legumes_excluded.xlsx",col_names=TRUE, format_headers = TRUE)

# Create a data frame of papers included in the second screen, to asses in a third screen at full text

unique(d$Include)

included <- subset(d, d$Include == "Yes" | d$Include == "Maybe")

write.csv(included, "Outputs/Screening/Legumes/Legumes_included.csv")
write_xlsx(included, "Outputs/Screening/Legumes/Excel_legumes_included.xlsx",col_names=TRUE, format_headers = TRUE)




