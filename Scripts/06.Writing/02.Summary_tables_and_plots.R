# Load packages

library(here)
library(tidyverse)
library(ggplot2)
library(officer)

###################### PREPARE DATA ##################### ----

# Load blmer and robust models

rm(list=ls())

blmer <- readRDS(here("Outputs/08.Results", "blmer_model.rds"))
robust <- readRDS(here("Outputs/08.Results", "robust_model.rds"))

# Extract coefficients 

blmer_coefficients <- blmer %>%  summary() %>% .$coefficients %>% 
  round(digits = 2) %>%  as.data.frame()
robust_coefficients <- robust %>%  summary() %>% .$coefficients %>% 
  round(digits = 2) %>% as.data.frame()

# Adjust reference level (intercept = conventional) to 0. That way I will be able 
# to report absolute LRR and percentage change relative to conventional. To do so,
# I have to add the intercept (conventional) value ( = 0.02) to each level.

    # 1) Blmer model

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

#Change Adjusted_LRR class to numeric (idk why it came out as character after
# the for loop)

blmer_coefficients$Adjusted_LRR <- as.numeric(blmer_coefficients$Adjusted_LRR)

blmer_coefficients <- blmer_coefficients %>% 
  mutate(LCI = Adjusted_LRR - (1.96 * SE),
         UCI = Adjusted_LRR + (1.96 * SE),
         percentage_change = 100 * (exp(Adjusted_LRR) - 1)) %>% 
  round(digits = 2) %>% 
  mutate(CI = paste( LCI, "to", UCI))


    # 2) Robust model 

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

  #Change Adjusted_LRR class to numeric (idk why it came out as character after
  # the for loop)

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


write.table(blmer_coefficients, "Outputs/08.Results/blmer_coefficients.txt", 
            sep = ",")
write.table(robust_coefficients, "Outputs/08.Results/robust_coefficients.txt",
            sep = ",")

#################### Plot ###############----

# All data ----

row.names(robust_coefficients)

  # Remove the intercept row 

robust_coefficients <- robust_coefficients[-1,]

  # Add column with treatment names

robust_coefficients$Treatment <- c ("Conservation", "Disturbed forest", 
                               "Fallow", "Mixed", "Non Bt", "Primary vegetation",
                               "Sustainable", "Traditional", "Transgenic")

  
# None of the decreases are significant, according to the 
# t-value. So I am going to adjust the upper confindence intervals for
# transgenic and mixed to 0 so it reflects the non significance

robust_coefficients$Treatment

robust_coefficients$UCI[robust_coefficients$Treatment == "Mixed"] <- 0
robust_coefficients$UCI[robust_coefficients$Treatment == "Transgenic"] <- 0
robust_coefficients$percentage_UCI[robust_coefficients$Treatment == "Mixed"] <- 0
robust_coefficients$percentage_UCI[robust_coefficients$Treatment == "Transgenic"] <- 0



  # Plot LRR

cbPalette <- c("#D55E00", "#009E73")

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


  # Plot percentage 

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


# Arthropods----

arthropoda_model <- readRDS(here("Outputs/08.Results", "arthropoda_model.rds"))

arthropod_coef <- arthropoda_model %>%  summary() %>% .$coefficients %>%  # Get coefficients
  round(digits = 2) %>%  as.data.frame()

names(arthropod_coef) <- c("Original_LRR", "SE", "t") # Change colnames

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

#Change Adjusted_LRR class to numeric (idk why it came out as character after
# the for loop)

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


# Remove the intercept row 

arthropod_coef <- arthropod_coef[-1,]

# Add column with treatment names

arthropod_coef$Treatment <- c ("Conservation", "Mixed", "Primary vegetation",
                               "Sustainable", "Traditional", "Transgenic")

# According to the t value, transgenic is not significant. So I am going to adjust
# the upper confidence interval to 0 so it reflects the non significance

arthropod_coef$UCI[arthropod_coef$Treatment == "Transgenic"] <- 0
arthropod_coef$percentage_UCI[arthropod_coef$Treatment == "Transgenic"] <- 0


# Plot LRR

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


# Plot percentage 

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


# Vertebrates ----
# Not much point in plotting vertebrates and weeds as they only have results for
# one treatment. However,  I will make the tables to get percentage

vertebrates <- readRDS(here("Outputs/08.Results", "Vertebrates_model.rds"))

vertebrates_coef <- vertebrates %>%  summary() %>% .$coefficients %>%  # Get coefficients
  round(digits = 2) %>%  as.data.frame()

names(vertebrates_coef) <- c("Original_LRR", "SE", "t") # Change colnames


# Obtain other coefficients: CI, percentage_change

#Change Adjusted_LRR class to numeric (idk why it came out as character after
# the for loop)

vertebrates_coef$Original_LRR <- as.numeric(vertebrates_coef$Original_LRR)


vertebrates_coef <- vertebrates_coef %>% 
  mutate(LCI = Original_LRR - (1.96 * SE),
         UCI = Original_LRR + (1.96 * SE),
         percentage_change = 100 * (exp(Original_LRR) - 1),
         percentage_LCI = 100 * (exp(LCI) - 1),
         percentage_UCI = 100*(exp(UCI) - 1)) %>% 
  round(digits = 2) %>% 
  mutate(CI = paste( LCI, "to", UCI))

# Weeds----

weed_model <- readRDS(here("Outputs/08.Results", "Weed_model.rds"))

weed_coef <- weed_model %>%  summary() %>% .$coefficients %>%  # Get coefficients
  round(digits = 2) %>%  as.data.frame()

names(weed_coef) <- c("Original_LRR", "SE", "t") # Change colnames


# Obtain other coefficients: CI, percentage_change

#Change Adjusted_LRR class to numeric (idk why it came out as character after
# the for loop)

weed_coef$Original_LRR <- as.numeric(weed_coef$Original_LRR)

weed_coef <- weed_coef %>% 
  mutate(LCI = Original_LRR - (1.96 * SE),
         UCI = Original_LRR + (1.96 * SE),
         percentage_change = 100 * (exp(Original_LRR) - 1),
         percentage_LCI = 100 * (exp(LCI) - 1),
         percentage_UCI = 100*(exp(UCI) - 1)) %>% 
  round(digits = 2) %>% 
  mutate(CI = paste( LCI, "to", UCI))



# Formation and protection of soils----


soil_model <- readRDS(here("Outputs/08.Results", "soil_model.rds"))

soil_model <- soil_model %>%  summary() %>% .$coefficients %>%  # Get coefficients
  round(digits = 2) %>%  as.data.frame()

names(soil_model) <- c("Original_LRR", "SE", "t") # Change colnames

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

#Change Adjusted_LRR class to numeric (idk why it came out as character after
# the for loop)

arthropod_coef$Adjusted_LRR <- as.numeric(arthropod_coef$Adjusted_LRR)


soil_model <- soil_model %>% 
  mutate(LCI = Adjusted_LRR - (1.96 * SE),
         UCI = Adjusted_LRR + (1.96 * SE),
         percentage_change = 100 * (exp(Adjusted_LRR) - 1),
         percentage_LCI = 100 * (exp(LCI) - 1),
         percentage_UCI = 100*(exp(UCI) - 1)) %>% 
  round(digits = 2) %>% 
  mutate(CI = paste( LCI, "to", UCI))



