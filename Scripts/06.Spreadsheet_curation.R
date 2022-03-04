rm(list = ls())

# Christina Raw
# 4/2/22

# In this script I am going to clean the top 15 crop data extraction spreadsheet that I obtained by extracting the data of 
# the impact of different agricultural production systems on biodiversity. With clean I mean make sure that all the names
# are written the same, that the data is in the right format (numeric, character), and fix errors.

library(dplyr)
library(writexl)

########################################## Quantitative data ##########################################----

# I am going to check the unique values for each column to make sure all the names are correct and fill out any cells that might
# need data

d <- read.csv2("Data/00.Raw_Data/03.Spreadsheet_curation/CSV_v3_Quantitative_Dataset.csv")
names(d)
tail(d$Paper_number)
str(d)

d <- d[,-(46:51)]  # Drop blank columns at the end 
d <- d[-c(591:616),] # Drop blank rows at the end

names(d)

  # Synthesis type

unique(d$Synthesis_type)
d$Synthesis_type[d$Synthesis_type == "Meta_Analysis"]<-"Meta-Analysis"

  # Model

unique(d$Model)
d$Model[d$Model == "Mixed_effect"]<-"Fixed_effects"

  # Commodity

unique(d$Commodity)
d$Commodity[d$Commodity == "Cereas"]<-"Cereals_grains"
d$Commodity[d$Commodity == "Cereals_grains "]<-"Cereals_grains"
d$Commodity[d$Commodity == "Cassava"]<-"Roots_tubers"

  # Crop

crop <- as.data.frame(unique(d$Crop))

unique(d$Crop)

d$Crop[d$Crop == "Dinkel_wheat"]<-"Wheat"
d$Crop[d$Crop == "Maize_Bt"]<-"Bt_Maize"
which(d$Crop == "Maize_redisdue") 
d$Crop[d$Crop == "Maize_redisdue"]<-"Maize"
d$Crop[d$Crop == "Soy"]<-"Soybean"
d$Crop[d$Crop == "Sorghum_residue"]<-"Sorghum"
d$Crop[d$Crop == "Cotton_Bt"]<-"Bt_Cotton"
d$Crop[d$Crop == "GM_Ol"]<-"GM_Rape"
d$Crop[d$Crop == "Oil_Palm"]<-"Oil_palm"
d$Crop[d$Crop == "Gm_Potato"]<-"GM_Potato"
d$Crop[d$Crop == "Potatoes_Bt"]<-"Bt_Potato"
which(d$Crop == "Straw")
d$Crop[d$Crop == "Straw"]<-"Straw_cereals"

    # because there are many rape variants I am using grep

rape <- grepl("rape", ignore.case =  TRUE, d$Crop ) # detect lines that contain rape
unique(d$Crop[rape])# and throw them out

d$Crop[d$Crop == "Bt_oilseed_Rape"]<-"Bt_Rape"
d$Crop[d$Crop == "Bt_Oilseed_rape"]<-"Bt_Rape"
d$Crop[d$Crop == "GM_Oilseed_rape"]<-"GM_Rape"

    #Check crops are correctly classified into the commodities 

commodities <- unique(my_classes$Commodity)  # 1. Create vector with the name of 
                                             # the orders of the data frame 

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

# There is an error because some Maize crops are categorized as legumes

which(d$Commodity == "Legumes" & d$Crop == "Maize")

d[14:26, 15] <- "Cereals_grains"

# There is an error because soybean crops are categorized as cereals and grains

for(i in 1:nrow(d)){
  if(d$Crop[i] == "Soybean"){
    d$Commodity[i] <- "Oils_fats"
  }
}


  # Kingdom

names(d)
king <- as.data.frame(unique(d$Kingdom))
unique(d$Kingdom)

d$Kingdom[d$Kingdom == "Animalia"]<- "Animal"
d$Kingdom[d$Kingdom == "Bacteria "]<- "Bacteria"
d$Kingdom[d$Kingdom == "Microbe "]<- "Microbes"
d$Kingdom[d$Kingdom == "Microbial"]<- "Microbes"
d$Kingdom[d$Kingdom == "Microbe"]<- "Microbes"
d$Kingdom[d$Kingdom == "Microbe"]<- "Microbes"


