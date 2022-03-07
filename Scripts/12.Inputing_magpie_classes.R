# Cristina Raw 
# 4/3/22

# In this script I am going to add a column with Magpie's crop classes,
# which, according to Andy, come from FAO's commodity classes.

rm(list = ls())

# Load data

d <- read.csv("Data/01.Processed_Data/03.Curated_spreadsheet/Csv_Crops_Quantitative_spreadsheet.csv", 
              row.names = 1)


# Make dataframe with commodities and crops----

colnames(d)

library(dplyr)
library(tidyr)

my_classes <- select(d, Commodity, Crop)

my_classes <- my_classes %>% distinct() # Remove duplicate rows


# Check which crops are included within each commodity, and use this information 
# to make an excel where I classify my crops into magpie's commodities

    # a. check crops are classified correctly into the commodity classes

commodities <- unique(my_classes$Commodity)  # 1. Create vector with the name of the orders of the data frame 

commodities_list <- list()   # 2. Create a list where I will store the subseted data

                             # 3. For each commodity in the commodities verctor, filter 
                             # the commodity column in the my_classes data frame and when the
                             # commodity in the data frame matches the commodity in the
                             # vector, subset that data and put in into the list.
                             # [[com]] names each subset with the ord name, so
                             # the subsetted data will be stored in the list under its 
                             # commodity name. 


for (com in commodities){                                   
  data <- dplyr :: filter( my_classes , Commodity == com)    
                                                             
  commodities_list[[com]] <- data                          
}                                                           
                                                           

# Make excel where with magpie classes----
                                                          
# Save my_classes data frame so I can use it to make an excel where I classify 
# my crops into the magpie classes, so I can then make a column with the 
# magpie classes

library(writexl)

write_xlsx(my_classes, "Outputs/06.Magpie_classes/my_classes.xlsx")


# I made an excel where I classify my crops into the magpie classes and saved
# it in: 

    # Outputs/06.Magpie_classes/my_classes.xlsx
    # Data/04.Magpie_classes


# Add magpie classes column in my data set---- 

# Load the excel file with magpie classes and my crops

magpie <- read.csv2("Data/04.Magpie_classes/CSV_Magpie_classess.csv")

d$magpie_class <- ""    # Create column in data frame where I will input magpie's
                        # crop classess depending on the crop recorded in the row

colnames(magpie)[3] <- "My_crops"  # Change column name that bothered me


#Input magpie classes into my d data set

magpie <- na.omit(magpie)  # First I remove rows with NA in the magpie data set
                           # for two reasons: 
                           # 1. NA rows means I don't have data for that crop
                           # 2. NA's will interrupt the following for loop

for (i in (1:587)){
  #browser()
  for (j in (1:29)){
    if (d$Crop[i] == magpie$My_crops[j]){
      d$magpie_class[i] <- magpie$Magpie_classess[j]
    }}}

# Check it worked 

unique(d$magpie_class)
empty <- subset(d, d$magpie_class == "")  # Barley did not work because it has 
                                          # a space at the end 

# Correct barley

magpie[5,3] <- "Barley"

# Rerun loop 

for (i in (1:587)){
  #browser()
  for (j in (1:29)){
    if (d$Crop[i] == magpie$My_crops[j]){
      d$magpie_class[i] <- magpie$Magpie_classess[j]
    }}}

# Check it worked 

unique(d$magpie_class)   # It worked


# Magpie data digest ----

  # Coarse data digest: how many observations per magpie class?

magpie_data <- as.data.frame(table(d$magpie_class))

  # Detailed data digest: within each magpie class, how many observations per crop?

crop_data <- as.data.frame(table(d$Crop))

  # Add column with magpie classes

colnames(crop_data)[1] <- "Crop"
colnames(crop_data)[2] <- "N"


for (i in (1:31)){
  #browser()
  for (j in (1:31)){
    if (crop_data$Crop[i] == magpie$My_crops[j]){
      crop_data$Magpie_class[i] <- magpie$Magpie_classess[j]
    }}}

crop_data <- relocate(crop_data, Magpie_class, .before = Crop)

# Save data frames

write_xlsx(magpie_data, "Outputs/06.Magpie_classes/DataDigest/Excel_DataDigest_MagpieClasses.xlsx")
write.csv(magpie_data, "Outputs/06.Magpie_classes/DataDigest/CSV_DataDigest_MagpieClasses.csv")

write_xlsx(crop_data, "Outputs/06.Magpie_classes/DataDigest/Excel_DataDigest_CropData.xlsx")
write.csv(crop_data, "Outputs/06.Magpie_classes/DataDigest/CSV_DataDigest_CropData.csv")


# Count number of papers per crop ----

papers <- select(d, Crop, Paper_ID)

data_count_1 <- aggregate(data = papers,                  # Count the number of 
                          Paper_ID ~ Crop,                # per crop
                          function(x) length(unique(x)))

crop_Nstudies_Npapers <- merge(crop_data,data_count_1,by="Crop")  # Make table

write_xlsx(crop_Nstudies_Npapers, "Outputs/06.Magpie_classes/DataDigest/Crops_Nstudies_Npapers.xlsx")





