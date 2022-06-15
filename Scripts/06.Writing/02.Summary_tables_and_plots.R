# In this script I am going to make tables and plots of the results for the 
# the results section of the paper "Meta-meta-analysis". For each category, I 
# first prepare the data and then I plot it.

rm(list=ls())

# Load packages

library(here)
library(tidyverse)
library(ggplot2)
library(officer)

# Blmer model----

  ## 1. Prepare data----

blmer <- readRDS(here("Outputs/08.Results", "blmer_model.rds")) # Load blmer model

blmer_coefficients <- blmer %>%  summary() %>% .$coefficients %>%  # Extract coefficients
  round(digits = 2) %>%  as.data.frame()

# Adjust reference level (intercept = conventional) to 0. That way I will be able 
# to report absolute LRR and percentage change relative to conventional. To do so,
# I have to add the intercept (conventional) value ( = 0.02) to each level.

names(blmer_coefficients) <- c( "Original_LRR", "SE", "t") # Change names to make
                                                           # code easier

blmer_coefficients$Adjusted_LRR <- ""  # New column where I will store adjusted
                                       # values after conventional (= 0.02) has 
                                       # been set to 0

blmer_coefficients$Adjusted_LRR[1] <- 0 # Adjust conventional to 0

for (i in 1:length((blmer_coefficients$Original_LRR))) { # Adjust other levels
  ifelse(i > 0, 
         blmer_coefficients$Adjusted_LRR[i] <- blmer_coefficients$Original_LRR[i] - 0.04, 
         blmer_coefficients$Adjusted_LRR[i] <- blmer_coefficients$Original_LRR[i] - 0.04)
}


# Obtain other coefficients: CI, percentage_change

blmer_coefficients$Adjusted_LRR <- as.numeric(blmer_coefficients$Adjusted_LRR)

blmer_coefficients <- blmer_coefficients %>% 
  mutate(LCI = Adjusted_LRR - (1.96 * SE),
         UCI = Adjusted_LRR + (1.96 * SE),
         percentage_change = 100 * (exp(Adjusted_LRR) - 1)) %>% 
  round(digits = 2) %>% 
  mutate(CI = paste( LCI, "to", UCI))


# I will make a word table using the following steps: 
#   1. Create a table or data.frame in R.
#   2. Write this table to a comma-separated .txt file using write.table().
#   3. Copy and paste the content of the .txt file into Word.
#   4. In Word,
#       a. select the text you just pasted from the .txt file
#       b. go to Table and Convert text to table


write.table(blmer_coefficients, "Outputs/08.Results/blmer_coefficients.txt", 
            sep = ",")


  ## 2. Plot----


# Robust model ---- 

  ## 1.Prepare data----

robust <- readRDS(here("Outputs/08.Results", "robust_model.rds")) # Load model


robust_coefficients <- robust %>%  summary() %>% .$coefficients %>% # Extract coefficients
  round(digits = 2) %>% as.data.frame()

names(robust_coefficients) <- c( "Original_LRR", "SE", "t") # Change names to make
                                                            # code easier

robust_coefficients$Adjusted_LRR <- ""  # New column where I will store adjusted
                                        # values after conventional (= 0.02) has 
                                        # been set to 0

robust_coefficients$Adjusted_LRR[1] <- 0 # Adjust conventional to 0

for (i in 1:length((robust_coefficients$Original_LRR))) { # Adjust other levels
  ifelse(i > 0, 
         robust_coefficients$Adjusted_LRR[i] <- robust_coefficients$Original_LRR[i] - 0.02, 
         robust_coefficients$Adjusted_LRR[i] <- robust_coefficients$Original_LRR[i] - 0.02)
}


# Obtain other coefficients: CI, percentage_change and percentage change CI

robust_coefficients$Adjusted_LRR <- as.numeric(robust_coefficients$Adjusted_LRR)

robust_coefficients <- robust_coefficients %>% 
  mutate(LCI = Adjusted_LRR - (1.96 * SE),
         UCI = Adjusted_LRR + (1.96 * SE),
         percentage_change = 100 * (exp(Adjusted_LRR) - 1),
         percentage_LCI = 100 * (exp(LCI) - 1),
         percentage_UCI = 100*(exp(UCI) - 1)) %>% 
  round(digits = 2) %>% 
  mutate(CI = paste( LCI, "to", UCI))

# Add significance