which(is.na(d$Kingdom))

which(d$Kingdom == "Actinomyceta")


  # Control

control <- as.data.frame(unique(d$Control))
which(is.na(d$Control))

  # Production system

ps <- as.data.frame(unique(d$Production_system))            
d$Production_system[d$Production_system == "Gm"]<- "GM"
d$Production_system[d$Production_system == "Polyculture"]<- "Policulture"

  # Landuse

unique(d$Landuse)

  # Practice

practice <- as.data.frame(unique(d$Practice))
d$Practice[d$Practice == "Gm"]<- "GM"
d$Practice[d$Practice == "Poluyculture"]<- "Policulture"
d$Practice[d$Practice == "Sraw_mulch"]<- "Straw_mulch"
d$Practice[d$Practice == "Staw_romoval"]<- "Straw_removal"

  # Cover crop

names(d)
unique(d$Cover_crop)

  # Bt_type

bt <- as.data.frame(unique(d$Bt_type))
d$Bt_type[d$Bt_type == "Cy1Ac"]<- "Cry1Ac"                           
d$Bt_type[d$Bt_type == "OC-1"]<- "OC1"
d$Bt_type[d$Bt_type == "OC1 "]<- "OC1"

  # Biodiversity measure

bio <- as.data.frame(unique(d$Biodiversity_measure))
d$Biodiversity_measure[d$Biodiversity_measure == "Acundance"]<- "Abundance"
d$Biodiversity_measure[d$Biodiversity_measure == "alkaline phosphatase"]<- "Alkaline phosphatase"         
d$Biodiversity_measure[d$Biodiversity_measure == "dehydrogenase"]<- "dehydrogenase activity"
d$Biodiversity_measure[d$Biodiversity_measure == "dehydrogenase"]<- "Dehydrogenase activity"
d$Biodiversity_measure[d$Biodiversity_measure == "Functional_fiversity"]<- "Functional_diversity"
d$Biodiversity_measure[d$Biodiversity_measure == "Micorria_hifa_lenght"]<- "Mycorrhiza_hifa_length"
d$Biodiversity_measure[d$Biodiversity_measure == "Microbial_biomass_carbon"]<- "microbial biomass carbon (MBC)"
d$Biodiversity_measure[d$Biodiversity_measure == "Microbial_biomass_nitrogen"]<- "microbial biomass nitrogen (MBN),"
d$Biodiversity_measure[d$Biodiversity_measure == "microbial biomass nitrogen (MBN),"]<- "microbial biomass nitrogen (MBN)"
d$Biodiversity_measure[d$Biodiversity_measure == "Richness"]<- "Species_richness"
d$Biodiversity_measure[d$Biodiversity_measure == "Wheight"]<- "Weight"
d$Biodiversity_measure[d$Biodiversity_measure == "Wheight"]<- "Weight"
d$Biodiversity_measure[d$Biodiversity_measure == "Maize"]<- "Count"
d$Biodiversity_measure[d$Biodiversity_measure == "Maize_Legume"]<- "Count"
d$Biodiversity_measure[d$Biodiversity_measure == "Mycorrhizal_fungi"]<- "Mycorrhiza_hifa_length"
d$Biodiversity_measure[d$Biodiversity_measure == "AMF_colonization"]<- "Mycorrhiza_hifa_length"
d$Biodiversity_measure[d$Biodiversity_measure == "microbial biomass\ncarbon (MBC)"]<- "microbial biomass carbon (MBC)"
d$Biodiversity_measure[d$Biodiversity_measure == "microbial\nbiomass phosphorus (MBP)"]<- "microbial biomass phosphorus (MBP)"
d$Biodiversity_measure[d$Biodiversity_measure == "Body_mass"]<- "biomass"
d$Biodiversity_measure[d$Biodiversity_measure == "Suvival_overwinter"]<- "Survial_overwinter"
d$Biodiversity_measure[d$Biodiversity_measure == "Population_composition"]<- "Community_composition"
d$Biodiversity_measure[d$Biodiversity_measure == "Community_diversity"]<- "Community_composition"
d$Biodiversity_measure[d$Biodiversity_measure == "Weed_control_effieciency )<8Mg/ha)"]<- "Weed_control_effieciency (<8 Mg/ha) "
d$Biodiversity_measure[d$Biodiversity_measure == "Weed_control_effieciency (>8 Mg/ha) "]<- "Weed_control_effieciency (>8 Mg/ha)"
d$Biodiversity_measure[d$Biodiversity_measure == "Nitrification;"]<- "Nitrification"


