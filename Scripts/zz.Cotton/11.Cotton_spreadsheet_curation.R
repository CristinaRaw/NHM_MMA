# Christina Raw 4/2/22

# In this script I am going to clean the top cotton quantitative data extraction 
# spreadsheet that I obtained by extracting the data of # the impact of different 
# agricultural production systems on biodiversity. With clean I mean make sure that 
# all the names are written the same, that the data is in the right format 
# (numeric, character), and fix errors.

library(dplyr)
library(writexl)

# I am going to check the unique values for each column to make sure all the names are correct and fill out any cells that might
# need data

d <- read.csv2("Data/00.Raw_Data/03.Spreadsheet_curation/Cotton/CSV_Cotton_quantitative_data.csv")

names(d)
tail(d$Paper_number)
str(d)


# Synthesis type

unique(d$Synthesis_type)
d$Synthesis_type[d$Synthesis_type == "Meta_Analysis"]<-"Meta-Analysis"

# Commodity

unique(d$Commodity)

# Crop

unique(d$Crop)

d$Crop[d$Crop == "Bt_cotton"]<-"Bt_Cotton"
d$Crop[d$Crop == "Bt"]<-"Bt_Cotton"
d$Crop[d$Crop == "Non_Bt"]<-"Cotton"
d$Crop[d$Crop == "Non_crops"]<-"Non_crop"

# Kingdom

names(d)
king <- as.data.frame(unique(d$Kingdom))
unique(d$Kingdom)

d$Kingdom[d$Kingdom == "Rhyzobeial_microbes"]<- "Rizosphere_microbes"


# Production system

unique(d$Production_system)

d$Production_system[d$Production_system == "non_Bt"]<- "Non_Bt"
d$Production_system[d$Production_system == "conventional"]<- "Conventional"
d$Production_system[d$Production_system == "Non_crops"]<- "Non_crop"
d$Production_system[d$Production_system == "transgenic"]<- "Bt"
which(d$Production_system == "")

    # Fill empty rows of the "production system" column with the information of
    # the corresponding rows in the "practice" column

empty <- subset(d, d$Production_system == "")
bt <- empty$Production_system
d[c(1803:1855), 27] <- bt

unique(d$Production_system)

# Landuse

unique(d$Landuse)

# Practice

unique(d$Practice)

d$Practice[d$Practice == "Non-Bt"]<- "Non_Bt"
d$Practice[d$Practice == "Non_crops"]<- "Non_crop"


# Cover crop

names(d)
unique(d$Cover_crop)
which(d$Cover_crop == "")

# Intercrop 

unique(d$Intercrop)

# Fertilizer

unique(d$Fertiliser)
which(d$Fertiliser == "Organic")
d[1191:1244, 32] <- "y"


# Tillage 

unique(d$Tillage)

# PEsticide

unique(d$Pesticide)

# Herbicide

unique(d$Herbicide)

# Irrigation 

unique(d$Irrigation)

# Bt_type

unique(d$Bt_type)

bt <- as.data.frame(unique(d$Bt_type))
d$Bt_type[d$Bt_type == "Cry 1 Ac"]<- "Cry1Ac"                           
d$Bt_type[d$Bt_type == "Cry1Ac & Cry2Ab"]<- "Cry1Ac/Cry2Ab"
d$Bt_type[d$Bt_type == "Cry1Ac_CpTI"]<- "Cry1Ac/CpTI"
d$Bt_type[d$Bt_type == "Cry1AcBt"]<- "Cry1Ac"
d$Bt_type[d$Bt_type == "cryIAC"]<- "Cry1Ac"

which(d$Bt_type == "Non_Bt")
d$Bt_type[1804:1855,] <- is.na()

                                ############################## Me quede aqui cambiando las dos ultimas lineas en la hoja de excel

# Biodiversity measure

bio <- as.data.frame(unique(d$Biodiversity_measure))
d$Biodiversity_measure[d$Biodiversity_measure == "abundance"]<- "Abundance"
d$Biodiversity_measure[d$Biodiversity_measure == "counts"]<- "Abundance"
d$Biodiversity_measure[d$Biodiversity_measure == "bateria_number"]<- "Abundance"
d$Biodiversity_measure[d$Biodiversity_measure == "dehidrogenase"]<- "dehydrogenase"         
d$Biodiversity_measure[d$Biodiversity_measure == "Dehydrogenase"]<- "dehydrogenase"
d$Biodiversity_measure[d$Biodiversity_measure == "biomass_carbon"]<- "microbial_biomass_c"
d$Biodiversity_measure[d$Biodiversity_measure == "Population"]<- "population"

library(dplyr)

    # With the next step I will check that the taxonomy column has this information
    # before changing the values in the biodiversity measure column

population <- subset(d, d$Biodiversity_measure == "ammonia-oxidizing bacteria" |
                       d$Biodiversity_measure == "denitryfying bacteria" |
                       d$Biodiversity_measure == "azobacter number" |
                       d$Biodiversity_measure == "fungal_population"|
                       d$Biodiversity_measure == "actinomycetes_population"|
                       d$Biodiversity_measure == "azobacter number" |
                       d$Biodiversity_measure == "Fungi number") 

