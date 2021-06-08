library(dplyr)
library(stringr)

graftm_inserttax=function(input,taxsplit){
  input%>%
    mutate(Kingdom=sapply(taxsplit,function(x) x[2]))%>%
    mutate(Phylum=sapply(taxsplit,function(x) x[3]))%>%
    mutate(Class=sapply(taxsplit,function(x) x[4]))%>%
    mutate(Order=sapply(taxsplit,function(x) x[5]))%>%
    mutate(Family=sapply(taxsplit,function(x) x[6]))%>%
    mutate(Genus=sapply(taxsplit,function(x) x[7]))%>%
    mutate(Species=sapply(taxsplit,function(x) x[8]))%>%
    filter(Kingdom!=" Eukaryota")
}

graftm_convertotu2=function(input){
  taxsplit=strsplit(as.character(input$ConsensusLineage),";")
  data=graftm_inserttax(input,taxsplit)
  output=data%>%
    mutate(OTU=paste0("OTU",1:nrow(data),"_graftm"))%>%
    select(c(11,2,4:10))
}

filepath_load=commandArgs(trailingOnly = F)
filepath = filepath_load[6]
filename_split = as.vector(strsplit(filepath, "/"))
filename_split = unlist(filename_split)
filename_grep = grep("table.txt", filename_split, value = TRUE)
filename = gsub('_.*', "", filename_grep)

file2=read.delim(filepath,header=T)
#print(file2)
graftm_otu=graftm_convertotu2(file2)

graftm_otu$Kingdom = str_trim(graftm_otu$Kingdom)
graftm_otu$Phylum = str_trim(graftm_otu$Phylum)
graftm_otu$Class = str_trim(graftm_otu$Class)
graftm_otu$Order = str_trim(graftm_otu$Order)
graftm_otu$Family = str_trim(graftm_otu$Family)
graftm_otu$Genus = str_trim(graftm_otu$Genus)
graftm_otu$Species = str_trim(graftm_otu$Species)

write.csv(graftm_otu,paste0("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/02_silva_combined_count/ampvis_otu/", filename, "_silva_graftm.csv"), row.names=F)