for( i in 1:nrow(robust_coefficients)) {

if ( robust_coefficients$t[i] >  -2 & robust_coefficients$t[i] < 2 ) {
  
  robust_coefficients$Significance[i] <- "Not significant"
  
  } else {
    
  robust_coefficients$Significance[i] <- "Significant"
  }
}


# I will make a word table using the following steps: 
#   1. Create a table or data.frame in R.
#   2. Write this table to a comma-separated .txt file using write.table().
#   3. Copy and paste the content of the .txt file into Word.
#   4. In Word,
#       a. select the text you just pasted from the .txt file
#       b. go to Table and Convert text to table

write.table(robust_coefficients, "Outputs/08.Results/robust_coefficients.txt",
            sep = ",")


# Continue preparing data

robust_coefficients <- robust_coefficients[-1,]  # Remove the intercept row 

robust_coefficients$Treatment <- c ("Conservation",      # Add column with treatment names
                                    "Disturbed forest", 
                                    "Fallow", 
                                    "Mixed", 
                                    "Non Bt", 
                                    "Primary vegetation",
                                    "Sustainable", 
                                    "Traditional", 
                                    "Transgenic")

# None of the decreases are significant, according to the 
# t-value. So I am going to adjust the upper confidence intervals for
# transgenic and mixed to 0 so it reflects the non significance

robust_coefficients$Treatment

robust_coefficients$UCI[robust_coefficients$Treatment == "Mixed"] <- 0
robust_coefficients$UCI[robust_coefficients$Treatment == "Transgenic"] <- 0
robust_coefficients$percentage_UCI[robust_coefficients$Treatment == "Mixed"] <- 0
robust_coefficients$percentage_UCI[robust_coefficients$Treatment == "Transgenic"] <- 0

  
  ## 2.Plot----

    ## LRR plot

cbPalette <- c("#D55E00", "#009E73") # Color blind palette

bio_LRR <- robust_coefficients %>% 
  arrange(Adjusted_LRR)  %>% 
  mutate(Treatment = factor( Treatment, levels = Treatment)) %>% 
  ggplot( aes(x = Treatment, 
              y = Adjusted_LRR, 
              ymin = LCI, 
              ymax = UCI,
              color = Significance)) +
  geom_pointrange(size = 1) + 
  geom_hline(yintercept = 0, lty = 2) +  # add a dotted line at x=1 after flip
  coord_flip() +  # flip coordinates (puts labels on y axis)
  labs(x = "Treatment", 
       y = "Mean LRR (95% CI)") +
  theme_bw() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text = element_text(size = 18),
        axis.title = element_text(size = 20, face = "bold"),
        title = element_text(size = 25, face = "bold"),
        legend.text = element_text(size = rel(1.5))) +
  scale_colour_manual(values=cbPalette)

bio_LRR

ggsave(bio_LRR, filename = "bio_LRR.jpeg" ,device = "jpeg", width = 25, height = 16, unit = "cm")


  ## Percentage change plot

bio_percentage <-robust_coefficients %>% 
  arrange(percentage_change)  %>% 
  mutate(Treatment = factor( Treatment, levels = Treatment)) %>% 
  ggplot( aes(x = Treatment, 
              y = percentage_change, 
              ymin = percentage_LCI, 
              ymax = percentage_UCI,
              color = Significance)) +
  geom_pointrange(size = 1) + 
  geom_hline(yintercept = 0, lty = 2) +  # add a dotted line at x=1 after flip
  coord_flip() +  # flip coordinates (puts labels on y axis)
  labs(x = "Treatment", 
       y = "Mean percentage change (95% CI)") +
  theme_bw() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text = element_text(size = 18),
        axis.title = element_text(size = 20, face = "bold"),
        title = element_text(size = 25, face = "bold"),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
        legend.text = element_text(size = rel(1.5))) +
  scale_colour_manual(values=cbPalette)

bio_percentage

ggsave(bio_percentage, filename = "bio_percentage.jpeg" ,device = "jpeg", width = 25, height = 16, unit = "cm")


# Arthropods model ----

  ## 1. Prepare data ----

arthropoda_model <- readRDS(here("Outputs/08.Results", "arthropoda_model.rds"))

arthropod_coef <- arthropoda_model %>%  summary() %>% .$coefficients %>%  # Get coefficients
  round(digits = 2) %>%  as.data.frame()

names(arthropod_coef) <- c("Original_LRR", "SE", "t") # Change column names

arthropod_coef$Adjusted_LRR <- ""  # New column where I will store adjusted
                                   # values after conventional (= 0.04) has 
                                   # been set to 0

