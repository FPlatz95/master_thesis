library(dplyr)

GraftM_Midas_colnames = c("OTU","AalE_GraftM_Midas","AalW_GraftM_Midas","Aved_GraftM_Midas","Bjer_GraftM_Midas","Damh_GraftM_Midas","Ega_GraftM_Midas","Ejby_GraftM_Midas","EsbE_GraftM_Midas","EsbW_GraftM_Midas","Fred_GraftM_Midas","Hade_GraftM_Midas","Hirt_GraftM_Midas","Hjor_GraftM_Midas","Kalu_GraftM_Midas","Lyne_GraftM_Midas","Kingdom","Phylum","Class","Order","Family","Genus","Species")
GraftM_Midas = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/01_midas_combined_count/ampvis_otu/graftm_midas_combined_otu.csv")
colnames(GraftM_Midas) = GraftM_Midas_colnames
write.csv(GraftM_Midas, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/01_midas_combined_count/ampvis_otu/graftm_midas_combined_otu.csv", row.names = FALSE)

GraftM_Silva_colnames = c("OTU","AalE_GraftM_Silva","AalW_GraftM_Silva","Aved_GraftM_Silva","Bjer_GraftM_Silva","Damh_GraftM_Silva","Ega_GraftM_Silva","Ejby_GraftM_Silva","EsbE_GraftM_Silva","EsbW_GraftM_Silva","Fred_GraftM_Silva","Hade_GraftM_Silva","Hirt_GraftM_Silva","Hjor_GraftM_Silva","Kalu_GraftM_Silva","Lyne_GraftM_Silva","Kingdom","Phylum","Class","Order","Family","Genus","Species")
GraftM_Silva = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/02_silva_combined_count/ampvis_otu/graftm_silva_combined_otu.csv")
colnames(GraftM_Silva) = GraftM_Silva_colnames
write.csv(GraftM_Silva, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/02_silva_combined_count/ampvis_otu/graftm_silva_combined_otu.csv", row.names = FALSE)

SingleM_colnames = c("OTU","AalE_SingleM","AalW_SingleM","Aved_SingleM","Bjer_SingleM","Damh_SingleM","Ega_SingleM","Ejby_SingleM","EsbE_SingleM","EsbW_SingleM","Fred_SingleM","Hade_SingleM","Hirt_SingleM","Hjor_SingleM","Kalu_SingleM","Lyne_SingleM","Kingdom","Phylum","Class","Order","Family","Genus","Species")
SingleM = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/singleM/ampvis_otu/singlem_combined_otu.csv")
colnames(SingleM) = SingleM_colnames
write.csv(SingleM, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/singleM/ampvis_otu/singlem_combined_otu.csv", row.names = FALSE)

