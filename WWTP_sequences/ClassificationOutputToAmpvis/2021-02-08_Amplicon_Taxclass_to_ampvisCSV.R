rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

######## PACKAGES #############

library(dplyr)
library(ampvis2)
library(readxl)

#########

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


ampmetadata <- openxlsx::read.xlsx("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/MiDAS_metadata_2006-2018_updated_2019-09-27.xlsx", detectDates = TRUE)%>%
 filter(Year == 2016, Plant %in% c("Aalborg E", "Bjergmarken", "Kalundborg"), Period == "Summer")

amp_samples=gsub("-",".",ampmetadata$Sample)

asvpath="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/"

asvtab=read.delim(paste0(asvpath,"ASVtable.tsv"),sep="\t")%>%
 select(c(1,amp_samples))

asv_tax=read.delim(paste0(asvpath,"ASVs.R1.midas35.sintax"),sep="\t",header=F,stringsAsFactors = F)

asv_taxsplit=strsplit(asv_tax$V4,",")

asv_taxsplit2=sapply(asv_taxsplit, substring,3)

asv_tax2=insert_tax(asv_tax,asv_taxsplit2)

amp_otu=asvtab%>%
 inner_join(asv_tax2,by=c("X.OTU.ID"="V1"))%>%
 mutate(OTU=X.OTU.ID)%>%
 mutate(AalE_amplicon=MQ180319.64)%>%
 mutate(Bjer_amplicon=MQ180319.63)%>%
 mutate(Kalu_amplicon=MQ180319.73)

amp_otu=amp_otu%>%
 select(15:length(amp_otu),8:14)


write.csv(amp_otu,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/amplicon_ampvis.csv",row.names=F)


### Test for CSV file to ampvis ###

rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

amplicon_ampvis = amp_load(read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/amplicon_ampvis.csv"))
amp_heatmap(amplicon_ampvis, tax_empty = "remove")