arthropod_coef$Adjusted_LRR[1] <- 0 # Adjust conventional to 0

for (i in 1:length((arthropod_coef$Original_LRR))) { # Adjust other levels
  ifelse(i > 0, 
         arthropod_coef$Adjusted_LRR[i] <- arthropod_coef$Original_LRR[i] - 0.04, 
         arthropod_coef$Adjusted_LRR[i] <- arthropod_coef$Original_LRR[i] - 0.04)
}

# Obtain other coefficients: CI, percentage_change

arthropod_coef$Adjusted_LRR <- as.numeric(arthropod_coef$Adjusted_LRR)

arthropod_coef <- arthropod_coef %>% 
  mutate(LCI = Adjusted_LRR - (1.96 * SE),
         UCI = Adjusted_LRR + (1.96 * SE),
         percentage_change = 100 * (exp(Adjusted_LRR) - 1),
         percentage_LCI = 100 * (exp(LCI) - 1),
         percentage_UCI = 100*(exp(UCI) - 1)) %>% 
  round(digits = 2) %>% 
  mutate(CI = paste( LCI, "to", UCI))

table(arthropod_)


# Add significance 

for( i in 1:nrow(arthropod_coef)) {
  
  if ( arthropod_coef$t[i] >  -2 & arthropod_coef$t[i] < 2 ) {
    
    arthropod_coef$Significance[i] <- "Not significant"
    
  } else {
    
    arthropod_coef$Significance[i] <- "Significant"
  }
}


arthropod_coef <- arthropod_coef[-1,] # Remove the intercept row 

# Add column with treatment names

arthropod_coef$Treatment <- c ("Conservation", "Mixed", "Primary vegetation",
                               "Sustainable", "Traditional", "Transgenic")

# According to the t value, transgenic is not significant. So I am going to adjust
# the upper confidence interval to 0 so it reflects the non significance

arthropod_coef$UCI[arthropod_coef$Treatment == "Transgenic"] <- 0
arthropod_coef$percentage_UCI[arthropod_coef$Treatment == "Transgenic"] <- 0


  ## 2.Plot ----

    ## LRR plot

arthropod_plot <- arthropod_coef %>% 
  arrange(Adjusted_LRR)  %>% 
  mutate(Treatment = factor( Treatment, levels = Treatment)) %>% 
  ggplot( aes(x = Treatment, 
              y = Adjusted_LRR, 
              ymin = LCI, 
              ymax = UCI,
              color = Significance)) +
  geom_pointrange(size = 1) + 
  geom_hline(yintercept = 0, lty = 2) +  # add a dotted line at x=1 after flip
  coord_flip() +  # flip coordinates (puts labels on y axis)
  labs(x = "Treatment", 
       y = "Mean LRR (95% CI)") +
  theme_bw() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text = element_text(size = 18),
        axis.title = element_text(size = 20, face = "bold"),
        title = element_text(size = 25, face = "bold"),
        legend.text = element_text(size = rel(1.5))) +
  scale_colour_manual(values=cbPalette)

arthropod_plot

ggsave(arthropod_plot, filename = "arthropod_LRR.jpeg" ,device = "jpeg", width = 25, height = 16, unit = "cm")


  ## Percentage change plot

arthropod_percentage <- arthropod_coef %>% 
  arrange(percentage_change)  %>% 
  mutate(Treatment = factor( Treatment, levels = Treatment)) %>% 
  ggplot( aes(x = Treatment, 
              y = percentage_change, 
              ymin = percentage_LCI, 
              ymax = percentage_UCI,
              color = Significance)) +
  geom_pointrange(size = 1) + 
  geom_hline(yintercept = 0, lty = 2) +  # add a dotted line at x=1 after flip
  coord_flip() +  # flip coordinates (puts labels on y axis)
  labs(x = "Treatment", 
       y = "Mean percentage change (95% CI)") +
  theme_bw() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text = element_text(size = 18),
        axis.title = element_text(size = 20, face = "bold"),
        title = element_text(size = 25, face = "bold"),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
        legend.text = element_text(size = rel(1.5))) +
  scale_colour_manual(values=cbPalette)

arthropod_percentage

ggsave(arthropod_percentage, filename = "arthropod_percentage.jpeg" ,device = "jpeg", width = 25, height = 16, unit = "cm")


# Vertebrates and weeds models ----

  ## 1. Prepare vertebrate data----

vertebrates <- readRDS(here("Outputs/08.Results", "Vertebrates_model.rds"))