unique(d$Biodiversity_measure)

which(d$Biodiversity_measure == "Biochemical properties, faunal counts (nematode,")
d <- d[-456,]
which(d$Biodiversity_measure == "Enzsoil total organic\ncarbon (TOC)ymatic_activity")
d <- d[-440,]

names(d)

# I'm going to check the class of columns and coerce the wrong ones into their right class

str(d)

d$Sample_size <- as.numeric(d$Sample_size)
d$Value <- as.numeric(d$Value)
d$Percentage_change <- as.numeric(d$Percentage_change)
d$p.value <- as.numeric(d$p.value)
d$SD <- as.numeric(d$SD)
d$SE <- as.numeric(d$SE)
d$Lower_CI <- as.numeric(d$Lower_CI)
d$Upper_CI <- as.numeric(d$Upper_CI)


# When I extracted the data I did not classify each practice into the broader 
# agricultural production system categories (e.g., no-tillage is classified as 
# conservation agriculture). Therefore, the columns 'production system' and practice
# are almost the same. I am going to create a new column with the broad production 
# system categories, and rename the existing columns the following way:
#
#   a. Practice -> Practice detail
#   b. Production system -> Practice

# 1. Create column of broad agricultural production system categories according to
#    the document NHM > Writing > Agricultural practices

          # a. Create data frame with the broad categories and specific practices 

conventional <- data.frame(production_system = "conventional", 
                           practice = c("Straw_removal", "Conventional",
                                        "Intensified", "Tillage", "Monoculture",
                                        "High_irrigation", "High_intensity",
                                        "Straw_removal", "Consolidated", "Burning"))

conservation <- data.frame(production_system = "conservation",
                           practice = c("Straw_mulch", "Conservation",
                                        "No_tillage", "Cover_crop_Reduced_tillage", 
                                        "Sorghum_residue", "Maize_redisdue", "Cover_crop",
                                        "High_vegetation_cover", "Fast_decomposing_legume_litter",
                                        "Litter"))

organic <- data.frame(production_system = "Organic", 
                      practice = c("Organic", "Diversified"))

transgenic <- data.frame(production_system = "Transgenic", 
                         practice = c("Bt", "GM"))

ipm <- data.frame(production_system = "ipm", 
                  practice = c("Biocontrol"))

mixed <- data.frame(production_system = "mixed", 
                    practice = c("Policulture","Intercrop", "Rotation"))

unclassified <- data.frame(production_system = "unclassified", 
                           practice = c("Conservation_Polyculture", 
                                        "Conservation_Rotation", 
                                        "Non_consolidated", "Crayfish_coculture"))

agricultural_categories <- rbind(conventional, conservation, organic, transgenic,
                            ipm, mixed, unclassified)

          # b. Add column in data_extraction_spreadsheet of the broad agricultural
          # production systems according to the production_systems data frame just 
          # created 


d$agricultural_system <- ""


for (i in (1:558)){
  #browser()
  for (j in (1:32)){
    if (d$Production_system[i] == agricultural_categories$practice[j]){
      d$agricultural_system[i] <- agricultural_categories$production_system[j]
    }}}


# 2. Rename the existing columns the following way:

           # a. Practice -> Practice detail


colnames(d)[28] <- "Practice_detail"

           # b. Production system -> Practice

