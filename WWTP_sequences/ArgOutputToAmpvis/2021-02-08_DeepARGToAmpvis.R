rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

######## PACKAGES #############

library(dplyr)
library(ampvis2)
library(readxl)

#########

read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/WWTP_sequences/huy/deepARG_output/")