vertebrates_coef <- vertebrates %>%  summary() %>% .$coefficients %>%  # Get coefficients
  round(digits = 2) %>%  as.data.frame()

names(vertebrates_coef) <- c("Original_LRR", "SE", "t") # Change colnames


# Obtain other coefficients: CI, percentage_change

vertebrates_coef$Original_LRR <- as.numeric(vertebrates_coef$Original_LRR)

vertebrates_coef <- vertebrates_coef %>% 
  mutate(LCI = Original_LRR - (1.96 * SE),
         UCI = Original_LRR + (1.96 * SE),
         percentage_change = 100 * (exp(Original_LRR) - 1),
         percentage_LCI = 100 * (exp(LCI) - 1),
         percentage_UCI = 100*(exp(UCI) - 1)) %>% 
  round(digits = 2) %>% 
  mutate(CI = paste( LCI, "to", UCI))


    ## 2. Prepare weeds data---- 

weed_model <- readRDS(here("Outputs/08.Results", "Weed_model.rds"))

weed_coef <- weed_model %>%  summary() %>% .$coefficients %>%  # Get coefficients
  round(digits = 2) %>%  as.data.frame()

names(weed_coef) <- c("Original_LRR", "SE", "t") # Change colnames


# Obtain other coefficients: CI, percentage_change

weed_coef$Original_LRR <- as.numeric(weed_coef$Original_LRR)

weed_coef <- weed_coef %>% 
  mutate(LCI = Original_LRR - (1.96 * SE),
         UCI = Original_LRR + (1.96 * SE),
         percentage_change = 100 * (exp(Original_LRR) - 1),
         percentage_LCI = 100 * (exp(LCI) - 1),
         percentage_UCI = 100*(exp(UCI) - 1)) %>% 
  round(digits = 2) %>% 
  mutate(CI = paste( LCI, "to", UCI))


    ## 3. Vertebrate and weeds plot ----

library(tidyverse)
library(ggplot2)

vertebrates_coef <- vertebrates_coef[-1,]
vertebrates_coef$Taxon <- "Vertebrates"
weed_coef <- weed_coef[-1,]
weed_coef$Taxon <- "Weeds"

taxa <- rbind(vertebrates_coef, weed_coef)
taxa$Treatment <- c("Primary vegetation", "Conservation")

cbPalette <- c("#0072B2", "#E69F00") # Color blind palette

taxa_plot <- taxa %>% 
  arrange(percentage_change)%>% 
  mutate(Treatment = factor( Treatment, levels = Treatment)) %>% 
  ggplot(aes(x = Treatment, 
             y = percentage_change, 
             ymin = percentage_LCI, 
             ymax = percentage_UCI,
             color = Taxon )) +
  geom_pointrange(size = 1) + 
  geom_hline(yintercept = 0, lty = 2) +  # add a dotted line at x=1 after flip
  coord_flip() +  # flip coordinates (puts labels on y axis)
  labs(x = "Treatment", 
       y = "Mean percentage change (95% CI)") +
  theme_bw() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text = element_text(size = 18),
        axis.title = element_text(size = 20, face = "bold"),
        title = element_text(size = 25, face = "bold"),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
        legend.text = element_text(size = rel(1.5))) +
  scale_colour_manual(values=cbPalette)

taxa_plot

ggsave(taxa_plot, filename = "vertebrate_weed_plot.jpeg" ,device = "jpeg", width = 25, height = 5, unit = "cm")



# Formation and protection of soils model----

# No need to plot, only table

soil_model <- readRDS(here("Outputs/08.Results", "soil_model.rds"))

soil_model <- soil_model %>%  summary() %>% .$coefficients %>%  # Get coefficients
  round(digits = 2) %>%  as.data.frame()

names(soil_model) <- c("Original_LRR", "SE", "t") # Change column names

arthropod_coef$Adjusted_LRR <- ""  # New column where I will store adjusted
                                   # values after conventional (= 0.04) has 
                                   # been set to 0

soil_model$Adjusted_LRR[1] <- 0 # Adjust conventional to 0

for (i in 1:length((soil_model$Original_LRR))) { # Adjust other levels
  ifelse(i > 0, 
         soil_model$Adjusted_LRR[i] <- soil_model$Original_LRR[i] - 0.03, 
         soil_model$Adjusted_LRR[i] <- soil_model$Original_LRR[i] - 0.03)
}

# Obtain other coefficients: CI, percentage_change

arthropod_coef$Adjusted_LRR <- as.numeric(arthropod_coef$Adjusted_LRR)


