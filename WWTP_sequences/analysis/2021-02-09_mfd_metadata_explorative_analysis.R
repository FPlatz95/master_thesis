rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

######## PACKAGES #############

library(dplyr)
library(ampvis2)
library(readxl)
library(tidyr)

#########

mfd_metadata = read.csv("/srv/MA/Projects/microflora_danica/analysis/mfd_metadata/2020-11-10-14-47_mdf_metadata.csv") 
graftm_otu = read.csv("/srv/MA/Projects/microflora_danica/analysis/classified_graftm/graftm_output/otutables/ampvis_format/graftm_combined_otu.csv", check.names = FALSE)


#### Meta Data analysis #### 
# What sample types are present in the data
ggplot(mfd_metadata, aes(x = type)) + 
  geom_bar() + 
  scale_y_continuous(expand = c(0,0)) + 
  theme_classic() + 
  theme(panel.grid.major = element_line(),panel.grid.minor = element_line())

# Habitattype numbers
mfd_metadata %>% 
  filter(as.numeric(as.character(habitattypenumber)) > 0) %>% 
  count()

# different habitattypes: 
ggplot(mfd_metadata, aes(x = habitattype)) + 
  geom_bar() +
  scale_y_continuous(expand = c(0,0)) + 
  theme_classic() + 
  theme(panel.grid.major = element_line(),panel.grid.minor = element_line(), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

# Instead of having a varierity of different habitattypes, all are gathered together. 
mfd_metadata_filtered = mfd_metadata
mfd_metadata_filtered$habitattype = as.character(mfd_metadata_filtered$habitattype)
mfd_metadata_filtered$habitattype = replace_na(mfd_metadata_filtered$habitattype, "Not_Registred")

m = c()
for(i in 1:nrow(mfd_metadata_filtered)) {
  bog_list = str_detect(mfd_metadata_filtered$habitattype, "bog") 
  dune_list = str_detect(mfd_metadata_filtered$habitattype, "dune")
  forest_list = str_detect(mfd_metadata_filtered$habitattype, "forest")
  grasslands_list = str_detect(mfd_metadata_filtered$habitattype, "grasslands")
  lake_list = str_detect(mfd_metadata_filtered$habitattype, "lake")
  meadow_list = str_detect(mfd_metadata_filtered$habitattype, "meadow")
  moor_list = str_detect(mfd_metadata_filtered$habitattype, "moor")
  swamp_list = str_detect(mfd_metadata_filtered$habitattype, "swamp")
  if(bog_list[i] == TRUE) {
    m[i] = "bog"
  } else if(forest_list[i] == TRUE) {
    m[i] = "forest"
  } else if(grasslands_list[i] == TRUE) {
    m[i] = "grasslands"
  } else if(lake_list[i] == TRUE) {
    m[i] = "lake"
  } else if(dune_list[i] == TRUE) {
    m[i] = "dune"
  } else if(meadow_list[i] == TRUE) {
    m[i] = "meadow"
  } else if(moor_list[i] == TRUE) {
    m[i] = "moor"
  } else if(swamp_list[i] == TRUE) {
    m[i] = "swamp"
  } else {
    m[i] = mfd_metadata_filtered$habitattype[i]
  }
}
mfd_metadata_filtered$habitattype_new = m

mfd_metadata_filtered %>% 
  group_by(habitattype_new) %>% 
  count() %>%
  arrange(desc(n))

mfd_metadata_filtered = mfd_metadata_filtered %>% 
  filter(habitattype_new %in% c("agriculture", "urban", "River Valleys","bog", "dune", "meadow", "lake", "stream", "grasslands", "forest", "moor"))

ggplot(mfd_metadata_filtered, aes(x = habitattype_new)) + 
  geom_bar() +
  scale_y_continuous(expand = c(0,0)) + 
  theme_classic() + 
  theme(panel.grid.major = element_line(),panel.grid.minor = element_line(), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))


ggplot(mfd_metadata_filtered, aes(x = type, fill = habitattype_new)) + 
  geom_bar() +
  scale_y_continuous(expand = c(0,0)) + 
  theme_classic() + 
  theme(panel.grid.major = element_line(),panel.grid.minor = element_line())

#DNA extraction and total_reads 
ggplot(mfd_metadata, aes(x = conc_extraction)) + 
  geom_histogram() +
  scale_y_continuous(expand = c(0,0)) + 
  theme_classic() + 
  theme(panel.grid.major = element_line(),panel.grid.minor = element_line())

summary(mfd_metadata$conc_extraction)

conc_extraction_breaks = c(0,5,10,15,20,25,30,120)
mfd_metadata$conc_extraction_bins = cut(mfd_metadata$conc_extraction, conc_extraction_breaks)


ggplot(mfd_metadata, aes(x = conc_library)) + 
  geom_histogram() +
  scale_y_continuous(expand = c(0,0)) + 
  theme_classic() + 
  theme(panel.grid.major = element_line(),panel.grid.minor = element_line())

summary(mfd_metadata$conc_library)

conc_library_breaks = seq(0,8,1)
mfd_metadata$conc_library_bins = cut(mfd_metadata$conc_library, conc_library_breaks)


ggplot(mfd_metadata, aes(x = total_reads)) + 
  geom_histogram() +
  scale_y_continuous(expand = c(0,0)) + 
  theme_classic() + 
  theme(panel.grid.major = element_line(),panel.grid.minor = element_line())

total_reads_breaks = c(0,10000000,12500000,15000000,17500000,20000000,22500000,100000000)
mfd_metadata$total_reads_bins = cut(mfd_metadata$total_reads, total_reads_breaks)


### Loading ampvis object ###

graftm_ampvis = amp_load(metadata = mfd_metadata_filtered, otutable = graftm_otu)
graftm_ampvis_stats = amp_alphadiv(graftm_ampvis)

graftm_ampvis_stats_filtered = graftm_ampvis_stats %>% 
  filter(habitattype %in% c("agriculture", "urban", "River valleys", "stream", "lake_nutritious", "grasslands", "meadow", "forrest_beach", "bog"))

ggplot(graftm_ampvis_stats_filtered, aes(x = conc_extraction_bins, y = Shannon)) + 
  geom_boxplot() 

ggplot(graftm_ampvis_stats_filtered, aes(x = conc_library_bins, y = Shannon)) + 
  geom_boxplot() 

ggplot(graftm_ampvis_stats_filtered, aes(x = total_reads_bins, y = Shannon)) + 
  geom_boxplot() 

ggplot(graftm_ampvis_stats_filtered, aes(x = conc_extraction_bins, y = ObservedOTUs)) + 
  geom_boxplot() 

ggplot(graftm_ampvis_stats_filtered, aes(x = conc_library_bins, y = ObservedOTUs)) + 
  geom_boxplot() 

ggplot(graftm_ampvis_stats_filtered, aes(x = total_reads_bins, y = ObservedOTUs)) + 
  geom_boxplot() 

amp_ordinate(graftm_ampvis, sample_color_by = "habitattype_new", sample_colorframe = TRUE)

amp_ordinate(graftm_ampvis, sample_color_by = "type", sample_colorframe = TRUE) 

graftm_ampvis_soil = amp_subset_samples(graftm_ampvis, habitattype_new %in% c("agriculture", "urban", "River Valleys", "bog", "dune", "meadow", "grasslands", "forest", "moor"))

amp_ordinate(graftm_ampvis_soil, sample_color_by = "habitattype_new", sample_colorframe = TRUE, type = "PCA")



