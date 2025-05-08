# load packages

library(tidyverse)
library(ggpubr)
library(zoo)
library(readxl)
library(fields)
library(rnaturalearth)
library(sf)
library(terra)
library(ebirdst)

# Load in data 

closure_df <-
  read_excel("./TRPD Beach Data.xlsx", range = cell_cols("A:H")) %>%
  mutate(Sample_ID = recode(Sample_ID, 
                            "Elm Creek Swim" = "Elm Creek Swim Pond",
                            "Elm Creek Swim pond" = "Elm Creek Swim Pond",
                            "Minnetonka Swim pond" = "Minnetonka Swim Pond"))
closure_df %>% 
  group_by()

# Cleanup and analysis and all that
closure_clean <- 
  closure_df %>%
  mutate(Sample_ID = recode(Sample_ID, 
                            "Elm Creek Swim" = "Elm Creek Swim Pond",
                            "Elm Creek Swim pond" = "Elm Creek Swim Pond",
                            "Minnetonka Swim pond" = "Minnetonka Swim Pond"))
closure_clean %>%
  filter(Sample_ID == "Auburn") %>%
  summary()