soil_model <- soil_model %>% 
  mutate(LCI = Adjusted_LRR - (1.96 * SE),
         UCI = Adjusted_LRR + (1.96 * SE),
         percentage_change = 100 * (exp(Adjusted_LRR) - 1),
         percentage_LCI = 100 * (exp(LCI) - 1),
         percentage_UCI = 100*(exp(UCI) - 1)) %>% 
  round(digits = 2) %>% 
  mutate(CI = paste( LCI, "to", UCI))



# Pest and plants functional group models---- 

  ## 1. Prepare plants data----

plant_model <- readRDS(here("Outputs/08.Results", "plant_model.rds"))

plant_coef <- plant_model %>%  summary() %>% .$coefficients %>%  # Get coefficients
  round(digits = 2) %>%  as.data.frame()

names(plant_coef) <- c("Original_LRR", "SE", "t") # Change column names


# Obtain other coefficients: CI, percentage_change

plant_coef <- plant_coef %>% 
  mutate(LCI = Original_LRR - (1.96 * SE),
         UCI = Original_LRR + (1.96 * SE),
         percentage_change = 100 * (exp(Original_LRR) - 1),
         percentage_LCI = 100 * (exp(LCI) - 1),
         percentage_UCI = 100*(exp(UCI) - 1)) %>% 
  round(digits = 2) %>% 
  mutate(CI = paste( LCI, "to", UCI))


  ## 2. Prepare pests data----

pest_model <- readRDS(here("Outputs/08.Results", "pest_model.rds"))

pest_coef <- pest_model %>%  summary() %>% .$coefficients %>%  # Get coefficients
  round(digits = 2) %>%  as.data.frame()

names(pest_coef) <- c("Original_LRR", "SE", "t") # Change colnames

pest_coef$Adjusted_LRR <- ""  # New column where I will store adjusted
                              # values after conventional (= 0.04) has 
                              # been set to 0

pest_coef$Adjusted_LRR[1] <- 0 # Adjust conventional to 0
pest_coef$Adjusted_LRR[2] <- -0.17 - 0.15

# Obtain other coefficients: CI, percentage_change

pest_coef$Adjusted_LRR <- as.numeric(pest_coef$Adjusted_LRR)

pest_coef <- pest_coef %>% 
  mutate(LCI = Adjusted_LRR - (1.96 * SE),
         UCI = Adjusted_LRR + (1.96 * SE),
         percentage_change = 100 * (exp(Adjusted_LRR) - 1),
         percentage_LCI = 100 * (exp(LCI) - 1),
         percentage_UCI = 100*(exp(UCI) - 1)) %>% 
  round(digits = 2) %>% 
  mutate(CI = paste( LCI, "to", UCI))

# The next part is for rbinding with plants

pest_coef <- pest_coef[,-1]
pest_coef <- relocate(pest_coef, Adjusted_LRR, .before = "SE")
names(pest_coef)[1] <- "Original_LRR"

func_group <- rbind(plant_coef, pest_coef) # Rbind with plant df

func_group <- func_group[-c(1,3),] # Remove intercept rows

func_group$Treatment <- c("Conservation", "Mixed")
func_group$`Functional group` <- c("Plant", "Pest")

  ## 3. Plants and pests plot----

cbPalette <- c("#56B4E9", "#009E73") # Color blind palette

func_group_plot <- func_group %>% 
  arrange(percentage_change)%>% 
  mutate(Treatment = factor( Treatment, levels = Treatment)) %>% 
  ggplot(aes(x = Treatment, 
             y = percentage_change, 
             ymin = percentage_LCI, 
             ymax = percentage_UCI,
             color = `Functional group` )) +
  geom_pointrange(size = 1) + 
  geom_hline(yintercept = 0, lty = 2) +  # add a dotted line at x=1 after flip
  coord_flip() +  # flip coordinates (puts labels on y axis)
  labs(X ="",
       y = "Mean percentage change (95% CI)") +
  theme_bw() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text = element_text(size = 18),
        axis.title = element_text(size = 20, face = "bold"),
        title = element_text(size = 25, face = "bold"),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
        axis.title.y =element_blank(), # I don't want axis label, it looks weird in the ppt
        legend.text = element_text(size = rel(1.5))) +
  scale_colour_manual(values=cbPalette)

func_group_plot

ggsave(func_group_plot, filename = "func_group_plot.jpeg" ,device = "jpeg", width = 25, height = 5, unit = "cm")


 