rm(list = ls())

# Christina Raw 4/2/22
# In this script I am going to fill out the functional groups from the data obtained by
# extracting the data from the included papers.

# Functional groups from https://www.pnas.org/doi/10.1073/pnas.2010473117#t01

library(readxl)
library(tidyverse)
library(writexl)

d <- read_excel("Datasets/07.Excel_Dataset_to_model_LRR_LONG.xlsx")

# First by kingdom----

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



# By animal----

  # Clean up

d$Phylum[d$Phylum == "Chordata"] <- "Vertebrates"

  # Input functional groups

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
# Vertebrates: too broad <- NA
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




# By arthropod----

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




# By insect----

  # Clean up

unique(d$Genus_Species)

d$Genus_Species[d$Genus_Species == "N. brevicollis" ] <- "Nebria brevicollis"
d$Family[d$Family == "Apiae"] <- "Apidae"
d$Family[d$Family == "Whitefly"] <- "Aleyrodidae"
d$Family[d$Family == "Mealybugs"] <- "Pseudococcidae"

insect <- subset(d, d$Class == "Insecta")
unique(insect$Order)
unique(insect$Family)
unique(insect$Genus_Species)


# I am going to make and excel with  insect the species names to input their functional
# group information obtained from internet. Then I will load it and use it to 
# input functional info in the data set. 


  # Make excel with insect species names to input their functional group

species <- as.data.frame(insect$Genus_Species)
species <- drop_na(species)

write_xlsx(species, "Outputs/species_to_funtional_groups.xlsx") 

  # Load the species name with the functional groups

functional_groups <- read_excel("Outputs/species_to_funtional_groups.xlsx")
names(functional_groups)[1] <- "Genus_Species"


  # Input functional groups in the main data frame using the species and functional
  # group info from the species data frame

d$Genus_Species[is.na(d$Genus_Species) == TRUE] <- "NA" # Make Na character so the 
                                                        # for loop can work

check <- cbind(d$Genus_Species, x$Genus_Species)  # Check it worked
is.na(d$Genus_Species)

unique(d$Genus_Species)                           # Make sure the species names are
unique(functional_groups$`insect$Genus_Species`)  # the same in both df so the for 
                                                  # loop will work

d$Genus_Species[d$Genus_Species == "Pterostichus\r\nmelanarius"] <- "Pterostichus melanarius"
d$Genus_Species[d$Genus_Species == "Brassicogethes \r\naeneus"] <- "Brassicogethes aeneus"

functional_groups$Genus_Species[functional_groups$Genus_Species == "Brassicogethes \r\r\naeneus"] <- "Brassicogethes aeneus"
functional_groups$Genus_Species[functional_groups$Genus_Species == "Pterostichus\r\r\nmelanarius"] <- "Pterostichus melanarius"

  # For loop: when the species name in d data frame matches the species name in 
  # the functional groups data frame, input the functional group data from the 
  # functional group data frame into the d data fame

for (i in (1:698)){
  #browser()
  for (j in (1:42)){
    if (d$Genus_Species[i] == functional_groups$Genus_Species[j]){
      d$Functional_group[i] <- functional_groups$Functional_group[j]
    }}}
 
  
  # Check it worked 

insect <- subset(d, d$Class == "Insecta")

  # Add predator in Nebria brevicollis

d$Functional_group[d$Genus_Species == "Nebria brevicollis"] <- "Predators"



# Now that I have imputed the functional groups by species, I am going to try to 
# input the functional groups for those observations that don't have taxonomic
# information to species level

insect <- subset(d, d$Class == "Insecta")

is.na(insect$Genus_Species) # The NAs are characters

na.insect <- subset(insect, insect$Genus_Species == "NA")
unique(na.insect$Family)

  # Apidae <- Pollination
  # Culicidae <- Various
  # Carabidae <- Various
  # Delphacidae <- Pest
  # Formicidae <- Soil, pollination and seeds, regulation of detrimental organisms
  # Aleyrodidae <- Pest
  # Pseudococcidae <- Pest

# Input functional groups

d$Functional_group[d$Family == "Apidae" &
                     d$Genus_Species == "NA"] <- "Pollination_seeds"

d$Functional_group[d$Family == "Culicidae" &
                     d$Genus_Species == "NA"] <- "NA"

d$Functional_group[d$Family == "Carabidae" &
                     d$Genus_Species == "NA"] <- "NA"

d$Functional_group[d$Family == "Delphacidae" &
                     d$Genus_Species == "NA"] <- "Pest"

d$Functional_group[d$Family == "Formicidae" &
                     d$Genus_Species == "NA"] <- "Soil_PollinationSeeds_NaturalEnemy"


d$Functional_group[d$Family == "Aleyrodidae" &
                     d$Genus_Species == "NA"] <- "Pest"

d$Functional_group[d$Family == "Pseudococcidae" &
                     d$Genus_Species == "NA"] <- "Pest"


# Make NAs characters----

d$Functional_group[is.na(d$Functional_group == TRUE)] <- "NA"

is.na(d$Functional_group) # Check it worked


# Check everything worked----

names(d)

groups <- d %>% 
  select(Kingdom, Phylum, Class, Order, Family, Genus_Species, Functional_group) %>% 
  distinct() %>% 
  subset(.$Functional_group == "NA")

unique(d$Functional_group)

d$Functional_group[d$Functional_group == "soil"] <-"Soil"
d$Functional_group[d$Functional_group == "pest"] <-"Pest"
d$Functional_group[d$Functional_group == "natural enemy"] <-"Natural_enemy"
d$Functional_group[d$Functional_group == "pollinator"] <-"Pollination_seeds"
d$Functional_group[d$Functional_group == "plant"] <-"Air_Climate_Freshwater_Soil_ExtremeEvents"

# Save ----

write_xlsx(d, "Datasets/07.Excel_Dataset_to_model_LRR_LONG.xlsx")

