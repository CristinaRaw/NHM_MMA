rm(list = ls())

# Christina Raw
# 4/2/22

# In this script I am going to clean the top 15 crop data extraction spreadsheet that I obtained by extracting the data of 
# the impact of different agricultural production systems on biodiversity. With clean I mean make sure that all the names
# are written the same, that the data is in the right format (numeric, character), and fix errors.

library(dplyr)
library(writexl)

########################################## Quantitative data ##########################################

# I am going to check the unique values for each column to make sure all the names are correct and fill out any cells that might
# need data

d <- read.csv2("Data/00.Raw_Data/03.Spreadsheet_curation/CSV_v3_Quantitative_Dataset.csv")
names(d)
tail(d$Paper_number)
str(d)

d <- d[,-(46:51)]  # Drop blank columns at the end 
d <- d[-c(591:616),] # Drop blank rows at the end

  
      # 1. Make sure all names are well written

names(d)

unique(d$Synthesis_type)
d$Synthesis_type[d$Synthesis_type == "Meta_Analysis"]<-"Meta-Analysis"

unique(d$Model)
d$Model[d$Model == "Mixed_effect"]<-"Fixed_effects"

unique(d$Commodity)
d$Commodity[d$Commodity == "Cereas"]<-"Cereals_grains"
d$Commodity[d$Commodity == "Cereals_grains "]<-"Cereals_grains"
d$Commodity[d$Commodity == "Cassava"]<-"Roots_tubers"

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

names(d)
king <- as.data.frame(unique(d$Kingdom))
unique(d$Kingdom)

d$Kingdom[d$Kingdom == "Animalia"]<- "Animal"
d$Kingdom[d$Kingdom == "Bacteria "]<- "Bacteria"
d$Kingdom[d$Kingdom == "Microbe "]<- "Microbes"
d$Kingdom[d$Kingdom == "Microbial"]<- "Microbes"
d$Kingdom[d$Kingdom == "Microbe"]<- "Microbes"

which(is.na(d$Kingdom))

which(d$Kingdom == "Actinomyceta")
if(d$Kingdom == "Actinomyceta") {d}

control <- as.data.frame(unique(d$Control))
which(is.na(d$Control))

ps <- as.data.frame(unique(d$Production_system))            
d$Production_system[d$Production_system == "Gm"]<- "GM"
d$Production_system[d$Production_system == "Poluyculture"]<- "Policulture"

unique(d$Landuse)

practice <- as.data.frame(unique(d$Practice))
d$Practice[d$Practice == "Gm"]<- "GM"
d$Practice[d$Practice == "Poluyculture"]<- "Policulture"
d$Practice[d$Practice == "Sraw_mulch"]<- "Straw_mulch"
d$Practice[d$Practice == "Staw_romoval"]<- "Straw_removal"

names(d)
unique(d$Cover_crop)

bt <- as.data.frame(unique(d$Bt_type))
d$Bt_type[d$Bt_type == "Cy1Ac"]<- "Cry1Ac"                           
d$Bt_type[d$Bt_type == "OC-1"]<- "OC1"
d$Bt_type[d$Bt_type == "OC1 "]<- "OC1"

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

# Save the data set in processed data folder

write.csv(d, "Data/01.Processed_Data/03.Curated_spreadsheet/Csv_Crops_Quantitative_spreadsheet.csv")
write_xlsx(d, "Data/01.Processed_Data/03.Curated_spreadsheet/Excel_Crops_Quantitative_spreadsheet.xlsx")

########################################## Quantitative data ##########################################

rm(list=ls())

d <- read.csv2("Data/00.Raw_Data/03.Spreadsheet_curation/CSV_v3_Qualitative_Dataset.csv")
names(d)
tail(d$Paper_number)
str(d)

d <- d[,-(34:46)]  # Drop blank columns at the end 
d <- d[-c(441:616),] # Drop blank rows at the end

# 1. Make sure all names are well written

names(d)

unique(d$Synthesis_type)
d$Synthesis_type[d$Synthesis_type == "Revew"]<-"Review"
d$Synthesis_type[d$Synthesis_type == "Revrew"]<-"Review"

unique(d$Commodity)
d$Commodity[d$Commodity == "vegetable"]<-"Vegetable"

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

control <- as.data.frame(unique(d$Control))
d$Control[d$Control == "Burning"]<- "Burn"


ps <- as.data.frame(unique(d$Production_system))            
d$Production_system[d$Production_system == "Biological_control"]<- "Biocontrol"
d$Production_system[d$Production_system == "Burning"]<- "Burn"
d$Production_system[d$Production_system == "Polyculture"]<- "Policulture"

names(d)
unique(d$Cover_crop)

cover <- as.data.frame(unique(d$Cover_crop))
d$Cover_crop[d$Cover_crop == "Rye"]<- "Ryegrass"
which(d$Cover_crop == "")
d$Cover_crop[d$Cover_crop == ""]<- "NA"


bt <- as.data.frame(unique(d$Bt_Type))

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

which(is.na(d$Biodiversity_measure))
d$Biodiversity_measure[30] <- "Effect"
d$Biodiversity_measure[32] <- "Effect"

write.csv(d, "Data/01.Processed_Data/03.Curated_spreadsheet/Csc_Crops_Qualitative_spreadsheet.csv")
write_xlsx(d, "Data/01.Processed_Data/03.Curated_spreadsheet/Excel_Crops_Qualitative_spreadsheet.xlsx", 
           col_names = TRUE, format_headers = TRUE, use_zip64 = FALSE )

