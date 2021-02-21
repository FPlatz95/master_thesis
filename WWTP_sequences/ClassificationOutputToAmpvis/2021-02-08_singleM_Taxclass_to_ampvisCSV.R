library(dplyr)
library(stringr)
library(ampvis2)

singlem_dir="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/singleM/"

aale_singlem=read.delim(paste0(singlem_dir,"aalE_singleM_OTU.csv"),header=T)
bjer_singlem=read.delim(paste0(singlem_dir,"bjer_singleM_OTU.csv"),header=T)
kalu_singlem=read.delim(paste0(singlem_dir,"kalu_singleM_OTU.csv"),header=T)


aalE_singleM_trimmed_partial = aale_singlem %>% 
  select(c("num_hits","taxonomy")) %>% 
  rename(aalE_singleM = num_hits)


bjer_singleM_trimmed_partial = bjer_singlem %>% 
  select(c("num_hits","taxonomy")) %>% 
  rename(bjer_singleM = num_hits)


kalu_singleM_trimmed_partial = kalu_singlem %>% 
  select(c("num_hits","taxonomy")) %>% 
  rename(kalu_singleM = num_hits)



aalE_singleM_trimmed = aggregate(x = aalE_singleM_trimmed_partial$aalE_singleM, by = list(aalE_singleM_trimmed_partial$taxonomy), FUN = sum) %>% rename(aalborgE_singlem = x)

bjer_singleM_trimmed = aggregate(x = bjer_singleM_trimmed_partial$bjer_singleM, by = list(bjer_singleM_trimmed_partial$taxonomy), FUN = sum) %>% rename(bjergmarken_singlem = x)

kalu_singleM_trimmed = aggregate(x = kalu_singleM_trimmed_partial$kalu_singleM, by = list(kalu_singleM_trimmed_partial$taxonomy), FUN = sum) %>% rename(kalundborg_singlem = x)


singlem_wwtpmerge=function(aale,bjer,kalu){
  full_join(aale,bjer,by=c("Group.1"))%>%
    full_join(kalu,by=c("Group.1"))
}


total_singlem = singlem_wwtpmerge(aalE_singleM_trimmed, bjer_singleM_trimmed, kalu_singleM_trimmed)

taxsplit=strsplit(as.character(total_singlem$Group.1),";")

inserttax = function(input,taxsplit){
  input %>%
    mutate(Kingdom=sapply(taxsplit,function(x) x[2])) %>%
    mutate(Phylum=sapply(taxsplit,function(x) x[3]))%>%
    mutate(Class=sapply(taxsplit,function(x) x[4]))%>%
    mutate(Order=sapply(taxsplit,function(x) x[5]))%>%
    mutate(Family=sapply(taxsplit,function(x) x[6]))%>%
    mutate(Genus=sapply(taxsplit,function(x) x[7]))%>%
    mutate(Species=sapply(taxsplit,function(x) x[8]))
}

total_singlem_taxsplit = inserttax(total_singlem, taxsplit)
total_singlem_taxsplit$Kingdom = str_replace(total_singlem_taxsplit$Kingdom, " d__", "")
total_singlem_taxsplit$Phylum = str_replace(total_singlem_taxsplit$Phylum, " p__", "")
total_singlem_taxsplit$Class = str_replace(total_singlem_taxsplit$Class, " c__", "")
total_singlem_taxsplit$Order = str_replace(total_singlem_taxsplit$Order, " o__", "")
total_singlem_taxsplit$Family = str_replace(total_singlem_taxsplit$Family, " f__", "")
total_singlem_taxsplit$Genus = str_replace(total_singlem_taxsplit$Genus, " g__", "")
total_singlem_taxsplit$Species = str_replace(total_singlem_taxsplit$Species, " s__", "")

total_singlem_taxsplit = total_singlem_taxsplit %>% filter(Kingdom == "Bacteria")

singlem_convertotu=function(input){
  input %>%
    mutate(OTU=paste0("OTU",1:nrow(input),"_singlem"))%>%
    select(c(12,2:11))
}

singlem_OTU = singlem_convertotu(total_singlem_taxsplit)
write.csv(singlem_OTU, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/singleM/singlem_ampvisOTU.csv", row.names = FALSE)


### Test for CSV file to ampvis ###


rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

singleM_ampvis = amp_load(read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/singleM/singlem_ampvisOTU.csv"))
amp_heatmap(singleM_ampvis, tax_empty = "remove")
