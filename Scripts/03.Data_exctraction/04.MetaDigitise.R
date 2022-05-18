rm(list=ls())



# In this script I am going to use the metaDigitise package to extract data from plots and figures from the included
# studies. 
 

library(metaDigitise)


d <- metaDigitise("Data/02.Data_Extraction/metaDigitise/Photos", cex = 0.5)


library(writexl)

write.csv(d, "Outputs/04.Data_extraction/Meta_Digitise/MetaDigitise_data.csv")
write_xlsx(d, "Outputs/04.Data_extraction/Meta_Digitise/Excel_MetaDigitise_data.xlsx", col_names = TRUE, format_headers = TRUE, use_zip64 = FALSE)