colnames(d)[26] <- "Practice"



# 3. Reorder columns 

library(dplyr)

d <- relocate(d, agricultural_system, Practice, Practice_detail, .after = Landuse )


# When I extracted the data I did not classify each Biodiversity measure into 
# the broader biodiversity measure categories (e.g., dehydrogenase is classified
# as enzymatic activity. I am going to create a new column with the broad
# biodiversity measure categories.

# a. Create data frame with the biodiversity measure categories and specific 
# biodiversity measures

unique(d$Biodiversity_measure)

diversity <- data.frame(biodiversity_measure = "diversity", 
                           practice = c("Abundance", "Species_richness",
                                        "Relative_species_richness", "Quadrat_density", 
                                        "Mean_abundance", "Density", "Diversity",
                                        "Simpson", "Chao-1", "ACE", "Functional_diversity",
                                        "Population_levels", "Similarity", "Count",
                                        "Population_composition", "Community_composition",
                                        "Population", "Community", "Density_ratio"))



biomass <- data.frame(biodiversity_measure = "biomass",
                      practice = c("microbial biomass carbon (MBC)",
                                        "microbial biomass nitrogen (MBN)", "", 
                                        "Biomass_ratio", "Biomass",
                                        "microbial biomass phosphorus (MBP)"))

enzymatic_activity <- data.frame(biodiversity_measure = "Enzymatic_activity", 
                                 practice = c("Microbial_activity", "Enzymatic_activity",
                                   "Potential N mineralization", "microbial quotient (MQ)",
                                   "Nitrification", "Nitrate reductase", 
                                   "Alkaline phosphatase", "Acid phosphatase",
                                   "nitrate\nreductase and urease", "urease",
                                   "dehydrogenase activity", "Enzymatic_activity_respiration",
                                   "Metabolic_activity"))

survival <- data.frame(biodiversity_measure = "survival", 
                       practice = c("Survival", "Mortality", "Egg_viability",
                                      "Survial_overwinter"))

reproduction <- data.frame(biodiversity_measure = "reproduction", 
                           practice = c("Spore_number", "Reproduction", "Seeds",
                                    "Fecundity", "Reproductive_fitness"))

efficiency <- data.frame(biodiversity_measure = "efficiency",
                         practice = c("Incidence", "Weight", "Adult_emergance",
                         "Emergence", "Parasitism", "Infestation_rate",
                         "WWeed_control_effieciency (>8 Mg/ha)",
                         "Weed_control_effieciency (<8Mg/ha)"))


development <- data.frame(biodiversity_measure = "development",
                          practice = c("Development", "Development time", "Hifa_length",
                         "Root_colonisation", "Mycorrhiza_hifa_length"))


unclassified <- data.frame(biodiversity_measure = "unclassified",
                           practice = c("Food_consumption", "Population_dynamics",
                           "Pitfall_trap_rate", "Effect", "Pest_indicators",
                           "Predator_prey_ratio"))


biodiverity_categories <- rbind(diversity, biomass, enzymatic_activity, 
                                   survival, reproduction, efficiency, development,
                                   unclassified)


      # b. Add column in data_extraction_spreadsheet of the biodiversity categories
      # according to the production_systems data frame just created 

d$biodiveristy_metric_category <- ""


for (i in (1:1855)){
  #browser()
  for (j in (1:66)){
    if (d$Biodiversity_measure[i] == biodiverity_categories$practice[j]){
      d$biodiveristy_metric_category[i] <- biodiverity_categories$biodiversity_measure[j]
    }}}

unique(d$biodiveristy_metric_category) # Check it worked 


# 3. Reorder columns 

library(dplyr)

d <- relocate(d, biodiveristy_metric_category,.before = Biodiversity_measure )

colnames(d)


# I checked wrong entries and corrected them

which(d$Crop == "Maize_Legume")

d[(27:32), 15] <- "Cereals_grains"
d[(27:32), 16] <- "Maize"
d[(27:32), 27] <- "mixed"
d[(27:32), 28] <- "intercrop"
d[(27:32), 29] <- "intercrop"
d[(27:32), 31] <- "legume"


