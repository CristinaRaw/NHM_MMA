# Christina Raw. 22/3/2022
# After having calculated the weighted means, I realized they are not very useful,
# so I am going to try to model. For this, I completed the control information and 
# now the next steps are: 
#   1. Subset LRR and % change data
#   2. Transform LRR into % data and merge data sets
#   3. Input column for control biodiversity value ( = 100) and a column for the 
#      intervention biodiversity value that is the difference to the reference 
#      value.
#   4. Once I have the control and intervention value I can model

library(readxl)
library(dplyr)
library(writexl)

d <- read_xlsx("Datasets/04.Excel_Magpie_Crops_WithControl_Quantitative_spreadsheet.xlsx")

# 1. Subset LRR and % change data

unique(d$Effect_size)
perc <- subset(d, Effect_size == "Percentage_change")
LRR <- subset(d,  Effect_size == "LRR" )

# 2. Transform LRR into % data and merge data sets

LRR$Percentage_change = 100 * (exp(LRR$Value) - 1)
perc <- rbind(perc, LRR)

# 3. Input column for control biodiversity value (= 100) and a column for the 
#    intervention biodiversity value that is the difference to the reference 
#    value.

perc$Control_Percentage_Change <- 100 # Add control biodiversity value
perc <- mutate(perc, Intervention_Percentage_Change = 100 + Percentage_change)

write_xlsx(perc, "Datasets/05.Excel_Percentage_Dataset_to_model.xlsx")

