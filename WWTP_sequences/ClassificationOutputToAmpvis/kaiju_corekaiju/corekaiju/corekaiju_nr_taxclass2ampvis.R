library(dplyr)
library(stringr)



corekaiju=function(kaiju,pfam){
  kaiju%>%
    inner_join(pfam,by=c("taxon_id"),suffix=c("_kaiju","_pfam"))%>%
    filter(reads_pfam > 20) %>%
    select(c("file_kaiju", "percent_kaiju", "reads_kaiju", "taxon_id", "taxon_name_kaiju"))   
}


insert_tax=function(input,taxsplit){
  input%>%
    mutate(Kingdom=sapply(taxsplit,function(x) x[1]))%>%
    mutate(Phylum=sapply(taxsplit,function(x) x[2]))%>%
    mutate(Class=sapply(taxsplit,function(x) x[3]))%>%
    mutate(Order=sapply(taxsplit,function(x) x[4]))%>%
    mutate(Family=sapply(taxsplit,function(x) x[5]))%>%
    mutate(Genus=sapply(taxsplit,function(x) x[6]))%>%
    mutate(Species=sapply(taxsplit,function(x) x[7]))
}

kaijutootutable = function(input){
  taxsplit=strsplit(as.character(input$taxon_name_kaiju),";")
  data = insert_tax(input, taxsplit)
  output = data %>%
    mutate(suffix = "_kaiju") %>%
    mutate(OTU = paste0("OTU_", taxon_id, suffix)) %>%
    select(OTU,reads_kaiju,Kingdom,Phylum,Class,Order,Family,Genus,Species) %>%
    filter(OTU != paste0("OTU_", "NA_","kaiju"))
}

filepath_load=commandArgs(trailingOnly = F)
filepath = filepath_load[6]
filename_split = as.vector(strsplit(filepath, "/"))
filename_split = unlist(filename_split)
filename_grep = grep("summary.tsv", filename_split, value = TRUE)
filename = gsub('_.*', "", filename_grep)
corekaiju_filename = gsub("trimmed_.*", "", filename_grep)
kaiju_file = read.delim(filepath, header = TRUE)
corekaiju_file = read.delim(paste0("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/", corekaiju_filename, "trimmed_corekaiju_summary.tsv"), header = TRUE)

corekaiju = corekaiju(kaiju_file, corekaiju_file)

corekaiju_ampvis_otu = kaijutootutable(corekaiju)
corekaiju_ampvis_otu = corekaiju_ampvis_otu %>% rename(!!filename := reads_kaiju)

write.csv(corekaiju_ampvis_otu, paste0("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/nr_t20_ampvis_otu/",filename,"_corekaiju_nr_ampvisotu.csv"), row.names = FALSE)
