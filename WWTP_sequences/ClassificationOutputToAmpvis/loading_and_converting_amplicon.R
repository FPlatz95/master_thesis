rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console


library(dplyr)
library(ampvis2)
library(readxl)
library(stringr)

remove_prefix = function(input){
  input$Kingdom = str_replace(input$Kingdom, "k__", "")
  input$Phylum = str_replace(input$Phylum, "p__", "")
  input$Class = str_replace(input$Class, "c__", "")
  input$Order = str_replace(input$Order, "o__", "")
  input$Family = str_replace(input$Family, "f__", "")
  input$Genus = str_replace(input$Genus, "g__", "")
  input$Species = str_replace(input$Species, "s__", "")
  return(input)
}

inserttax = function(input){
  taxsplit = strsplit(as.character(input$Group.1),";")
  data = input %>%
    mutate(Kingdom=sapply(taxsplit,function(x) x[1])) %>%
    mutate(Phylum=sapply(taxsplit,function(x) x[2]))%>%
    mutate(Class=sapply(taxsplit,function(x) x[3]))%>%
    mutate(Order=sapply(taxsplit,function(x) x[4]))%>%
    mutate(Family=sapply(taxsplit,function(x) x[5]))%>%
    mutate(Genus=sapply(taxsplit,function(x) x[6]))%>%
    mutate(Species=sapply(taxsplit,function(x) x[7]))
  data$Kingdom = str_replace(data$Kingdom, "NA", "")
  data$Phylum = str_replace(data$Phylum, "NA", "")
  data$Class = str_replace(data$Class, "NA", "")
  data$Order = str_replace(data$Order, "NA", "")
  data$Family = str_replace(data$Family, "NA", "")
  data$Genus = str_replace(data$Genus, "NA", "")
  data$Species = str_replace(data$Species, "NA", "")
  return(data)
}

amplicon_convertotu=function(input){
  input %>%
    mutate(OTU=paste0("OTU",1:nrow(input),"_amplicon")) %>%
    select(c(10,2,3:9)) %>%
    filter(Kingdom %in% c("Bacteria", "Archaea"))
}

create_paste = function(input) {
  input$paste = paste(input$Kingdom, input$Phylum, input$Class, input$Order, input$Family, input$Genus, input$Species, sep = ";") 
  return(input)
}

mfd_metadata = read.csv("/srv/MA/Projects/microflora_danica/analysis/mfd_metadata/2020-11-10-14-47_mdf_metadata.csv")

amplicon_metadata = read_excel("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/MiDAS_metadata_2006-2018_updated_2019-09-27.xlsx")
amplicon_metadata_filtered = amplicon_metadata %>% filter(Year == 2016, Period == "Summer", !Plant %in% c("Boeslum","Mariagerfjord", "Odense NE", "Odense NW", "Randers", "Ribe", "Skive", "Viborg")) 
amplicon_otu = amp_import_usearch("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ASVtable.tsv", "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ASVs.R1.midas37.sintax")


