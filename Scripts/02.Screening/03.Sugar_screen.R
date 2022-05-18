rm(list=ls())

library(metagear)

# Steps:
#   1. Load data set of merged references downloaded from Scopus and WOS for sugar
#   2. First screen of references
#   3. Add exclusion reason column 
#   4. Create two data frames: one with first screen excluded studies and one with the studies that will go through
#      a second screen
#   5. Second screen of studies
#   6. Add the studies excluded in the second screen to the excluded data frame and create a data frame of included
#      studies

# 1. Load data set of merged references downloaded from Scopus and WOS for sugar

d <- read.csv("Raw_Data/Sugar/sugar_first_screen.csv", header = TRUE, row.names = 1)

        # Clean data set and select columns of interest 

d <- d[,-c(5,7,10,14,15,16,19,24,25,26,27,28,29,30,31,32,33,34,36,37,41,43,45,46,47,48,49,51)] #Drop empty columns
d <- d[,-10]

colnames(d) <- c("Document_type", "Authors", "Year", "Title", "Journal","Source", "Volume", "Issue", "Pages", 
                 "Month","Document_type", "Description", "Abbreviated_source_title", "Serial_ID", "DOI", 
                 "WOS_ID", "Key_words", "Abstract", "Citations", "URL", "Adress","Database", "Language" )

write.csv(d, "Processed_Data/Sugar/sugar_first_screen.csv")

rm(d)

d <- read.csv("Processed_Data/Sugar/sugar_first_screen.csv", row.names = 1)

# 2. First screen of references

        # Now  I have to screen the references to classify as relevant (YES), maybe relevant (maybe) or 
        # not relevant (NO) to this meta-analysis.
        # Initialize adds three columns: study_ID, reviewers (only me, Christina) and INCLUDE (yes, no, maybe).
        # Saves automatically a copy, called "effort_Christina". 

d_initialized<-effort_distribute(d,                              #effort_Christina.csv.
                                 initialize = TRUE,              #I changed file location to: Escritorio/NHM/NHM R   
                                 reviewers = "Christina",        #/Output/Screening/Sugar   
                                 save_split = TRUE)

        # Load initialized data

screening<-read.csv("Outputs/Screening/Sugar/effort_Christina.csv")

        # Start screening the references with abstract_screener. References will be classified as yes, no, maybe             # according to the inclusion criteria 

abstract_screener(file="Outputs/Screening/Sugar/effort_Christina.csv",
                  aReviewer = "Christina",
                  abstractColumnName="Abstract",
                  titleColumnName="Title",
                  highlightKeywords = c("sugarcane","beet","sugarbeet", "sugar beet","meta-analysis", "meta analysis", "review", "biodiversity", "richness",
                                        "abundance", "diversity", "ecosystem", "compar", "contrast", "differenc",  "effect", "affect",
                                        "influ", "impact", "traditional", "manual", "mechan", "burn*", "vertical", "production system", "farming system",
                                        "crop", "farm", "production", "system", "conventional", "divers", "sustainable", "ecological", "organic",
                                        "intens", "extens", "abandon", "lough", "fallow", "biotic", "hedgerow", "polycultur", "strip", "mixed",
                                        "land", "tillage", "natural habitat", "set aside", "mosaic"))


# 3. Add exclusion reason column 

        # a. Create data.frame of excluded with "NO" classification in the first screening

rm(list=ls())
install.packages("dplyr")
library(dplyr)

first_screen<-read.csv("Outputs/Screening/Sugar/effort_Christina.csv")
tail(first_screen$INCLUDE)

first_screen_excluded<-subset(first_screen, first_screen$INCLUDE=="NO")

        # b. Create vector of exclusion reason "Not_relevant

exclusion_reason<-rep("Not_relevant", length(first_screen_excluded$STUDY_ID))

        # c. Add vector as column to first_screen_excluded data.frame

first_screen_excluded<-cbind(first_screen_excluded, exclusion_reason) 

write.csv(first_screen_excluded,"Outputs/Screening/Sugar/Sugar_excluded.csv")


# 4. Create two data frames: one with first screen excluded studies and one with the studies that will go through
#    a second screen

        # a. Create data.frame of papers classified as YES/MAYBE to screen again. To screen it again I will remove                the study_ID, reviewers, and initialize it again

second_screen_data<-subset(first_screen,first_screen$INCLUDE=="YES"|first_screen$INCLUDE=="maybe")

second_screen_data<-second_screen_data[,-c(1:3)]

write.csv(second_screen_data,"Outputs/Screening/Sugar/Sugar_second_screen.csv")

# 5. Second screen of studies. Now I am going to perform the second screen at full text of the studies classified as      YES/MAYBE. I will save the data frame in excel format because it will be easier to do the full text screen

library(writexl)

write_xlsx(second_screen_data, "Outputs/Screening/Sugar/Excel_sugar_second_screen.xlsx",col_names=TRUE, format_headers = TRUE)

        # Add excluded papers from the second screen to the excluded data frame and create another data frame
        # with the included papers

# 6. Add the studies excluded in the second screen to the excluded data frame and create a data frame of included
#    studies

rm(list=ls())

d <- read_excel("Outputs/Screening/Sugar/Excel_sugar_second_screen.xlsx")
excluded <- read.csv("Outputs/Screening/Sugar/Sugar_excluded.csv", row.names = 1)

        # Make sure they have the same columns

colnames(d)
colnames(excluded)

d <- d[,-26]
excluded <- excluded[,-c(1,2)]

        # Add the studies excluded in the second screen to the excluded data frame

unique(d$INCLUDE)
d_excluded <- subset(d, d$INCLUDE == "No")

excluded <- rbind(excluded, d_excluded)

write.csv(excluded, "Outputs/Screening/Sugar/Sugar_excluded.csv")
write_xlsx(excluded, "Outputs/Screening/Sugar/Excel_sugar_excluded.xlsx",col_names=TRUE, format_headers = TRUE)

        # Create a data frame of included studies

unique(d$INCLUDE)

included <- subset(d, d$INCLUDE == "Yes" | d$INCLUDE == "Maybe")

write.csv(included, "Outputs/Screening/Sugar/Sugar_included.csv")
write_xlsx(included, "Outputs/Screening/Sugar/Excel_sugar_included.xlsx",col_names=TRUE, format_headers = TRUE)

