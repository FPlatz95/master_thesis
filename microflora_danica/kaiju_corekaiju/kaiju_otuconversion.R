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
    filter(OTU != paste0("OTU_", "aale_","NA"))
}


write.csv(otu_kaiju,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/output_nr/kaiju_coreKaiju_variableDB_ampvis.csv", row.names = FALSE)
