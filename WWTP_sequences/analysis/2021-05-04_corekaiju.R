library(dplyr)
library(readxl)
library(ampvis2)

metadata = read_excel("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/data/WWTP_sequences/2021-02-09_WWTP_metadata.xlsx")
kaiju_refseq = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/kaiju_refseq/ampvis_otu/kaiju_refseq_ampvis_combined.csv")
corekaiju_refseq = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_ampvis_otu/corekaiju_refseq_ampvis_combined.csv")
corekaiju_refseq_t5 = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_t5_ampvis_otu/corekaiju_refseq_t5_ampvis_combined.csv")
corekaiju_refseq_t10 = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_t10_ampvis_otu/corekaiju_refseq_t10_ampvis_combined.csv")
corekaiju_refseq_t20 = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_t20_ampvis_otu/corekaiju_refseq_t20_ampvis_combined.csv")

## Joining tables 
data_kaiju_full_join = kaiju_refseq %>% 
  full_join(corekaiju_refseq, by = c("OTU", "Kingdom","Phylum","Class","Order","Family","Genus","Species")) %>% 
  full_join(corekaiju_refseq_t5, by = c("OTU", "Kingdom","Phylum","Class","Order","Family","Genus","Species")) %>% 
  full_join(corekaiju_refseq_t10, by = c("OTU", "Kingdom","Phylum","Class","Order","Family","Genus","Species")) %>% 
  full_join(corekaiju_refseq_t20, by = c("OTU", "Kingdom","Phylum","Class","Order","Family","Genus","Species"))
data_kaiju_full_join = data_kaiju_full_join[,c(1:16,24:83,17:23)]

## Ampvis objects
kaiju_fj_ampvis = amp_load(otutable = data_kaiju_full_join, metadata = metadata)
stats_kaiju_fj = amp_alphadiv(kaiju_fj_ampvis)

corekaiju_ampvis = amp_subset_samples(kaiju_fj_ampvis, Classifier == "CoreKaiju")
stats_corekaiju = amp_alphadiv(corekaiju_ampvis)

kaiju_ampvis = amp_subset_samples(kaiju_fj_ampvis, Classifier == "Kaiju")
stats_kaiju = amp_alphadiv(kaiju_ampvis)

stats_kaiju_fj$Database = factor(stats_kaiju_fj$Database, levels = c("Refseq", "Refseq_t0", "Refseq_t5", "Refseq_t10", "Refseq_t20"))
stats_corekaiju$Database = factor(stats_corekaiju$Database, levels = c("Refseq_t0", "Refseq_t5", "Refseq_t10", "Refseq_t20"))

stats_kaiju_fj %>% 
  mutate(normalized_reads = Reads / Metagenome_size_at) %>% 
  ggplot(aes(x = Database, y = normalized_reads, color = Plant)) + 
  geom_jitter() + 
  theme_classic() + 
  theme(panel.grid.major = element_line(color = "grey90"),
        panel.grid.minor = element_line(color = "grey90")) + 
  scale_x_discrete(labels = c("Kaiju", "Core Kaiju t0", "Core Kaiju t5", "Core Kaiju t10", "Core Kaiju t20")) +
  ylab("Classified Reads") + 
  ylim(c(0,1))

stats_kaiju_fj %>% 
  ggplot(aes(x = Database, y = Shannon, color = Plant)) + 
  geom_jitter() + 
  theme_classic() + 
  theme(panel.grid.major = element_line(color = "grey90"),
        panel.grid.minor = element_line(color = "grey90"))  + 
  scale_x_discrete(labels = c("Kaiju", "Core Kaiju t0", "Core Kaiju t5", "Core Kaiju t10", "Core Kaiju t20"))


stats_corekaiju %>% 
  mutate(normalized_reads = Reads / Metagenome_size_at) %>% 
  ggplot(aes(x = Database, y = normalized_reads)) + 
  geom_boxplot() + 
  theme_classic() + 
  theme(panel.grid.major = element_line(color = "grey90"),
        panel.grid.minor = element_line(color = "grey90")) + 
  ylab("Classified Reads") + 
  ylim(c(0,1))


stats_corekaiju_t0 = stats_corekaiju %>% 
  filter(Database == "Refseq_t0")
stats_corekaiju_t5 = stats_corekaiju %>% 
  filter(Database == "Refseq_t5")
stats_corekaiju_t10 = stats_corekaiju %>% 
  filter(Database == "Refseq_t10")
