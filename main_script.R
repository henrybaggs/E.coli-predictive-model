# load packages

library(tidyverse)
library(ggpubr)
library(zoo)
library(readxl)


# Load in data 

closure_df <-
  read_excel("./TRPD Beach Data.xlsx", range = cell_cols("A:H"), col) %>%
  group_by

# Cleanup and analysis and all that
goop <- 
  closure_df  %>%
  group_by(`Sample ID`, Year) %>%
  replace(`Sample ID` = "Elm Creek Swim", "Elm Creek Swin Pond")%>%
  replace("Minnetonka Swim pond", "Minnetonka Swim Pond") %>%
  ungroup()


distinc
