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
data_ampvis_prelim = amp_load(otutable = data, metadata = metadata) 
data_ampvis = amp_subset_samples(data_ampvis_prelim, Database == "MIDAS")
amplicon = amp_subset_samples(data_ampvis, Classifier == "Amplicon")
graftm = amp_subset_samples(data_ampvis, Classifier == "GraftM")

# Rarefraction curves 
amp_rarecurve(amplicon, color_by = "Plant")
amp_rarecurve(graftm, color_by = "Plant")

#We compared the two rarefraction curves, and rarefied both to the lowest number of reads in graftm samples; 5800. 

amp_rarecurve(amplicon, color_by = "Plant") + 
  geom_vline(xintercept=5800, color = "darkred", lty = 2) 

amp_rarecurve(graftm, color_by = "Plant", stepsize = 200) +
  geom_vline(xintercept=5800, color = "darkred", lty = 2) 

data_ampvis_filtered = amp_subset_samples(data_ampvis, rarefy = 5800)
stats = amp_alphadiv(data_ampvis_filtered)

amplicon_filtered = amp_subset_samples(data_ampvis_filtered, Classifier == "Amplicon")
graftm_filtered = amp_subset_samples(data_ampvis_filtered, Classifier == "GraftM")

amp_rarecurve(amplicon_filtered, color_by = "Plant", stepsize = 200)
amp_rarecurve(graftm_filtered, color_by = "Plant", stepsize = 200)