# Save the data set in processed data folder

library(writexl)

write.csv(d, "Data/01.Processed_Data/03.Curated_spreadsheet/Csv_Crops_Quantitative_spreadsheet.csv")
write_xlsx(d, "Data/01.Processed_Data/03.Curated_spreadsheet/Excel_Crops_Quantitative_spreadsheet.xlsx")

########################################## Qualitative data ##########################################----

rm(list=ls())

d <- read.csv2("Data/00.Raw_Data/03.Spreadsheet_curation/CSV_v3_Qualitative_Dataset.csv")
names(d)
tail(d$Paper_number)
str(d)

d <- d[,-(34:46)]  # Drop blank columns at the end 
d <- d[-c(441:616),] # Drop blank rows at the end

# 1. Make sure all names are well written

names(d)

    # Synthesis type

unique(d$Synthesis_type)
d$Synthesis_type[d$Synthesis_type == "Revew"]<-"Review"
d$Synthesis_type[d$Synthesis_type == "Revrew"]<-"Review"

    # Commodity

unique(d$Commodity)
d$Commodity[d$Commodity == "vegetable"]<-"Vegetable"

    # Crop

unique(d$Crop)

crop <- as.data.frame(unique(d$Crop))
d$Crop[d$Crop == "Gm_Potato"]<-"GM_Potato"
d$Crop[d$Crop == "Soy"]<-"Soybean"
d$Crop[d$Crop == "Oilseed"]<-"Rape_seed"
d$Crop[d$Crop == "Cotton_Sun.Hemp"]<-"Cotton"


# because there are many rape variants I am using grep

rape <- grepl("rape", ignore.case =  TRUE, d$Crop ) # detect lines that contain rape
unique(d$Crop[rape])# and throw them out

d$Crop[d$Crop == "Gr_Oilseed_rape"]<-"Gr_Rape_seed"
d$Crop[d$Crop == "GM_Oilseed_rape"]<-"GM_Rape_seed"

    # Kingdom
    
names(d)
king <- as.data.frame(unique(d$Kingdom))
unique(d$Kingdom)

d$Kingdom[d$Kingdom == "Bactera"]<- "Bacteria"
d$Kingdom[d$Kingdom == "Bacteria "]<- "Bacteria"
d$Kingdom[d$Kingdom == "Microbe"]<- "Microbes"
d$Kingdom[d$Kingdom == "Platae"]<- "Plant"
d$Kingdom[d$Kingdom == "Plantae"]<- "Plant"
which(d$Kingdom == "")
d$Kingdom[295] <- "Plant"

    # Control

control <- as.data.frame(unique(d$Control))
d$Control[d$Control == "Burning"]<- "Burn"

    # Production system

ps <- as.data.frame(unique(d$Production_system))            
d$Production_system[d$Production_system == "Biological_control"]<- "Biocontrol"
d$Production_system[d$Production_system == "Burning"]<- "Burn"
d$Production_system[d$Production_system == "Polyculture"]<- "Policulture"
d$Production_system[d$Production_system == "Fast_decomposing_legume"]<- "Fast_decomposing_legume_litter"

    # Cover crop

names(d)
unique(d$Cover_crop)

cover <- as.data.frame(unique(d$Cover_crop))
d$Cover_crop[d$Cover_crop == "Rye"]<- "Ryegrass"
which(d$Cover_crop == "")
d$Cover_crop[d$Cover_crop == ""]<- "NA"

    # Bt_type

bt <- as.data.frame(unique(d$Bt_Type))

    # Biodiversity_measure

bio <- as.data.frame(unique(d$Biodiversity_measure))
unique(d$Biodiversity_measure)

