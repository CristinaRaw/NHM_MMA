rm(list=ls())

# I will create a data frame with all the papers classified as "YES" or "Maybe" in the screening phase. 
# Then, I will randomize order of the papers in the data frame. 


# 1. Create the data frame with the papers classified as "YES" or "Maybe" in the screening phase

sugar <- read.csv("Outputs/02.Screening/Sugar/Sugar_included.csv", row.names =1)
oil <- read.csv("Outputs/02.Screening/Oil/Oil_included.csv", row.names = 1)
legumes <- read.csv("Outputs/02.Screening/Legumes/Legumes_included.csv", row.names = 1)

      # Make column order the same in all data frames to merge afterwords. The order of columns will be:
      # Include, Comments, Document_type, Author, Year, Title, Journal, Volume, Issue, Pages, Month, Document_type.1,
      # Serial_ID, DOI, WOS_ID, Abstract, Citations, URL, Adress, Databbase, Language

library(dplyr)

colnames(sugar)
colnames(oil)
colnames(legumes)

colnames(sugar)[1] <- "Include"
colnames(oil)[1] <- "Include"

colnames(oil)[2] <- "Comments"
legumes[22,3] <-"Qualitative"
legumes <- legumes[,-2]
colnames(sugar)[21] <- "Comments"
sugar <- relocate(sugar, Comments, .after = Include)

colnames(legumes)[4] <- "Authors"
sugar <- sugar[,-8]
oil <- relocate(oil, Issue, .after = Volume)

sugar <- sugar[,-c(13,14)]
oil <- oil[,-c(13,14)]
legumes <- legumes[,-13]

colnames(legumes)[13] <- "Serial_ID"

sugar <- sugar[,-16]

      # Merge

merge <- rbind(sugar, oil, legumes)

# 2. Randomize order of the papers in the data frame. The order is then randomized. 

rows <- sample(nrow(merge))
random_merge <- merge[rows, ]?
  
  library(writexl)

write.csv(random_merge, "Outputs/04.Data_extraction/Data_extraction_papers.csv")
write_xlsx(random_merge, "Outputs/04.Data_extraction/Excel_data_extraction_papers.xlsx", col_names = TRUE, format_headers = TRUE)


