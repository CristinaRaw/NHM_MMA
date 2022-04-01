rm(list = ls())
library(readxl)
library(blme)

d <- read_excel("Datasets/07.Excel_Dataset_to_model_LRR_LONG.xlsx")

m <- blmer(LRR ~ agricultural_system + magpie_class + biodiveristy_metric_category + (1|Crop) + (1|ID), data = d)
summary(m)