d$Biodiversity_measure[d$Biodiversity_measure == "Abuncande"]<- "Abundance"
d$Biodiversity_measure[d$Biodiversity_measure == "Abundance "]<- "Abundance"
d$Biodiversity_measure[d$Biodiversity_measure == "Abundane"]<- "Abundance"
d$Biodiversity_measure[d$Biodiversity_measure == "Abundannce"]<- "Abundance"
d$Biodiversity_measure[d$Biodiversity_measure == "Abundnace"]<- "Abundance"
d$Biodiversity_measure[d$Biodiversity_measure == "Bbiomass"]<- "Biomass"
d$Biodiversity_measure[d$Biodiversity_measure == "Catabolic:diversity"]<- "Catabolic_diversity"
d$Biodiversity_measure[d$Biodiversity_measure == "Enzimatic_activity"]<- "Enzymatic_activity"
d$Biodiversity_measure[d$Biodiversity_measure == "Policulture"]<- "Pesticide"
d$Biodiversity_measure[d$Biodiversity_measure == "Richhness"]<- "Species_richness"
d$Biodiversity_measure[d$Biodiversity_measure == "Richness"]<- "Species_richness"
d$Biodiversity_measure[d$Biodiversity_measure == "Bacterial_biomass_carbon"]<- "microbial biomass\ncarbon (MBC)"
d$Biodiversity_measure[d$Biodiversity_measure == "Growth"]<- "Population_growth"


which(is.na(d$Biodiversity_measure))
d$Biodiversity_measure[30] <- "Effect"
d$Biodiversity_measure[32] <- "Effect"

for(i in 1:nrow(d)){                            # Complete missing biodiversity measure
  if(d$Paper_ID[i] == "Dinardo-Miranda.L"){
    d$Biodiversity_measure[i] <- "Population"
  }
}

d[278:281, 30] <- "Abundance"

d[c(356,376), 30] <- "Effect"

# When I extracted the data I did not classify each practice into the broader 
# agricultural production system categories (e.g., no-tillage is classified as 
# conservation agriculture). Therefore, the columns 'production system' and practice
# are almost the same. I am going to create a new column with the broad production 
# system categories, and rename the existing columns the following way:
#
#   a. Practice -> Practice detail
#   b. Production system -> Practice

# 1. Create column of broad agricultural production system categories according to
#    the document NHM > Writing > Agricultural practices

# a. Create data frame with the broad categories and specific practices 

conventional <- data.frame(production_system = "conventional", 
                           practice = c("Conventional", "Intensified",
                                        "Monoculture", "Mechanical", "Staw_romoval",
                                        "Burn", "High_intensity",
                                        "Tillage", "Glyphosate"))


conservation <- data.frame(production_system = "conservation",
                           practice = c("Straw_mulch", "Crop_residues",
                                        "High_vegetation_cover", "Straw_cover", 
                                        "Residue_cover", "Fast_decomposing_legume",
                                        "Fast_decomposing_legume_litter", 
                                        "Cover_crop_Reduced_tillage",
                                        "Sugarcane_straw", "Maize_stover"))


organic <- data.frame(production_system = "Organic", 
                      practice = c("Organic", "Diversified"))

transgenic <- data.frame(production_system = "Transgenic", 
                         practice = c("Bt", "GM", "Gr"))

ipm <- data.frame(production_system = "ipm", 
                  practice = c("Biocontrol"))

mixed <- data.frame(production_system = "mixed", 
                    practice = c("Policulture","Intercrop", "Rotation", "Stripped"))

unclassified <- data.frame(production_system = "unclassified", 
                           practice = c("Conservation_Rotation", 
                                        "Understory_complexity", 
                                        "Smallholding", "Empty_fruit_benches",
                                        "Crayfish_coculture", "Wash_liquor"))

agricultural_categories <- rbind(conventional, conservation, organic, transgenic,
                                 ipm, mixed, unclassified)

        # b. Add column in data_extraction_spreadsheet of the broad agricultural
        # production systems according to the production_systems data frame just 
        # created 


d$agricultural_system <- ""


for (i in (1:440)){
  #browser()
  for (j in (1:35)){
    if (d$Production_system[i] == agricultural_categories$practice[j]){
      d$agricultural_system[i] <- agricultural_categories$production_system[j]
    }}}


