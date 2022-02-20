rm(list = ls())

# Christina Raw 4/2/22
# In this script I am going to fill out the functional groups from the data obtained by
# extracting the data from the included papers. To quicly obtain the functional groups infromation,
# I am going to use the data set from my thesis, where I recorded arthropod's functional groups.

# Load the data set I used in my thesis

thesis_dataset <- read.csv("Data/00.Raw_Data/02.Data_extraction/Clean_spreadsheet_1.csv") 

# Select the columns of interest, those that include taxonomical data and information about  
# functional groups

library(dplyr)

names(thesis_dataset)

fg <- select(thesis_dataset, "Taxonoic_group", "Order", "Family", "Genus_Species", "Functional_group")

# Create a data frame that contains unique rows and subset by order. With this information I will be 
# able to easily get the functional groups for each order. I chose to subset by order first, and then
# I will see by family.

fg_table <- as.data.frame(unique(fg)) 

    # Subset by order


# What I want to do is: for each unique order in the data frame, I want to subset its data. To do so,
# I have to filter the Order column in the data frame with the names of the orders, and for each order
# I am going to put its darn in a list. Steps:

    # 1. Create vector with the name of the orders of the data frame
    # 2. Create a list where I will store the subseted data
    # 3. Filter the data frame with the name of the orders to subset the information for each order and
    #    store that information in the list. WARNING: to select data un list you have to use [[]], it's
    #    just the way it is.
    # 4. Create data frames with the data for each orderstored in the list.

order <- unique(fg$Order)  # 1. Create vector with the name of the orders of the data frame 

order_list <- list()   # 2. Create a list where I will store the subseted data

for (ord in order){                                     # 3. For each order in the order verctor, filter 
  data <- dplyr :: filter( fg_table , Order == ord)     # the Order column in the data frame and when the 
                                                        # Order in the data frame matches the order in the 
  order_list[[ord]] <- data                             # vector, subset that data and put in into the list.
}                                                       # [[ord]] names each subset with the ord name, so 
                                                        # the subsetted data will be stored in the list under its 
                                                        # order name. 



col_df <- order_list[["Coleoptera"]]      # 4. Create data frames with the data for each orderstored in the list.








