rm(list=ls())

# I am going to pilot the data extraction spreadsheet. To do so, I will create a data frame with all the papers classified as "YES" or "Maybe" in 
# the screening phase. Then, I will randomize order of the papers in the data frame. Finally, I will select a random sample of 20 papers from the 
# randomized data frame. With that random sample, I will pilot the data extraction spreadsheet. Since I have only finished screening the sugar and oil commodities, I will
# pilot the spread sheet using only this data.

# 1. Create the data frame with the papers classified as "YES" or "Maybe" in the screening phase

library(readxl)

sugar <- read.csv("Data/02.Data_Extraction/Sugar_ext/Sugar_included.csv", row.names =1)
oil <- read.csv("Data/02.Data_Extraction/Oil_ext/Oil_included.csv", row.names = 1)

colnames(sugar)
colnames(oil)


    # Make column order the same in all data frames to merge afterwords
        
library(dplyr)

oil <- oil[,-2]
sugar <- sugar[,-7]
oil <- relocate(oil, Issue, .after = Volume)
sugar <- sugar[,-12]
oil <- oil[,-12]
sugar <- sugar[, -c(16 , 23)]

    # Merge

merge <- rbind(oil, sugar)

# 2. Randomize order of the papers in the data frame

rows <- sample(nrow(merge))
random_merge <- merge[rows, ]ç

library(writexl)

write.csv(random_merge, "Outputs/03.Spreadsheet_piloting/Pilot_data.csv")
write_xlsx(random_merge, "Outputs/03.Spreadsheet_piloting/Excel_pilot_data.xlsx", col_names = TRUE, format_headers = TRUE)

# 3. Select a random sample of 10 papers from the randomized data frame to pilot the data extraction spread sheet

random_sample <- sample(1:64, size = 10)

random_sample 

# These are the indices of the papers I will use to pilot the spreadsheet:  6  2 55 24 50 19 34 37 23 25


