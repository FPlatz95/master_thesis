rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

######## PACKAGES #############

library(dplyr)
library(ampvis2)
library(readxl)

#############

kraken = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/kraken2_variableDB_ampvis.csv")
bracken = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/bracken/bracken_variableDB_ampvis.csv")
kaiju = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/kaiju_coreKaiju_variableDB_ampvis.csv")
singlem = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/singleM/singlem_ampvisOTU.csv")
graftm = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/graftm_ampvis.csv")
amplicon = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/amplicon_ampvis.csv")

otutable = kraken %>% 
  full_join(bracken, by = c("Kingdom","Phylum","Class","Order","Family","Genus","Species", "OTU")) %>%
  full_join(kaiju, by = c("Kingdom","Phylum","Class","Order","Family","Genus","Species", "OTU")) %>% 
  full_join(singlem, by = c("Kingdom","Phylum","Class","Order","Family","Genus","Species", "OTU")) %>% 
  full_join(graftm, by = c("Kingdom","Phylum","Class","Order","Family","Genus","Species", "OTU")) %>% 
  full_join(amplicon, by = c("Kingdom","Phylum","Class","Order","Family","Genus","Species", "OTU"))

otutable = otutable[, c(1:13,21:53,14:20)]
column_names = c("OTU","AalE_Kraken2_Refseq","Bjer_Kraken2_Refseq", "Kalu_Kraken2_Refseq", "AalE_Kraken2_Refseq_WWTP","Bjer_Kraken2_Refseq_WWTP", "Kalu_Kraken2_Refseq_WWTP", "AalE_Kraken2_WWTP","Bjer_Kraken2_WWTP", "Kalu_Kraken2_WWTP", "AalE_Kraken2_GTDB","Bjer_Kraken2_GTDB", "Kalu_Kraken2_GTDB", "AalE_Bracken_Refseq","Bjer_Bracken_Refseq", "Kalu_Bracken_Refseq", "AalE_Bracken_Refseq_WWTP","Bjer_Bracken_Refseq_WWTP", "Kalu_Bracken_Refseq_WWTP", "AalE_Bracken_WWTP","Bjer_Bracken_WWTP", "Kalu_Bracken_WWTP", "AalE_Kaiju_RefSeq", "Bjer_Kaiju_RefSeq", "Kalu_Kaiju_RefSeq", "AalE_CoreKaiju_RefSeq", "Bjer_CoreKaiju_RefSeq", "Kalu_CoreKaiju_RefSeq", "AalE_Kaiju_NR", "Bjer_Kaiju_NR", "Kalu_Kaiju_NR", "AalE_CoreKaiju_NR", "Bjer_CoreKaiju_NR", "Kalu_CoreKaiju_NR", "AalE_SingleM", "Bjer_SingleM", "Kalu_SingleM", "AalE_GraftM_SILVA", "Bjer_GraftM_SILVA", "Kalu_GraftM_SILVA", "AalE_GraftM_MIDAS", "Bjer_GraftM_MIDAS", "Kalu_GraftM_MIDAS", "AalE_Amplicon_Midas", "Bjer_Amplicon_Midas", "Kalu_Amplicon_Midas", "Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
colnames(otutable) = column_names

write.csv(otutable,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/2021-02-09_combined_otu_table.csv",row.names=F)

otu_data = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/2021-02-09_combined_otu_table.csv")
metadata = read_excel("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/data/WWTP_sequences/2021-02-09_WWTP_metadata.xlsx")
data = amp_load(otu_data, metadata)

### Kraken test ###
kraken2_FromTable = amp_subset_samples(data, Classifier == "Kraken2", Database == "RefSeq")
amp_heatmap(kraken2_FromTable, tax_empty = "remove")

kraken2_individual = amp_load(read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/kraken2_variableDB_ampvis.csv"))
amp_heatmap(kraken2_individual, tax_empty = "remove")

### Bracken test ###
bracken_FromTable = amp_subset_samples(data, Classifier == "Bracken")
amp_heatmap(bracken_FromTable, tax_empty = "remove")

bracken_individual = amp_load(read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/bracken/bracken_variableDB_ampvis.csv"))
amp_heatmap(bracken_individual, tax_empty = "remove")

### Kaiju test ### 
kaiju_FromTable = amp_subset_samples(data, Classifier == "Kaiju")
amp_heatmap(kaiju_FromTable, tax_empty = "remove")

kaiju_individual = amp_load(read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/kaiju_coreKaiju_variableDB_ampvis.csv"))
amp_heatmap(kaiju_individual, tax_empty = "remove")

### SingleM test ### 
SingleM_FromTable = amp_subset_samples(data, Classifier == "SingleM")
amp_heatmap(SingleM_FromTable, tax_empty = "remove")

SingleM_individual = amp_load(read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/singleM/singlem_ampvisOTU.csv"))
amp_heatmap(SingleM_individual, tax_empty = "remove")

### GraftM test ### 
GraftM_FromTable = amp_subset_samples(data, Classifier == "GraftM")
amp_heatmap(GraftM_FromTable, tax_empty = "remove")

GraftM_individual = amp_load(read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/graftm_ampvis.csv"))
amp_heatmap(GraftM_individual, tax_empty = "remove")

### Amplicon test ###
Amplicon_FromTable = amp_subset_samples(data, Classifier == "Amplicon")
amp_heatmap(Amplicon_FromTable, tax_empty = "remove")

Amplicon_individual = amp_load(read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/amplicon_ampvis.csv"))
amp_heatmap(Amplicon_individual, tax_empty = "remove")