# 2. Rename the existing columns the following way:

        # a. Practice -> Practice detail


colnames(d)[25] <- "Practice_detail"

        # b. Production system -> Practice

colnames(d)[23] <- "Practice"



# 3. Reorder columns 

library(dplyr)

d <- relocate(d, agricultural_system, Practice, Practice_detail, .after = Landuse )

# When I extracted the data I did not classify each Biodiversity measure into 
# the broader biodiversity measure categories (e.g., dehydrogenase is classified
# as enzymatic activity. I am going to create a new column with the broad
# biodiversity measure categories.

# a. Create data frame with the biodiversity measure categories and specific 
# biodiversity measures

unique(d$Biodiversity_measure)

diversity <- data.frame(biodiversity_measure = "diversity", 
                        practice = c("Density", "Diversity",
                                     "Abundance", "Species_richness", 
                                     "Catabolic_diversity", "Floristic_diversity",
                                     "Biodiversity", "Population_levels", "Population",
                                     "Initial_density", "Intermediate_density", 
                                     "Final_density", "Second_generation_abundance", 
                                     "Community_composition", "Community_structure",
                                     "Fauna", "Microbial_counts (CFU)"))



biomass <- data.frame(biodiversity_measure = "biomass",
                      practice = c("Biomass", 
                                   "Bacterial_biomass_carbon",
                                   "microbial biomass\ncarbon (MBC)"))

enzymatic_activity <- data.frame(biodiversity_measure = "Enzymatic_activity", 
                                 practice = c("Activity", "microbial_activity",
                                              "Enzymatic_activity", "Microbial_activity" ))

survival <- data.frame(biodiversity_measure = "survival", 
                       practice = c("Survival", "Mortality"))

reproduction <- data.frame(biodiversity_measure = "reproduction", 
                           practice = c("Spore_number", "Seed_rain", "Seed_bank",
                                        "Fecundity", "Population_growth", 
                                        "Seed_set", "Reproductive_rate"))

efficiency <- data.frame(biodiversity_measure = "efficiency",
                         practice = c("Catches", "Germination", 
                                      "Flowering", "Weight"))


development <- data.frame(biodiversity_measure = "development",
                           practice = c("Hifa_length", "Micorrhyzal_colonisation_percentage",
                                        "Root_colonisation", "Mycorrhizal_colonisation", 
                                        "Development", "Parasitism"))


unclassified <- data.frame(biodiversity_measure = "unclassified",
                         practice = c("Effect", "Trophic_conection", "Biology",
                                      "Canopy_hight", "Root_staining", 
                                      "Consumption rate_Body mass_body mass_Larval survival",
                                      "body weight_development_mortality_larval behaviour",
                                      "Abundance_biomass", "Development_health", 
                                      "Immigration_rate", "pesticide", "Size", 
                                      "Longevity", "Pesticide"))

                                      
biodiverity_categories <- rbind(diversity, biomass, enzymatic_activity, 
                                survival, reproduction, efficiency, development,
                                unclassified)


# b. Add column in data_extraction_spreadsheet of the biodiversity categories
# according to the production_systems data frame just created 

d$biodiveristy_metric_category <- ""


for (i in (1:440)){
  #browser()
  for (j in (1:57)){
    if (d$Biodiversity_measure[i] == biodiverity_categories$practice[j]){
      d$biodiveristy_metric_category[i] <- biodiverity_categories$biodiversity_measure[j]
    }}}

unique(d$biodiveristy_metric_category) # Check it worked 



# 3. Reorder columns 

library(dplyr)

d <- relocate(d, biodiveristy_metric_category,.before = Biodiversity_measure )

colnames(d)

# Save spread sheets 

write.csv(d, "Data/01.Processed_Data/03.Curated_spreadsheet/Csv_Crops_Qualitative_spreadsheet.csv")
write_xlsx(d, "Data/01.Processed_Data/03.Curated_spreadsheet/Excel_Crops_Qualitative_spreadsheet.xlsx", 
           col_names = TRUE, format_headers = TRUE, use_zip64 = FALSE )

