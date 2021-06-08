rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

######## PACKAGES #############

library(dplyr)
library(ampvis2)
library(readxl)
library(tidyr)
library(stringr)

######### Filtering Metadata 

mfd_metadata = read.csv("/srv/MA/Projects/microflora_danica/analysis/mfd_metadata/2020-11-10-14-47_mdf_metadata.csv") 
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
mfd_metadata_filtered = mfd_metadata_filtered %>% 
  filter(habitattype_new %in% c("agriculture", "urban", "River Valleys","bog", "dune", "meadow", "lake", "stream", "grasslands", "forest", "moor"))


######### Loading ampvis tables
graftm_otu = read.csv("/srv/MA/Projects/microflora_danica/analysis/classified_graftm/graftm_output/otutables/ampvis_format/graftm_combined_otu.csv", check.names = FALSE)
kraken2_otu = read.csv("/srv/MA/Projects/microflora_danica/analysis/classified_kraken2/refseq/ampvis_format/kraken2_refseq_ampvis_combined.csv", check.names = FALSE)
corekaiju_t5_otu = read.csv("/srv/MA/Projects/microflora_danica/analysis/classified_corekaiju_t5/corekaiju_t5_ampvis_combined.csv", check.names = FALSE)

graftm_ampvis = amp_load(graftm_otu, metadata = mfd_metadata_filtered)
kraken2_ampvis = amp_load(kraken2_otu, metadata = mfd_metadata_filtered)
corekaiju_t5_ampvis = amp_load(corekaiju_t5_otu, metadata = mfd_metadata_filtered)
corekaiju_t5_ampvis = amp_subset_samples(corekaiju_t5_ampvis, minreads = 1)

graftm_ampvis = amp_subset_samples(graftm_ampvis, total_reads > 5000000)
kraken2_ampvis = amp_subset_samples(kraken2_ampvis, total_reads > 5000000)
corekaiju_t5_ampvis = amp_subset_samples(corekaiju_t5_ampvis, total_reads > 5000000)


amp_ordinate(graftm_ampvis, sample_color_by = "type", sample_colorframe = TRUE) + 
  labs(title = "GraftM - SILVA Database") 
amp_ordinate(kraken2_ampvis, sample_color_by = "type", sample_colorframe = TRUE) + 
  labs(title = "Kraken2 - NCBI Refseq Database") 
amp_ordinate(corekaiju_t5_ampvis, sample_color_by = "type", sample_colorframe = TRUE) + 
  labs(title = "Core Kaiju - NCBI Refseq and Custom PFAM Database") 

amp_ordinate(graftm_ampvis, sample_color_by = "habitattype_new", sample_colorframe = TRUE) + 
  labs(title = "GraftM - SILVA Database") 
amp_ordinate(kraken2_ampvis, sample_color_by = "habitattype_new", sample_colorframe = TRUE) + 
  labs(title = "Kraken2 - NCBI Refseq Database") 
amp_ordinate(corekaiju_t5_ampvis, sample_color_by = "habitattype_new", sample_colorframe = TRUE) + 
  labs(title = "Core Kaiju - NCBI Refseq and Custom PFAM Database")

amp_ordinate(graftm_ampvis, type = "CA", sample_color_by = "habitattype_new", sample_colorframe = TRUE, sample_label_by = "id_sequencing_admera") + 
  labs(title = "GraftM - SILVA Database") 
amp_ordinate(kraken2_ampvis, type = "CA", sample_color_by = "habitattype_new", sample_colorframe = TRUE) + 
  labs(title = "Kraken2 - NCBI Refseq Database") 
amp_ordinate(corekaiju_t5_ampvis, type = "CA", sample_color_by = "habitattype_new", sample_colorframe = TRUE) + 
  labs(title = "Core Kaiju - NCBI Refseq and Custom PFAM Database")

graftm_ca_test = amp_subset_samples(graftm_ampvis, !id_sequencing_admera %in% "20003FL-02-01-179")
amp_ordinate(graftm_ca_test, type = "CCA", sample_color_by = "type", sample_colorframe = TRUE, constrain = "habitattype_new") + 
  labs(title = "GraftM - SILVA Database")

amp_ordinate(corekaiju_t5_ampvis, type = "CCA", sample_color_by = "type", sample_colorframe = TRUE, constrain = "type", sample_label_by = "id_sequencing_admera") + 
  labs(title = "GraftM - SILVA Database")

graftm_ampvis_soil = amp_subset_samples(graftm_ampvis, type == "soil")
kraken2_ampvis_soil = amp_subset_samples(kraken2_ampvis, type == "soil")
corekaiju_t5_ampvis_soil = amp_subset_samples(corekaiju_t5_ampvis, type == "soil")

amp_ordinate(graftm_ampvis_soil, sample_color_by = "habitattype_new", sample_colorframe = TRUE) + 
  labs(title = "GraftM - SILVA Database") 
amp_ordinate(kraken2_ampvis_soil, sample_color_by = "habitattype_new", sample_colorframe = TRUE) + 
  labs(title = "Kraken2 - NCBI Refseq Database") 
amp_ordinate(corekaiju_t5_ampvis_soil, sample_color_by = "habitattype_new", sample_colorframe = TRUE) + 
  labs(title = "Core Kaiju - NCBI Refseq and Custom PFAM Database") 


graftm_ampvis_agriculture = amp_subset_samples(graftm_ampvis, habitattype_new == "agriculture")
graftm_ampvis_agriculture_stats = amp_alphadiv(graftm_ampvis_agriculture)

amp_heatmap(graftm_ampvis_agriculture, group_by = "habitattype_new", tax_empty = "remove", tax_show = 25, tax_aggregate = "Family") 

amp_heatmap(graftm_ampvis_agriculture, group_by = "habitattype_new", tax_empty = "remove", tax_show = 10, tax_aggregate = "Phylum") 

amp_heatmap(graftm_ampvis, group_by = "habitattype_new", tax_empty = "remove", tax_show = 10, tax_aggregate = "Phylum")

graftm_ampvis_stats = amp_alphadiv(graftm_ampvis)

ggplot(graftm_ampvis_stats, aes(x = habitattype_new, y = Shannon)) + 
  geom_boxplot()

graftm_ampvis_rarefied = amp_subset_samples(graftm_ampvis_rarefied, minreads = 4000, rarefy = 4000)
graftm_ampvis_rarefied_stats = amp_alphadiv(graftm_ampvis_rarefied)

ggplot(graftm_ampvis_rarefied_stats, aes(x = habitattype_new, y = Shannon, color = habitattype_new)) + 
  geom_jitter(width = 0.3)


