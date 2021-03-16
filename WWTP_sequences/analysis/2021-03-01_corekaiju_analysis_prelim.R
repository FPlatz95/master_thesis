library(dplyr)

kaiju = read.csv("/srv/MA/Projects/microflora_danica/analysis/classified_kaiju/kaiju2table/20003FL-02-03-96_S568_L004_R1_001_summary.tsv", sep = "\t")
pfam = read.csv("/srv/MA/Projects/microflora_danica/analysis/classified_kaiju/core_kaiju/corekaiju2table/20003FL-02-03-96_S568_L004_corekaiju_summary.tsv", sep = "\t")

test = kaiju %>% 
  inner_join(pfam, by = "taxon_name", suffix = c("_kaiju", "_pfam"))


corekaiju_conversion = function(input_kaiju, input_pfam) {
  input_kaiju %>% 
    inner_join(input_pfam, by = c("taxon_id","taxon_name"),suffix=c("_kaiju","_pfam")) %>% 
    filter(reads_pfam > 20)%>%
    filter(is.na(taxon_id)!=T)%>%
    select(c("percent_kaiju","reads_kaiju","taxon_id","taxon_name"))
}

corekaiju = corekaiju_conversion(kaiju, pfam)




aale_corekaiju=aale_kaiju%>%
  inner_join(aale_pfam,by=c("taxon_id","taxon_name"),suffix=c("_kaiju","_pfam"))%>%
  filter(reads_pfam>20)%>%
  filter(is.na(taxon_id)!=T)%>%
  select(c("percent_kaiju","reads_kaiju","taxon_id","taxon_name"))


kaiju_nr_wwtp = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/output_nr/kaiju/summary/AalE_kaiju_summary.tsv", sep = "\t")
kaiju_refseq_wwtp = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/output_refseq/kaiju/summary/AalE_kaiju_summary.tsv", sep = "\t")
pfam_wwtp = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/output_nr/corekaiju/summary/AalE_corekaiju_summary.tsv", sep = "\t")

test_wwtp = kaiju_nr_wwtp %>% 
  inner_join(pfam_wwtp, by = "taxon_name", suffix = c("_kaiju", "_pfam")) %>% 
  filter(reads_pfam > 10)

test_wwtp2 = kaiju_refseq_wwtp %>% 
  inner_join(pfam_wwtp, by = "taxon_name", suffix = c("_kaiju", "_pfam"))

