
GraftM_Silva = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/02_silva_combined_count/ampvis_otu/graftm_silva_combined_otu.csv")
metadata = read_excel("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/data/WWTP_sequences/2021-02-09_WWTP_metadata.xlsx")
graftm_silva_table = amp_subset_samples(graftm_comp_ampvis, Database == "Silva")
stats_silva_table = amp_alphadiv(graftm_silva_table)

stats_silva_table = stats_silva_table %>% arrange(Plant)
reads_classified_silva = stats_silva_table$Reads 
reads_extracted_silva = c(9205, 8369, 6466, 7628,8746 ,8579 ,7246 ,7620 ,7625 ,8842 ,8149 ,8043 ,6958 ,8547)

silva_reads_comp = data.frame(reads_extracted_silva, reads_classified_silva, metagenome_size)
silva_reads_comp = silva_reads_comp %>% mutate(rRNA_per_genome = reads_extracted_silva / (metagenome_size / (3500000/1550)))
silva_reads_comp = silva_reads_comp %>% mutate(reads_unclassified = reads_extracted_silva - reads_classified_silva) 
silva_reads_comp = silva_reads_comp[,c(1,2,5,3,4)]
silva_reads_comp$rRNA_per_genome = round(silva_reads_comp$rRNA_per_genome, 2)
colnames(silva_reads_comp) = c("Extracted Reads", "Classified Reads","Unclassified Reads" ,"Metagenome Size (Reads)", "Theoretical 16S rRNA per genome")
rownames(silva_reads_comp) = stats_graftm$Plant 

print(silva_reads_comp) 

silva_reads_comp_summary = data.frame(c(mean(silva_reads_comp$`Extracted Reads`), mean(silva_reads_comp$`Classified Reads`), mean(silva_reads_comp$`Unclassified Reads`), mean(silva_reads_comp$`Metagenome Size`), mean(silva_reads_comp$`Theoretical 16S rRNA per genome`)),c(sd(silva_reads_comp$`Extracted Reads`), sd(silva_reads_comp$`Classified Reads`), sd(silva_reads_comp$`Unclassified Reads`), sd(silva_reads_comp$`Metagenome Size`), sd(silva_reads_comp$`Theoretical 16S rRNA per genome`)))
print(silva_reads_comp_summary)
