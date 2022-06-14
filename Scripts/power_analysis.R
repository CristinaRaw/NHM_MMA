install.packages("simr")
library(simr)
library(readxl)
library(here)
library(blmer)

head(simdata)

d <- read_excel(here("Datasets", "07.Excel_Dataset_to_model_LRR_LONG.xlsx"))

str(d)
d$Crop <- as.factor(d$Crop)
d$Treatment <- as.factor(d$Treatment)
d$magpie_class <- as.factor(d$magpie_class)
d$Weight <- as.numeric(d$Weight)
d$biodiveristy_metric_category <- as.factor(d$biodiveristy_metric_category)


m <- readRDS("Scripts/model.rds")

# Collapse organic and sustainable

d$Treatment[d$Treatment == "Organic"] <- "Sustainable"

# Include monoculture in conventional 

d$Treatment[d$Treatment == "Monoculture"] <- "Conventional"

# Subset agricultural systems with >= 10 observations

treatment_obs <- as.data.frame(table(d$Treatment))
colnames(treatment_obs) <- c("Treatment", "N_Observations")
treatment_obs <- treatment_obs[order(treatment_obs$N_Observations, decreasing = TRUE),]

treatment_obs <- subset(treatment_obs, treatment_obs$N_Observations >= 10)

d <- d[d$Treatment %in% treatment_obs$Treatment, ] robust <- readRDS("Scripts/robust_model.rds")


# Power

m4 <- blmer(LRR ~  Treatment + (1|ID) + (1|Crop), weights = Weight, data = d, control = lmerControl(optimizer ="Nelder_Mead"), na.action = "na.omit")

# Whats the power of the model and this data set to calculate these effect sizes

fixef(m4)

fixef(m4)["(Intercept)"] <- 0.04173663
fixef(m4)["TreatmentConservation"] <- 0.54616392
fixef(m4)["TreatmentDisturbed_forest"] <- 0.32826578
fixef(m4)["TreatmentFallow"] <- -0.06072185
fixef(m4)["Treatmentmixed"] <- -0.05609329
fixef(m4)["TreatmentNon_Bt"] <- -0.05712190
fixef(m4)["TreatmentPrimary_vegetation"] <- 0.28033277                  
fixef(m4)["TreatmentSustainable"] <- 0.56892964 
fixef(m4)["TreatmentTraditional"] <- 0.08847976                 
fixef(m4)["TreatmentTransgenic "] <- -0.02284525

powerSim(m4)

# Power curve 

pc <- powerCurve(m4)

print(pc)

# Extend the model 

extended_m <- extend(m4, within = "Treatment", n = 500)
summary(extended_m)

pc_extended <- powerCurve(extended_m, within = "Treatment")
pc_extended
plot(pc_extended)
