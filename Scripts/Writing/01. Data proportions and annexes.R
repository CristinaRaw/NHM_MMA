library(readxl)

quali <- read.csv("Processed_Data/Curated_spreadsheet/Csv_Crops_Qualitative_spreadsheet.csv")
quanti <- read.csv("Processed_Data/Curated_spreadsheet/Csv_Crops_Quantitative_spreadsheet.csv")

# Number of papers

unique(quanti$Paper_ID)
unique(quali$Paper_ID)

library(dplyr)

quanti_papers <- select(quanti, Paper_ID)
quali_papers <- select(quali, Paper_ID)

c <- rbind(quanti,quali)

unique(c$Paper_ID)

colnames(quanti)

# Proportions

    # Kingdoms

quanti %>% group_by(Kingdom) %>%   # I have to add up % to obtain some groups
                                   # e.g., microbe + microbes
  tally(sort = TRUE) %>%
  
  mutate(freq = (n/sum(n))*100)


quali %>% group_by(Kingdom) %>%
  
  tally(sort = TRUE) %>%
  
  mutate(freq = (n/sum(n))*100)


    # Commodity

quanti %>% group_by(Commodity) %>%
  
  tally(sort = TRUE) %>%
  
  mutate(freq = (n/sum(n))*100)


quali %>% asgroup_by(Commodity) %>%
  
  tally(sort = TRUE) %>%
  
  mutate(freq = (n/sum(n))*100)


    # Production system

quanti_practices <- quanti %>% group_by(Production_system) %>%
  
  tally(sort = TRUE) %>%
  
  mutate(freq = (n/sum(n))*100)


quali_practices <- quali %>% group_by(Production_system) %>%
  
  tally(sort = TRUE) %>%
  
  mutate(freq = (n/sum(n))*100)

    
    # Biodiversity measure

quanti_biodiversity <- quanti %>% group_by(Biodiversity_measure) %>%
  
  tally(sort = TRUE) %>%
  
  mutate(freq = (n/sum(n))*100)

quali_biodiversity <- quali %>% group_by(Biodiversity_measure) %>%
  
  tally(sort = TRUE) %>%
  
  mutate(freq = (n/sum(n))*100)


# Exclusion reasons

d <- read_excel("Processed_Data/Curated_spreadsheet/Final_Crops_Spreadsheet_Excel.xlsx", sheet = 1)
unique(d$Include)
excluded <- subset(d, d$Include == "No")


# Variables extracted

colnames(quanti)

library(metaDigitise)

