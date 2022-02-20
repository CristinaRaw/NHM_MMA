rm(list=ls())

# In this script I am going to extract the data from figures from the cotton 
# papers, as I have decided to go more in detail with cotton.

library(metaDigitise)

d <- metaDigitise("Data/02.Data_Extraction/metaDigitise/Photos_cotton/", cex = 0.5)



library(writexl)

write.csv(d, "Outputs/04.Data_extraction/Meta_Digitise/Cotton/Cotton_MetaDigitise_data.csv")
write_xlsx(d, "Outputs/04.Data_extraction/Meta_Digitise/Cotton/Cotton_Excel_MetaDigitise_data.xlsx", col_names = TRUE, format_headers = TRUE, use_zip64 = FALSE)



