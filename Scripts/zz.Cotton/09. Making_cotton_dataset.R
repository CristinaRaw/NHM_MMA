# Cristina Raw
# 10/02/2022
# I have chosen cotton as the crop to go more in detail. In this script I am
# going to:

#   1. Extract all the quantitative and qualitative data on cottn from the 
#      dataset 
#   2. Save as excel to have a cotton data set to work on and input more data
#      from the cotton papers.

# The data set consists on quantitative and qualitative measures of biodiversity
# under different production systems for different crops.

rm(list = ls())

library(dplyr)

cotton_quantitative <- read.csv("Data/01.Processed_Data/03.Curated_spreadsheet/Csv_Crops_Quantitative_spreadsheet.csv", row.names = 1)
                                
cotton_qualitative <- read.csv("Data/01.Processed_Data/03.Curated_spreadsheet/Csv_Crops_Qualitative_spreadsheet.csv", row.names = 1)
                               

# 1. Extract cotton quantitative and qualitative data from the dataset

unique(cotton_quantitative$Crop)

cotton_quantitative <- subset(cotton_quantitative, cotton_quantitative$Crop == "Cotton" | 
                                                   cotton_quantitative$Crop == "Bt_Cotton" | 
                                                   cotton_quantitative$Crop == "GM_Cotton")

unique(cotton_qualitative$Crop)

cotton_qualitative <- subset(cotton_qualitative, cotton_qualitative$Crop == "Bt_Cotton" |
                                                 cotton_qualitative$Crop == "Cotton")


#   2. Save as excel to have a cotton data set to work on and input more data
#      from the cotton papers.

library(writexl)

write_xlsx(cotton_quantitative, "Outputs/05.Cotton/Cotton_quantitative_data.xlsx",
           col_names = T, format_headers = T)

write_xlsx(cotton_quantitative, "Data/00.Raw_Data/04.Cotton/Cotton_quantitative_data.xlsx",
           col_names = T, format_headers = T)


write_xlsx(cotton_qualitative, "Outputs/05.Cotton/Cotton_qualitative_data.xlsx",
           col_names = T, format_headers = T)

write_xlsx(cotton_qualitative, "Data/00.Raw_Data/04.Cotton/Cotton_qualitative_data.xlsx",
           col_names = T, format_headers = T)


