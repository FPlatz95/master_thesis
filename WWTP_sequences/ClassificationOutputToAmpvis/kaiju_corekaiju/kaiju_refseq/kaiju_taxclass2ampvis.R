library(dplyr)
library(stringr)

######## FUNCTIONS ############

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
  taxsplit=strsplit(as.character(input$taxon_name),";")
  data = insert_tax(input, taxsplit)
  output = data %>%
    mutate(suffix = "_kaiju") %>%
    mutate(OTU = paste0("OTU_", taxon_id, suffix)) %>%
    select(OTU,reads,Kingdom,Phylum,Class,Order,Family,Genus,Species) %>%
    filter(OTU != paste0("OTU_", "NA_","kaiju"))
}

filepath_load=commandArgs(trailingOnly = F)
filepath = filepath_load[6]
filename_split = as.vector(strsplit(filepath, "/"))
filename_split = unlist(filename_split)
filename_grep = grep("summary.tsv", filename_split, value = TRUE)
filename = gsub('_.*', "", filename_grep)

file = read.delim(filepath, header = T)

ampvis_otu = kaijutootutable(file)
ampvis_otu = ampvis_otu %>% rename(!!filename := reads)

write.csv(ampvis_otu, paste0("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/kaiju_refseq/ampvis_otu/",filename,"_refseq_ampvisotu.csv"), row.names = FALSE)