d$Biodiversity_measure[d$Biodiversity_measure == "ammonia-oxidizing bacteria"]<- "population"
d$Biodiversity_measure[d$Biodiversity_measure == "denitryfying bacteria"]<- "population"
d$Biodiversity_measure[d$Biodiversity_measure == "azobacter number"]<- "Abundance"
d$Biodiversity_measure[d$Biodiversity_measure == "fungal_population"]<- "population"
d$Biodiversity_measure[d$Biodiversity_measure == "actinomycetes_population"]<- "population"
d$Biodiversity_measure[d$Biodiversity_measure == "azobacter number"]<- "Abundance"
d$Biodiversity_measure[d$Biodiversity_measure == "Fungi number"]<- "Abundance"

which(d$Biodiversity_measure == "eubacteria")   # Changing biodiversity measure that says
d[1821:1837, 40] <- "Population"                # eubacteria for population

names(d)


# Drop columns that don't have any values

colnames(d)
unique(d$Tillage)
unique(d$Irrigation)
unique(d$p.value)
unique(d$Lower_CI)
unique(d$Upper_CI)

d <- d[,-c(46,47)]


# I'm going to check the class of columns and coerce the wrong ones into their right class

str(d)

d$Plot_1_size..m2. <- as.numeric(d$Plot_1_size..m2.)
d$Mean <- as.numeric(d$Mean)
d$Percentage_change <- as.numeric(d$Percentage_change)
d$p.value <- as.numeric(d$p.value)
d$SD <- as.numeric(d$SD)
d$SE <- as.numeric(d$SE)



# When I extracted the data I did not classify each practice into the broader 
# agricultural production system categories (e.g., no-tillage is classified as 
# conservation agriculture). Therefore, the columns 'production system' and practice
# are almost the same. I am going to create a new column with the broad production 
# system categories, and rename the existing columns the following way:
#
#   a. Practice -> Practice detail
#   b. Production system -> Practice

# 1.unique(d$Production_system) Create column of broad agricultural production system categories according to
#    the document NHM > Writing > Agricultural practices

      # a. Create data frame with the broad categories and specific practices 

unique(d$Practice)  # In the column "practice", change conventional for non_bt

for(i in 1:nrow(d)){
  if(d$Practice[i] == "Conventional"){
    d$Practice[i] <- "Non_Bt"
  }
}

conventional <- data.frame(production_system = "conventional", 
                           practice = c("Non_Bt"))

transgenic <- data.frame(production_system = "transgenic",
                           practice = c("Bt"))

non_crop <- data.frame(production_system = "non_crop", 
                  practice = c("Non_crop"))


agricultural_categories <- rbind(conventional, transgenic, non_crop)

# b. Add column in data_extraction_spreadsheet of the broad agricultural
# production systems according to the production_systems data frame just 
# created 


d$agricultural_system <- ""


for (i in (1:1855)){
  #browser()
  for (j in (1:3)){
    if (d$Production_system[i] == agricultural_categories$practice[j]){
      d$agricultural_system[i] <- agricultural_categories$production_system[j]
    }}}


# 2. Rename the existing columns the following way:

        # a. Practice -> Practice detail


colnames(d)[29] <- "Practice_detail"

        # b. Production system -> Practice

colnames(d)[27] <- "Practice"


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
                           practice = c("Density", "Abundance", "family_richness",
                                        "fungal_gene_copies", "shannon", "population"))

biomass <- data.frame(biodiversity_measure = "biomass",
                         practice = c("Microbial biomass", "microbial_biomass_c",
                                      "microbial_biomass_P", "microbial_biomasss_N"))

enzymatic <- data.frame(biodiversity_measure = "enzymatic activity", 
                       practice = c("phosphatase", "urease", "dehydrogenase",
                                    "phenol_oxidase", "protease", "Esterase",
                                    "Acid_phosphatase", "Alkalyne_phosphatase",
                                    "Phytase", "Nitrogenase", "respiration"))


biodiverity_categories <- rbind(diversity, biomass, enzymatic)

      # b. Add column in data_extraction_spreadsheet of the biodiversity categories
      # according to the production_systems data frame just created 

d$biodiveristy_metric_category <- ""


for (i in (1:1855)){
  #browser()
  for (j in (1:21)){
    if (d$Biodiversity_measure[i] == biodiverity_categories$practice[j]){
      d$biodiveristy_metric_category[i] <- biodiverity_categories$biodiversity_measure[j]
    }}}

unique(d$biodiveristy_metric_category) # Check it worked 


# 3. Reorder columns 

library(dplyr)

colnames(d)

d <- relocate(d, biodiveristy_metric_category, .before = Biodiversity_measure)

# Save the data set in processed data folder

library(writexl)

write.csv(d, "Data/01.Processed_Data/03.Curated_spreadsheet/Cotton/Csv_Cotton_Quantitative_spreadsheet.csv")
write_xlsx(d, "Data/01.Processed_Data/03.Curated_spreadsheet/Cotton/Excel_Cotton_Quantitative_spreadsheet.xlsx")
