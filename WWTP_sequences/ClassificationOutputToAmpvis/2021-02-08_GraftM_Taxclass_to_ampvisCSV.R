rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

######## PACKAGES #############


library(dplyr)
library(ampvis2)
library(readxl)
library(stringr)



######## FUNCTIONS ############


graftm_dir = "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/"

graftm_SILVA_aale_dir=paste0(graftm_dir,"AalE_16-Q3-R2-2_R1.fastq_SILVA/")
graftm_SILVA_bjer_dir=paste0(graftm_dir,"Bjer_16-Q3-R1-1_R1.fastq_SILVA/")
graftm_SILVA_kalu_dir=paste0(graftm_dir,"Kalu_16-Q3-R12-11_R1.fastq_SILVA/")

graftm_MIDAS_aale_dir=paste0(graftm_dir,"AalE_16-Q3-R2-2_R1.fastq_MIDAS/")
graftm_MIDAS_bjer_dir=paste0(graftm_dir,"Bjer_16-Q3-R1-1_R1.fastq_MIDAS/")
graftm_MIDAS_kalu_dir=paste0(graftm_dir,"Kalu_16-Q3-R12-11_R1.fastq_MIDAS/")


aale_graftm_SILVA=read.delim(paste0(graftm_SILVA_aale_dir,"combined_count_table.txt"),header=T)
bjer_graftm_SILVA=read.delim(paste0(graftm_SILVA_bjer_dir,"combined_count_table.txt"),header=T)
kalu_graftm_SILVA=read.delim(paste0(graftm_SILVA_kalu_dir,"combined_count_table.txt"),header=T)

aale_graftm_MIDAS=read.delim(paste0(graftm_MIDAS_aale_dir,"combined_count_table.txt"),header=T)
bjer_graftm_MIDAS=read.delim(paste0(graftm_MIDAS_bjer_dir,"combined_count_table.txt"),header=T)
kalu_graftm_MIDAS=read.delim(paste0(graftm_MIDAS_kalu_dir,"combined_count_table.txt"),header=T)


graftm_wwtpmerge=function(aale,bjer,kalu){
  full_join(aale,bjer,by=c("ConsensusLineage"),suffix=c("_aale","_bjer"))%>%
    full_join(kalu,by=c("ConsensusLineage"))%>%
    select(c(2,3,5,7))
}

graftm_SILVA_total=graftm_wwtpmerge(aale_graftm_SILVA,bjer_graftm_SILVA,kalu_graftm_SILVA)
graftm_MIDAS_total=graftm_wwtpmerge(aale_graftm_MIDAS,bjer_graftm_MIDAS,kalu_graftm_MIDAS)


graftm_SILVA_taxsplit=strsplit(as.character(graftm_SILVA_total$ConsensusLineage),";")
graftm_MIDAS_taxsplit=strsplit(as.character(graftm_MIDAS_total$ConsensusLineage),";")

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

graftm_SILVA_total_tax=graftm_inserttax(graftm_SILVA_total,graftm_SILVA_taxsplit)
graftm_MIDAS_total_tax=graftm_inserttax(graftm_MIDAS_total,graftm_MIDAS_taxsplit)



graftm_SILVA_convertotu=function(input){
  input%>%
    mutate(OTU=paste0("OTU",1:nrow(input),"_graftm_SILVA"))%>%
    select(c(12,1,3:11))
}

graftm_MIDAS_convertotu=function(input){
  input%>%
    mutate(OTU=paste0("OTU",1:nrow(input),"_graftm_MIDAS"))%>%
    select(c(12,1,3:11))
}


graftm_SILVA_otutable=graftm_SILVA_convertotu(graftm_SILVA_total_tax)
graftm_MIDAS_otutable=graftm_MIDAS_convertotu(graftm_MIDAS_total_tax)
graftm_MIDAS_otutable$Kingdom = str_replace(graftm_MIDAS_otutable$Kingdom, " k__", "")
graftm_MIDAS_otutable$Phylum = str_replace(graftm_MIDAS_otutable$Phylum, " p__", "")
graftm_MIDAS_otutable$Class = str_replace(graftm_MIDAS_otutable$Class, " c__", "")
graftm_MIDAS_otutable$Order = str_replace(graftm_MIDAS_otutable$Order, " o__", "")
graftm_MIDAS_otutable$Family = str_replace(graftm_MIDAS_otutable$Family, " f__", "")
graftm_MIDAS_otutable$Genus = str_replace(graftm_MIDAS_otutable$Genus, " g__", "")
graftm_MIDAS_otutable$Species = str_replace(graftm_MIDAS_otutable$Species, " s__", "")

graftM_OTUtable = graftm_SILVA_otutable %>% 
  full_join(graftm_MIDAS_otutable, by = c("Kingdom","Phylum","Class","Order","Family","Genus","Species", "OTU"), suffix = c("_SILVA", "_MIDAS"))

graftM_OTUtable = graftM_OTUtable[,c(1:4,12:14,5:11)]

write.csv(graftM_OTUtable,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/graftm_ampvis.csv", row.names = FALSE)

### Test for CSV file to ampvis ### 

rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

graftm_ampvis = amp_load(read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/graftm_ampvis.csv"))
amp_heatmap(graftm_ampvis, tax_empty = "remove")
