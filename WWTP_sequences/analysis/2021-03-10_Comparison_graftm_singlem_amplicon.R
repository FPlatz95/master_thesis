library(dplyr)
library(readxl)
library(ampvis2)

## Loading tables 
GraftM_Midas = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/01_midas_combined_count/ampvis_otu/graftm_midas_combined_otu.csv")
GraftM_Silva = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/02_silva_combined_count/ampvis_otu/graftm_silva_combined_otu.csv")
SingleM = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/singleM/ampvis_otu/singlem_combined_otu.csv")
Amplicon = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/amplicon_combined_otu.csv")
metadata = read_excel("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/data/WWTP_sequences/2021-02-09_WWTP_metadata.xlsx")

## Joining tables 
data = Amplicon %>% 
  full_join(GraftM_Midas, by = c("OTU", "Kingdom","Phylum","Class","Order","Family","Genus","Species")) %>% 
  full_join(GraftM_Silva, by = c("OTU", "Kingdom","Phylum","Class","Order","Family","Genus","Species")) %>% 
  full_join(SingleM, by = c("OTU", "Kingdom","Phylum","Class","Order","Family","Genus","Species"))
data = data[,c(1:15,23:67,16:22)]

## Creating ampvis object
data_ampvis = amp_load(otutable = data, metadata = metadata)
stats = amp_alphadiv(data_ampvis)


amplicon = amp_subset_samples(data_ampvis, Classifier == "Amplicon")
amp_rarecurve(amplicon, color_by = "Plant")

ggplot(stats, aes(x = Classifier, y = ObservedOTUs)) + 
  geom_boxplot()

ggplot(stats, aes(x = Classifier, y = Shannon)) + 
  geom_boxplot()

