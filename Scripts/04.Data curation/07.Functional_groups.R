rm(list = ls())

# Christina Raw 4/2/22
# In this script I am going to fill out the functional groups from the data obtained by
# extracting the data from the included papers. To quicly obtain the functional groups infromation,
# I am going to use the data set from my thesis, where I recorded arthropod's functional groups.

library(tidyverse)

# First by kingdom

unique(d$Kingdom)

# Clean up

d$Kingdom[d$Kingdom == "Mycorrhizal_fungi"] <- "Fungi"
d$Kingdom[d$Kingdom == "Actinomyceta"] <- "Bacteria"
d$Kingdom[d$Kingdom == "Native_palm"] <- "Plantae"

na.kingdom <- d %>%                        # The NA observations for kingdom
  subset(is.na(.$Kingdom == TRUE)) %>%     # already have the functional groups
  as.data.frame()

# Input functional groups

d$Functional_group[d$Kingdom == "Microbes"|
                     d$Kingdom == "Fungi"|
                     d$Kingdom == "Bacteria"] <- "Soil"

d$Functional_group[d$Kingdom == "Plantae"] <- "Air_Climate_Freshwater_Soil_ExtremeEvents"

d$Functionalr_group[d$Kingdom == "Forest_species"] <- "NA"

# By animal

animal <- subset(d, d$Kingdom == "Animal")
unique(animal$Phylum)

which(animal$Phylum == "Invertebate") 
which(animal$Phylum == "Vertebrates") 
which(animal$Phylum == "Chordata") 

# Arthropoda by order
# Invertebrate: too broad <- NA
# Nematoda: soil //www.nature.com/articles/s41597-020-0437-3
# Annelida: soil
# Insecta: by order
# Vertebrates: too broad
# Chordata: by class
# Biodiversity: too broad <- NA

d$Functional_group[d$Kingdom == "Animal" &
                     d$Phylum == "Invertebrate"] <- "NA"

d$Functional_group[d$Kingdom == "Animal" &
                     d$Phylum == "Nematoda"] <- "Soil"

d$Functional_group[d$Kingdom == "Animal" &
                     d$Phylum == "Annelida"] <- "Soil"

d$Functional_group[d$Kingdom == "Animal" &
                     d$Phylum == "Vertebrates"] <- "NA"

d$Functional_group[d$Kingdom == "Animal" &
                     d$Phylum == "Biodiversity"] <- "NA"

# By arthropod

# Clean up

unique(animal$Phylum)
arthropod <- subset(d, d$Phylum == "Arthropoda")

unique(arthropod$Class)
d$Class[d$Class == "Araneae"] <- "Arachnida"

# Input functional group

unique(arthropod$Class)
myriapoda <- subset(arthropod, Class == "Miryapoda")
malacostraca <- subset(arthropod, Class == "Malacostraca")

# Insecta: by order or species
# Arachnida: by order or species 
# Collembola: soil
# Edaphic_arthropods: soil
# Myriapoda: they are chilopoda observations: soil https://pubmed.ncbi.nlm.nih.gov/31963103/
# Malacostraca: they are isopoda observations: soil  https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6288264/#:~:text=Consequently%2C%20terrestrial%20isopods%20are%20considered,affect%20physical%20properties%20of%20soil.
# Canopy: too broad <- NA
# Leaf_litter: soil 

# Input functional group

d$Functional_group[d$Phylum == "Arthropoda" &
                     d$Class == "Collembola"] <- "Soil"

d$Functional_group[d$Phylum == "Arthropoda" &
                     d$Class == "Edaphic_arthropods"] <- "Soil"

d$Functional_group[d$Phylum == "Arthropoda" &
                     d$Class == "Myriapoda"] <- "Soil"

d$Functional_group[d$Phylum == "Arthropoda" &
                     d$Class == "Malacostraca"] <- "Soil"

d$Functional_group[d$Phylum == "Arthropoda" &
                     d$Class == "Canopy"] <- "Soil"

d$Functional_group[d$Phylum == "Arthropoda" &
                     d$Class == "Leaf_litter"] <- "Soil"

# By insect

insect <- subset(d, d$Class == "Insecta")
unique(insect$Order)
unique(insect$Family)
unique(insect$Genus_Species)

# I want to see whether I gan get func.group info from thesis data set

names(Data_extraction_spreadsheet_1)
Data_extraction_spreadsheet_1 <- select(Data_extraction_spreadsheet_1, 
                                        Class, Order, Family, Genus_Species,
                                        Functional_group) # Tehsis data

Data_extraction_spreadsheet_1 <- distinct(Data_extraction_spreadsheet_1)

names(insect)
insect <- select(insect, Order, Family, Genus_Species) # MMA data

insect <- distinct(insect) # deduplicated mma data