amplicon_otu_aale = amplicon_otu[,c("OTU", "MQ180319-64","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(Aale_Amplicon_Midas = 'MQ180319-64') %>% filter(Aale_Amplicon_Midas > 0)
amplicon_otu_aale = remove_prefix(amplicon_otu_aale)
amplicon_otu_aale = create_paste(amplicon_otu_aale)
amplicon_otu_aale = aggregate(x = amplicon_otu_aale$Aale_Amplicon_Midas, by = list(amplicon_otu_aale$paste), FUN = sum) %>% rename(AalE_Amplicon_Midas = x)
amplicon_otu_aale = inserttax(amplicon_otu_aale)
amplicon_otu_aale = amplicon_convertotu(amplicon_otu_aale)
write.csv(amplicon_otu_aale, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/aale_amplicon.csv",row.names=F)

amplicon_otu_aalw = amplicon_otu[,c("OTU", "MQ180319-71","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(AalW_Amplicon_Midas = 'MQ180319-71') %>% filter(AalW_Amplicon_Midas > 0)
amplicon_otu_aalw = remove_prefix(amplicon_otu_aalw)
amplicon_otu_aalw = create_paste(amplicon_otu_aalw)
amplicon_otu_aalw = aggregate(x = amplicon_otu_aalw$AalW_Amplicon_Midas, by = list(amplicon_otu_aalw$paste), FUN = sum) %>% rename(AalW_Amplicon_Midas = x)
amplicon_otu_aalw = inserttax(amplicon_otu_aalw)
amplicon_otu_aalw = amplicon_convertotu(amplicon_otu_aalw)
write.csv(amplicon_otu_aalw, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/aalw_amplicon.csv",row.names=F)

amplicon_otu_aved = amplicon_otu[,c("OTU", "MQ180319-80","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(Aved_Amplicon_Midas = 'MQ180319-80') %>% filter(Aved_Amplicon_Midas > 0)
amplicon_otu_aved = remove_prefix(amplicon_otu_aved)
amplicon_otu_aved = create_paste(amplicon_otu_aved)
amplicon_otu_aved = aggregate(x = amplicon_otu_aved$Aved_Amplicon_Midas, by = list(amplicon_otu_aved$paste), FUN = sum) %>% rename(Aved_Amplicon_Midas = x)
amplicon_otu_aved = inserttax(amplicon_otu_aved)
amplicon_otu_aved = amplicon_convertotu(amplicon_otu_aved)
write.csv(amplicon_otu_aved, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/aved_amplicon.csv",row.names=F)

amplicon_otu_bjer = amplicon_otu[,c("OTU", "MQ180319-63","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(Bjer_Amplicon_Midas = 'MQ180319-63') %>% filter(Bjer_Amplicon_Midas > 0)
amplicon_otu_bjer = remove_prefix(amplicon_otu_bjer)
amplicon_otu_bjer = create_paste(amplicon_otu_bjer)
amplicon_otu_bjer = aggregate(x = amplicon_otu_bjer$Bjer_Amplicon_Midas, by = list(amplicon_otu_bjer$paste), FUN = sum) %>% rename(Bjer_Amplicon_Midas = x)
amplicon_otu_bjer = inserttax(amplicon_otu_bjer)
amplicon_otu_bjer = amplicon_convertotu(amplicon_otu_bjer)
write.csv(amplicon_otu_bjer, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/bjer_amplicon.csv",row.names=F)

amplicon_otu_damh = amplicon_otu[,c("OTU", "MQ180319-78","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(Damh_Amplicon_Midas = 'MQ180319-78') %>% filter(Damh_Amplicon_Midas > 0)
amplicon_otu_damh = remove_prefix(amplicon_otu_damh)
amplicon_otu_damh = create_paste(amplicon_otu_damh)
amplicon_otu_damh = aggregate(x = amplicon_otu_damh$Damh_Amplicon_Midas, by = list(amplicon_otu_damh$paste), FUN = sum) %>% rename(Damh_Amplicon_Midas = x)
amplicon_otu_damh = inserttax(amplicon_otu_damh)
amplicon_otu_damh = amplicon_convertotu(amplicon_otu_damh)
write.csv(amplicon_otu_damh, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/damh_amplicon.csv",row.names=F)

amplicon_otu_ega = amplicon_otu[,c("OTU", "MQ180319-67","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(Ega_Amplicon_Midas = 'MQ180319-67') %>% filter(Ega_Amplicon_Midas > 0)
amplicon_otu_ega = remove_prefix(amplicon_otu_ega)
amplicon_otu_ega = create_paste(amplicon_otu_ega)
amplicon_otu_ega = aggregate(x = amplicon_otu_ega$Ega_Amplicon_Midas, by = list(amplicon_otu_ega$paste), FUN = sum) %>% rename(Ega_Amplicon_Midas = x)
amplicon_otu_ega = inserttax(amplicon_otu_ega)
amplicon_otu_ega = amplicon_convertotu(amplicon_otu_ega)
write.csv(amplicon_otu_ega, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/ega_amplicon.csv",row.names=F)

amplicon_otu_ejby = amplicon_otu[,c("OTU", "MQ180319-68","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(Ejby_Amplicon_Midas = 'MQ180319-68') %>% filter(Ejby_Amplicon_Midas > 0)
amplicon_otu_ejby = remove_prefix(amplicon_otu_ejby)
amplicon_otu_ejby = create_paste(amplicon_otu_ejby)
amplicon_otu_ejby = aggregate(x = amplicon_otu_ejby$Ejby_Amplicon_Midas, by = list(amplicon_otu_ejby$paste), FUN = sum) %>% rename(Ejby_Amplicon_Midas = x)
amplicon_otu_ejby = inserttax(amplicon_otu_ejby)
amplicon_otu_ejby = amplicon_convertotu(amplicon_otu_ejby)
write.csv(amplicon_otu_ejby, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/ejby_amplicon.csv",row.names=F)

amplicon_otu_esbe = amplicon_otu[,c("OTU", "MQ180319-65","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(EsbE_Amplicon_Midas = 'MQ180319-65') %>% filter(EsbE_Amplicon_Midas > 0)
amplicon_otu_esbe = remove_prefix(amplicon_otu_esbe)
amplicon_otu_esbe = create_paste(amplicon_otu_esbe)
amplicon_otu_esbe = aggregate(x = amplicon_otu_esbe$EsbE_Amplicon_Midas, by = list(amplicon_otu_esbe$paste), FUN = sum) %>% rename(EsbE_Amplicon_Midas = x)
amplicon_otu_esbe = inserttax(amplicon_otu_esbe)
amplicon_otu_esbe = amplicon_convertotu(amplicon_otu_esbe)
write.csv(amplicon_otu_esbe, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/esbe_amplicon.csv",row.names=F)

amplicon_otu_esbw = amplicon_otu[,c("OTU", "MQ180319-66","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(EsbW_Amplicon_Midas = 'MQ180319-66') %>% filter(EsbW_Amplicon_Midas > 0)
amplicon_otu_esbw = remove_prefix(amplicon_otu_esbw)
amplicon_otu_esbw = create_paste(amplicon_otu_esbw)
amplicon_otu_esbw = aggregate(x = amplicon_otu_esbw$EsbW_Amplicon_Midas, by = list(amplicon_otu_esbw$paste), FUN = sum) %>% rename(EsbW_Amplicon_Midas = x)
amplicon_otu_esbw = inserttax(amplicon_otu_esbw)
amplicon_otu_esbw = amplicon_convertotu(amplicon_otu_esbw)
write.csv(amplicon_otu_esbw, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/esbw_amplicon.csv",row.names=F)

amplicon_otu_fred = amplicon_otu[,c("OTU", "MQ180319-82","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(Fred_Amplicon_Midas = 'MQ180319-82') %>% filter(Fred_Amplicon_Midas > 0)
amplicon_otu_fred = remove_prefix(amplicon_otu_fred)
amplicon_otu_fred = create_paste(amplicon_otu_fred)
amplicon_otu_fred = aggregate(x = amplicon_otu_fred$Fred_Amplicon_Midas, by = list(amplicon_otu_fred$paste), FUN = sum) %>% rename(Fred_Amplicon_Midas = x)
amplicon_otu_fred = inserttax(amplicon_otu_fred)
amplicon_otu_fred = amplicon_convertotu(amplicon_otu_fred)
write.csv(amplicon_otu_fred, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/fred_amplicon.csv",row.names=F)

amplicon_otu_hade = amplicon_otu[,c("OTU", "MQ180319-79","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(Hade_Amplicon_Midas = 'MQ180319-79') %>% filter(Hade_Amplicon_Midas > 0)
amplicon_otu_hade = remove_prefix(amplicon_otu_hade)
amplicon_otu_hade = create_paste(amplicon_otu_hade)
amplicon_otu_hade = aggregate(x = amplicon_otu_hade$Hade_Amplicon_Midas, by = list(amplicon_otu_hade$paste), FUN = sum) %>% rename(Hade_Amplicon_Midas = x)
amplicon_otu_hade = inserttax(amplicon_otu_hade)
amplicon_otu_hade = amplicon_convertotu(amplicon_otu_hade)
write.csv(amplicon_otu_hade, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/hade_amplicon.csv",row.names=F)

amplicon_otu_hirt = amplicon_otu[,c("OTU", "MQ180319-83","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(Hirt_Amplicon_Midas = 'MQ180319-83') %>% filter(Hirt_Amplicon_Midas > 0)
amplicon_otu_hirt = remove_prefix(amplicon_otu_hirt)
amplicon_otu_hirt = create_paste(amplicon_otu_hirt)
amplicon_otu_hirt = aggregate(x = amplicon_otu_hirt$Hirt_Amplicon_Midas, by = list(amplicon_otu_hirt$paste), FUN = sum) %>% rename(Hirt_Amplicon_Midas = x)
amplicon_otu_hirt = inserttax(amplicon_otu_hirt)
amplicon_otu_hirt = amplicon_convertotu(amplicon_otu_hirt)
write.csv(amplicon_otu_hirt, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/hirt_amplicon.csv",row.names=F)

amplicon_otu_hjor = amplicon_otu[,c("OTU", "MQ180319-69","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(Hjor_Amplicon_Midas = 'MQ180319-69') %>% filter(Hjor_Amplicon_Midas > 0)
amplicon_otu_hjor = remove_prefix(amplicon_otu_hjor)
amplicon_otu_hjor = create_paste(amplicon_otu_hjor)
amplicon_otu_hjor = aggregate(x = amplicon_otu_hjor$Hjor_Amplicon_Midas, by = list(amplicon_otu_hjor$paste), FUN = sum) %>% rename(Hjor_Amplicon_Midas = x)
amplicon_otu_hjor = inserttax(amplicon_otu_hjor)
amplicon_otu_hjor = amplicon_convertotu(amplicon_otu_hjor)
write.csv(amplicon_otu_hjor, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/hjor_amplicon.csv",row.names=F)

amplicon_otu_kalu = amplicon_otu[,c("OTU", "MQ180319-73","Kingdom","Phylum","Class","Order","Family","Genus","Species")] %>% rename(Kalu_Amplicon_Midas = 'MQ180319-73') %>% filter(Kalu_Amplicon_Midas > 0)
amplicon_otu_kalu = remove_prefix(amplicon_otu_kalu)
amplicon_otu_kalu = create_paste(amplicon_otu_kalu)
amplicon_otu_kalu = aggregate(x = amplicon_otu_kalu$Kalu_Amplicon_Midas, by = list(amplicon_otu_kalu$paste), FUN = sum) %>% rename(Kalu_Amplicon_Midas = x)
amplicon_otu_kalu = inserttax(amplicon_otu_kalu)
amplicon_otu_kalu = amplicon_convertotu(amplicon_otu_kalu)
write.csv(amplicon_otu_kalu, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/amplicon/ampvis_otu/kalu_amplicon.csv",row.names=F)