stats_corekaiju_t20 = stats_corekaiju %>% 
  filter(Database == "Refseq_t20")

mean(stats_kaiju$Reads / stats_kaiju$Metagenome_size_at)
mean(stats_corekaiju_t0$Reads / stats_corekaiju_t0$Metagenome_size_at)
mean(stats_corekaiju_t5$Reads / stats_corekaiju_t5$Metagenome_size_at)
mean(stats_corekaiju_t10$Reads / stats_corekaiju_t10$Metagenome_size_at)
mean(stats_corekaiju_t20$Reads / stats_corekaiju_t20$Metagenome_size_at)

17000000 * 0.166 - 17000000 * 0.10 

kaiju_fj_ampvis$metadata$Database = factor(kaiju_fj_ampvis$metadata$Database, levels = c("Refseq", "Refseq_t0", "Refseq_t5", "Refseq_t10", "Refseq_t20"))
amp_heatmap(kaiju_fj_ampvis, group_by = "Database", tax_empty = "remove", tax_aggregate = "Phylum", tax_show = 30) + 
  scale_x_discrete(labels = c("Kaiju", "Core Kaiju t0", "Core Kaiju t5", "Core Kaiju t10", "Core Kaiju t20"))

stats_kaiju_refseq = stats_kaiju %>% 
  filter(Database == "Refseq")
mean(stats_kaiju_refseq$Reads / stats_kaiju_refseq$Metagenome_size_at)

corekaiju_t0_ampvis = amp_subset_samples(corekaiju_ampvis, Database == "Refseq_t0")
corekaiju_t5_ampvis = amp_subset_samples(corekaiju_ampvis, Database == "Refseq_t5")
corekaiju_t10_ampvis = amp_subset_samples(corekaiju_ampvis, Database == "Refseq_t10")
corekaiju_t20_ampvis = amp_subset_samples(corekaiju_ampvis, Database == "Refseq_t20")

corekaiju_t0_ampvis_filtered = amp_subset_samples(corekaiju_t0_ampvis, !Plant %in% c("Kalundborg", "Fredericia"))
corekaiju_t20_ampvis_filtered = amp_subset_samples(corekaiju_t20_ampvis, !Plant %in% c("Kalundborg", "Fredericia"))

## Ordination

amp_ordinate(corekaiju_t0_ampvis, sample_color_by = "Plant", sample_label_by = "Plant") + 
  theme(legend.position = "none")
amp_ordinate(corekaiju_t5_ampvis, sample_color_by = "Plant", sample_label_by = "Plant")
amp_ordinate(corekaiju_t10_ampvis, sample_color_by = "Plant", sample_label_by = "Plant")
amp_ordinate(corekaiju_t20_ampvis, sample_color_by = "Plant", sample_label_by = "Plant") + 
  theme(legend.position = "none")

amp_ordinate(corekaiju_t0_ampvis_filtered, sample_color_by = "Plant", sample_label_by = "Plant")
amp_ordinate(corekaiju_t20_ampvis_filtered, sample_color_by = "Plant", sample_label_by = "Plant")




##### Scree plots

scree_plot_t20 = amp_ordinate(corekaiju_t20_ampvis, detailed_output = TRUE)

scree_plot_data_t20 = data.frame(scree_plot_t20$screeplot$data$eigenvalues, scree_plot_t20$screeplot$data$axis)
ggplot(scree_plot_data_t20, aes(x = scree_plot_t20.screeplot.data.axis, y = scree_plot_t20.screeplot.data.eigenvalues)) + 
  geom_bar(stat = "identity") + 
  xlab("") + 
  ylab("Eigen Values") + 
  scale_y_continuous(expand = c(0,0)) + 
  theme_classic() + 
  theme(panel.grid.major = element_line())

scree_plot_t0 = amp_ordinate(corekaiju_t0_ampvis, detailed_output = TRUE)

scree_plot_data_t0 = data.frame(scree_plot_t0$screeplot$data$eigenvalues, scree_plot_t0$screeplot$data$axis)
ggplot(scree_plot_data_t0, aes(x = scree_plot_t0.screeplot.data.axis, y = scree_plot_t0.screeplot.data.eigenvalues)) + 
  geom_bar(stat = "identity") + 
  xlab("") + 
  ylab("Eigen Values") + 
  scale_y_continuous(expand = c(0,0)) + 
  theme_classic() + 
  theme(panel.grid.major = element_line())
