rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

######## PACKAGES #############

library(dplyr)
library(ampvis2)
library(readxl)
library(tidyr)
library(stringr)

#########

graftm_otu = read.csv("/srv/MA/Projects/microflora_danica/analysis/classified_graftm/graftm_output/otutables/ampvis_format/graftm_combined_otu.csv", check.names = FALSE)

data = amp_load(otutable = graftm_otu, metadata = mfd_metadata_filtered)

amp_ordinate(data)

amp_ordinate(data, sample_color_by = "habitattype_new", type = "PCoA", transform = "none", distmeasure = "bray") 


scree_plot = amp_ordinate(data, detailed_output = TRUE)

scree_plot_data = data.frame(scree_plot$screeplot$data$eigenvalues, scree_plot$screeplot$data$axis)
ggplot(scree_plot_data, aes(x = scree_plot.screeplot.data.axis, y = scree_plot.screeplot.data.eigenvalues)) + 
  geom_bar(stat = "identity") + 
  xlab("") + 
  ylab("Eigen Values") + 
  scale_y_continuous(expand = c(0,0)) + 
  theme_classic() + 
  theme(panel.grid.major = element_line())
