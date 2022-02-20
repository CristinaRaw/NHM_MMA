rm(list=ls())

# Textile production

crops_total <- read.csv("Data/00.Raw_Data/00.Scoping/Crops_and_livestock_products/Crops/FAOSTATcrops_primary_total_2019.csv")
unique(crops_total$Item)

textile_production <- subset(crops_total, crops_total$Item == "Agave fibres nes" | crops_total$Item == "Bastfibres, other"|
            crops_total$Item == "Cotton lint"| crops_total$Item == "Kapok fruit"| crops_total$Item == "Sorghum"|
            crops_total$Item == "Linseed"| crops_total$Item == "Fibre crops nes"| crops_total$Item == "Flax fibre and tow"|
            crops_total$Item == "Hemp tow waste"| crops_total$Item == "Jute"| crops_total$Item == "Manila fibre (abaca)"|
            crops_total$Item == "Sisal"| crops_total$Item == "Coir"| crops_total$Item == "Dates"|
            crops_total$Item == "Oil palm fruit"|crops_total$Item == "Pineapples"| crops_total$Item == "Ramie")

write.csv(textile_production, "Outputs/Textile/Textile_production.csv")

# Textile value

crops_total <- read.csv("Data/00.Raw_Data/00.Scoping/Value_agricultural_production/FAOSTAT_value_agricultural_products_total_2019.csv")

unique(crops_total$Item)

textile_value <- subset(crops_total, crops_total$Item == "Agave fibres nes" | crops_total$Item == "Bastfibres, other"|
                               crops_total$Item == "Cotton lint"| crops_total$Item == "Kapok fruit"| crops_total$Item == "Sorghum"|
                               crops_total$Item == "Linseed"| crops_total$Item == "Fibre crops nes"| crops_total$Item == "Flax fibre and tow"|
                               crops_total$Item == "Hemp tow waste"| crops_total$Item == "Jute"| crops_total$Item == "Manila fibre (abaca)"|
                               crops_total$Item == "Sisal"| crops_total$Item == "Coir"| crops_total$Item == "Dates"|
                               crops_total$Item == "Oil palm fruit"|crops_total$Item == "Pineapples"| crops_total$Item == "Ramie"|
                               crops_total$Item == "Silk-worm cocoons, reelable"|crops_total$Item == "Seed cotton"| crops_total$Item == "Hempseed")

write.csv(textile_value, "Outputs/Textile/Textile_value.csv")


# Make tables 

      # Textile production 

production <- textile_production[,c(8,11,12)]

library(tidyr)
production <- drop_na(production)
production <- production[order(-production$Value),]

write.table(production, "Outputs/Textile/Textile_production_2019.txt")

      # Textile value 

value <- textile_value[,c(8,11,12)]
value <- value[order(-value$Value),]

write.table(value, "Outputs/Textile/Textile_value_2019.txt")

unique(production$Unit)

tonnes <- subset(production,production$Unit == "tonnes")
ha <- subset(production,production$Unit == "ha")
gh <- subset(production,production$Unit == "hg/ha")

write.table(tonnes, "Outputs/Textile/Textile_tonnes_2019.txt")
write.table(ha, "Outputs/Textile/Textile_ha_2019.txt")
write.table(gh, "Outputs/Textile/Textile_hg_2019.txt")


# Slot the fashion crops among the top 15 food crops

rm(list=ls())

top_15_crops <- read.csv("Outputs/00.Crops/Top_15_crop_value.csv", row.names= 1)
top_15_crops <- top_15_crops[,-c(2,4)]
names(top_15_crops) <- c("Crops", "1000 Int. $")

colnames(top_15_crops$Crop) <- c(new_col1_name,new_col2_name,new_col3_name)

fashion_crops <- read.table("Outputs/Textile/Textile_value_2019.txt")
fashion_crops <- fashion_crops[,-2]
colnames(fashion_crops) <- c("Crops", "1000 Int. $")

merge <- rbind(top_15_crops, fashion_crops )

merge <- merge[order(-merge$`1000 Int. $`),]

write.table(merge, "Outputs/Textile/Top_15_and_textile.txt")