amp_export_otutable(amplicon_filtered, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/amplicon_combined_otu_filtered")
Amplicon_rawotu_filtered = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/amplicon_combined_otu_filtered.csv", sep = "\t")

amp_export_otutable(graftm_filtered, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/01_midas_combined_count/ampvis_otu/graftm_midas_combined_otu_filtered")
graftm_rawotu_filtered = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/01_midas_combined_count/ampvis_otu/graftm_midas_combined_otu_filtered.csv", sep = "\t")



#Phylum level heatmaps
amp_heatmap(data_ampvis_filtered, group_by = "Classifier")

#Number of unique OTU's at all taxonomic levels. 
amplicon_phylums = Amplicon_rawotu_filtered %>% 
  group_by(Phylum) %>% 
  count() %>% 
  arrange(desc(n))

graftm_phylums = graftm_rawotu_filtered %>% 
  group_by(Phylum) %>% 
  count() %>% 
  arrange(desc(n))

phylum_comparison = amplicon_phylums %>% 
  full_join(graftm_phylums, by = "Phylum", suffix = c("_amplicon", "_graftm"))
phylum_comparison = phylum_comparison[c(-35,-45),]
phylum_comparison$Phylum = as.character(phylum_comparison$Phylum)


amplicon_class = Amplicon_rawotu_filtered %>% 
  group_by(Class) %>% 
  count() %>% 
  arrange(desc(n))

graftm_class = graftm_rawotu_filtered %>% 
  group_by(Class) %>% 
  count() %>% 
  arrange(desc(n))

class_comparison = amplicon_class %>% 
  full_join(graftm_class, by = "Class", suffix = c("_amplicon", "_graftm")) 
class_comparison = class_comparison[c(-20,-91),]
class_comparison$Class = as.character(class_comparison$Class)


amplicon_order = Amplicon_rawotu_filtered %>% 
  group_by(Order) %>% 
  count() %>% 
  arrange(desc(n))

graftm_order = graftm_rawotu_filtered %>% 
  group_by(Order) %>% 
  count() %>% 
  arrange(desc(n))

order_comparison = amplicon_order %>% 
  full_join(graftm_order, by = "Order", suffix = c("_amplicon", "_graftm"))
order_comparison = order_comparison[c(-15,-207),]
order_comparison$Order = as.character(order_comparison$Order)


amplicon_family = Amplicon_rawotu_filtered %>% 
  group_by(Family) %>% 
  count() %>% 
  arrange(desc(n))

graftm_family = graftm_rawotu_filtered %>% 
  group_by(Family) %>% 
  count() %>% 
  arrange(desc(n))

family_comparison = amplicon_family %>% 
  full_join(graftm_family, by = "Family", suffix = c("_amplicon", "_graftm"))
family_comparison = family_comparison[c(-1,-454),]
family_comparison$Family = as.character(family_comparison$Family)


amplicon_genus = Amplicon_rawotu_filtered %>% 
  group_by(Genus) %>% 
  count() %>% 
  arrange(desc(n))

graftm_genus = graftm_rawotu_filtered %>% 
  group_by(Genus) %>% 
  count() %>% 
  arrange(desc(n))

genus_comparison = amplicon_genus %>% 
  full_join(graftm_genus, by = "Genus", suffix = c("_amplicon", "_graftm"))
genus_comparison = genus_comparison[c(-1,-1455),]
genus_comparison$Genus = as.character(genus_comparison$Genus)


amplicon_species = Amplicon_rawotu_filtered %>% 
  group_by(Species) %>% 
  count() %>% 
  arrange(desc(n))

graftm_species = graftm_rawotu_filtered %>% 
  group_by(Species) %>% 
  count() %>% 
  arrange(desc(n))

species_comparison = amplicon_species %>% 
  full_join(graftm_species, by = "Species", suffix = c("_amplicon", "_graftm"))
species_comparison = species_comparison[c(-1,-3186),]
species_comparison$Species = as.character(species_comparison$Species)


graftm_total = c(sum(phylum_comparison$n_graftm, na.rm = TRUE), sum(class_comparison$n_graftm, na.rm = TRUE), sum(order_comparison$n_graftm, na.rm = TRUE), sum(family_comparison$n_graftm, na.rm = TRUE), sum(genus_comparison$n_graftm, na.rm = TRUE), sum(species_comparison$n_graftm, na.rm = TRUE))
amplicon_total = c(sum(phylum_comparison$n_amplicon, na.rm = TRUE), sum(class_comparison$n_amplicon, na.rm = TRUE), sum(order_comparison$n_amplicon, na.rm = TRUE), sum(family_comparison$n_amplicon, na.rm = TRUE), sum(genus_comparison$n_amplicon, na.rm = TRUE), sum(species_comparison$n_amplicon, na.rm = TRUE))

graftm_nrow = c(length(phylum_comparison$n_graftm[!is.na(phylum_comparison$n_graftm)]), length(class_comparison$n_graftm[!is.na(class_comparison$n_graftm)]), length(order_comparison$n_graftm[!is.na(order_comparison$n_graftm)]), length(family_comparison$n_graftm[!is.na(family_comparison$n_graftm)]), length(genus_comparison$n_graftm[!is.na(genus_comparison$n_graftm)]), length(species_comparison$n_graftm[!is.na(species_comparison$n_graftm)]))
amplicon_nrow = c(length(phylum_comparison$n_amplicon[!is.na(phylum_comparison$n_amplicon)]), length(class_comparison$n_amplicon[!is.na(class_comparison$n_amplicon)]), length(order_comparison$n_amplicon[!is.na(order_comparison$n_amplicon)]), length(family_comparison$n_amplicon[!is.na(family_comparison$n_amplicon)]), length(genus_comparison$n_amplicon[!is.na(genus_comparison$n_amplicon)]), length(species_comparison$n_amplicon[!is.na(species_comparison$n_amplicon)]))


taxonomic_levels = c("Phylum","Class","Order","Family","Genus","Species")

comparison_df = data.frame(taxonomic_levels, graftm_nrow, amplicon_nrow, graftm_total, amplicon_total)
comparison_df$taxonomic_levels = factor(comparison_df$taxonomic_levels, ordered = TRUE, levels = c("Phylum","Class","Order","Family","Genus","Species")) 
  
comparison_df_new = t(comparison_df)
comparison_df_new = as.data.frame(comparison_df_new)
colnames(comparison_df_new) = taxonomic_levels
comparison_df_new = comparison_df_new[c(-1,-4,-5),]
comparison_df_new = comparison_df_new[c(2,1),]
comparison_df_new_rownames = c("Amplicon", "GraftM")
rownames(comparison_df_new) = comparison_df_new_rownames
print(comparison_df_new)

#Unique OTUs 
unique_graftm = function(data) {
  m1 = c()
  for(i in 1:nrow(data)) {
    if(is.na(data[i,2])){
      m1[i] = data[i,1]
    }
    else{
      m1[i] = NULL
    }
  }
  m1 = unlist(m1)
}

unique_amplicon = function(data) {
  m1 = c()
  for(i in 1:nrow(data)) {
    if(is.na(data[i,3])){
      m1[i] = data[i,1]
    }
    else{
      m1[i] = NULL
    }
  }
  m1 = unlist(m1)
}


amplicon_unique_phylum = unique_amplicon(phylum_comparison)
graftm_unique_phylum = unique_graftm(phylum_comparison)

amplicon_unique_class = unique_amplicon(class_comparison)
graftm_unique_class = unique_graftm(class_comparison)

amplicon_unique_order = unique_amplicon(order_comparison)
graftm_unique_order = unique_graftm(order_comparison)

amplicon_unique_family = unique_amplicon(family_comparison)
graftm_unique_family = unique_graftm(family_comparison)

amplicon_unique_genus = unique_amplicon(genus_comparison)
graftm_unique_genus = unique_graftm(genus_comparison)

amplicon_unique_species = unique_amplicon(species_comparison)
graftm_unique_species = unique_graftm(species_comparison)

unique_amplicon_otus = c(length(amplicon_unique_phylum), length(amplicon_unique_class), length(amplicon_unique_order), length(amplicon_unique_family), length(amplicon_unique_genus), length(amplicon_unique_species))

unique_graftm_otus = c(length(graftm_unique_phylum), length(graftm_unique_class), length(graftm_unique_order), length(graftm_unique_family), length(graftm_unique_genus), length(graftm_unique_species))

unique_otus = data.frame(unique_amplicon_otus, unique_graftm_otus)
unique_otus_rownames = c("Amplicon", "GraftM") 
unique_otus = t(unique_otus)
unique_otus = as.data.frame(unique_otus)

colnames(unique_otus) = taxonomic_levels
rownames(unique_otus) = unique_otus_rownames

print(unique_otus)

#Ordination 
amp_ordinate(graftm_filtered, sample_color_by = "Plant", sample_label_by = "Plant") + 
  ggtitle("GraftM")

amp_ordinate(amplicon_filtered, sample_color_by = "Plant", sample_label_by = "Plant") + 
  ggtitle("Amplicon")

#Alpha diversity 
ggplot(stats, aes(x = Classifier, y = ObservedOTUs)) + 
  geom_boxplot()

ggplot(stats, aes(x = Classifier, y = Shannon)) + 
  geom_boxplot()

#Heatmaps 
amp_heatmap(data_ampvis_filtered, group_by = "Classifier", tax_aggregate = "Family", tax_show = 50, showRemainingTaxa = TRUE, tax_empty = "remove")

amp_heatmap(data_ampvis, group_by = "Classifier", tax_aggregate = "Family", tax_empty = "remove", tax_show = 35, tax_add = "Phylum") + 
  labs(title = "Taxonomic Level: Family") + 
  theme(plot.title = element_text(size = 22, hjust = 0.5))

amp_heatmap(data_ampvis, group_by = "Classifier", tax_aggregate = "Class", tax_empty = "remove", tax_show = 35, tax_add = "Phylum") + 
  labs(title = "Taxonomic Level: Class") + 
  theme(plot.title = element_text(size = 22, hjust = 0.5))

amp_heatmap(data_ampvis, group_by = "Classifier", tax_aggregate = "Genus", tax_empty = "remove", tax_show = 35, tax_add = "Phylum") + 
  labs(title = "Taxonomic Level: Genus") + 
  theme(plot.title = element_text(size = 22, hjust = 0.5))

amp_heatmap(data_ampvis, group_by = "Classifier", tax_aggregate = "Species", tax_empty = "remove", tax_show = 35, tax_add = "Phylum") + 
  labs(title = "Taxonomic Level: Species") + 
  theme(plot.title = element_text(size = 22, hjust = 0.5))

