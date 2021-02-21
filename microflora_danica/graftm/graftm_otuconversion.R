#rm(list=ls()) # Clear workspace
#graphics.off() # Clear plots
#cat("\014") # Clear console

filename=commandArgs(trailingOnly = F)
print(filename[6])

library(dplyr)
library(ggplot2)

# graftm_dir="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/"
# 
# graftm_aale_dir=paste0(graftm_dir,"AalE_graftM_SILVA_classification/")
# graftm_bjer_dir=paste0(graftm_dir,"Bjer_graftM_SILVA_classification/")
# graftm_kalu_dir=paste0(graftm_dir,"Kalu_graftM_SILVA_classification/")
# 
# aale_graftm=read.delim(paste0(graftm_aale_dir,"combined_count_table.txt"),header=T)
# bjer_graftm=read.delim(paste0(graftm_bjer_dir,"combined_count_table.txt"),header=T)
# kalu_graftm=read.delim(paste0(graftm_kalu_dir,"combined_count_table.txt"),header=T)

graftm_inserttax=function(input,taxsplit){
  input%>%
    mutate(Kingdom=sapply(taxsplit,function(x) x[2]))%>%
    mutate(Phylum=sapply(taxsplit,function(x) x[3]))%>%
    mutate(Class=sapply(taxsplit,function(x) x[4]))%>%
    mutate(Order=sapply(taxsplit,function(x) x[5]))%>%
    mutate(Family=sapply(taxsplit,function(x) x[6]))%>%
    mutate(Genus=sapply(taxsplit,function(x) x[7]))%>%
    mutate(Species=sapply(taxsplit,function(x) x[8]))%>%
    filter(Kingdom!="Eukaryota")
}

graftm_convertotu2=function(input){
  taxsplit=strsplit(as.character(input$ConsensusLineage),";")
  data=graftm_inserttax(input,taxsplit)
  output=data%>%
    mutate(OTU=paste0("OTU",1:nrow(data),"_graftm"))%>%
    select(c(11,2,4:10))
}
file2=read.delim(filename[6],header=T)
#print(file2)
otu=graftm_convertotu2(file2)
#print(otu)
write.csv(otu,paste0("ampvis_format/",filename[6],".csv"),row.names=F)
