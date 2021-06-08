library(dplyr)

#GraftM_Midas_colnames = c("OTU","AalE_GraftM_Midas","AalW_GraftM_Midas","Aved_GraftM_Midas","Bjer_GraftM_Midas","Damh_GraftM_Midas","Ega_GraftM_Midas","Ejby_GraftM_Midas","EsbE_GraftM_Midas","EsbW_GraftM_Midas","Fred_GraftM_Midas","Hade_GraftM_Midas","Hirt_GraftM_Midas","Hjor_GraftM_Midas","Kalu_GraftM_Midas","Lyne_GraftM_Midas","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#GraftM_Midas = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/01_midas_combined_count/ampvis_otu/graftm_midas_combined_otu.csv")
#colnames(GraftM_Midas) = GraftM_Midas_colnames
#write.csv(GraftM_Midas, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/01_midas_combined_count/ampvis_otu/graftm_midas_combined_otu.csv", row.names = FALSE)

#GraftM_Silva_colnames = c("OTU","AalE_GraftM_Silva","AalW_GraftM_Silva","Aved_GraftM_Silva","Bjer_GraftM_Silva","Damh_GraftM_Silva","Ega_GraftM_Silva","Ejby_GraftM_Silva","EsbE_GraftM_Silva","EsbW_GraftM_Silva","Fred_GraftM_Silva","Hade_GraftM_Silva","Hirt_GraftM_Silva","Hjor_GraftM_Silva","Kalu_GraftM_Silva","Lyne_GraftM_Silva","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#GraftM_Silva = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/02_silva_combined_count/ampvis_otu/graftm_silva_combined_otu.csv")
#colnames(GraftM_Silva) = GraftM_Silva_colnames
#write.csv(GraftM_Silva, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/02_silva_combined_count/ampvis_otu/graftm_silva_combined_otu.csv", row.names = FALSE)

#SingleM_colnames = c("OTU","AalE_SingleM","AalW_SingleM","Aved_SingleM","Bjer_SingleM","Damh_SingleM","Ega_SingleM","Ejby_SingleM","EsbE_SingleM","EsbW_SingleM","Fred_SingleM","Hade_SingleM","Hirt_SingleM","Hjor_SingleM","Kalu_SingleM","Lyne_SingleM","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#SingleM = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/singleM/ampvis_otu/singlem_combined_otu.csv")
#colnames(SingleM) = SingleM_colnames
#write.csv(SingleM, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/singleM/ampvis_otu/singlem_combined_otu.csv", row.names = FALSE)

#braken_bac_refseq_colnames = c("OTU","AalE_Bracken_Refseq","AalW_Bracken_Refseq","Aved_Bracken_Refseq","Bjer_Bracken_Refseq","Damh_Bracken_Refseq","Ega_Bracken_Refseq","Ejby_Bracken_Refseq","EsbE_Bracken_Refseq","EsbW_Bracken_Refseq","Fred_Bracken_Refseq","Hade_Bracken_Refseq","Hirt_Bracken_Refseq","Hjor_Bracken_Refseq","Kalu_Bracken_Refseq","Lyne_Bracken_Refseq","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#kraken_bac_refseq = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/bac_refseq/bracken_ampvis_otu/bracken_bac_refseq_combined.csv")
#colnames(kraken_bac_refseq) = kraken_bac_refseq_colnames
#write.csv(kraken_bac_refseq, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/bac_refseq/bracken_ampvis_otu/bracken_bac_refseq_combined.csv", row.names = FALSE)

#braken_bac_refseq_wwtp_colnames = #c("OTU","AalE_Bracken_Refseq_WWTP","AalW_Bracken_Refseq_WWTP","Aved_Bracken_Refseq_WWTP","Bjer_Bracken_Refseq_WWTP","Damh_Bracken_Refseq_WWTP","Ega_Bracken_Refseq_WWTP","Ejby_Bracken_Refseq_WWTP","EsbE_Bracken_Refseq_WWTP","EsbW_Bracken_Refseq_WWTP","Fred_Bracken_Refseq_WWTP","Hade_Bracken_Refseq_WWTP","Hirt_Bracken_Refseq_WWTP","Hjor_Bracken_Refseq_WWTP","Kalu_Bracken_Refseq_WWTP","Lyne_Bracken_Refseq_WWTP","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#kraken_bac_refseq_wwtp = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/bac_refseq_WWTP/bracken_ampvis_otu/bracken_bac_refseq_wwtp_combined.csv")
#colnames(kraken_bac_refseq_wwtp) = kraken_bac_refseq_wwtp_colnames
#write.csv(kraken_bac_refseq_wwtp,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/bac_refseq_WWTP/bracken_ampvis_otu/bracken_bac_refseq_wwtp_combined.csv", row.names = FALSE )

#braken_arc_refseq_colnames = c("OTU","AalE_Bracken_WWTP","AalW_Bracken_WWTP","Aved_Bracken_WWTP","Bjer_Bracken_WWTP","Damh_Bracken_WWTP","Ega_Bracken_WWTP","Ejby_Bracken_WWTP","EsbE_Bracken_WWTP","EsbW_Bracken_WWTP","Fred_Bracken_WWTP","Hade_Bracken_WWTP","Hirt_Bracken_WWTP","Hjor_Bracken_WWTP","Kalu_Bracken_WWTP","Lyne_Bracken_WWTP","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#kraken_arc_refseq = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/Arc_refseq_WWTP/bracken_ampvis_otu/bracken_arc_refseq_combined.csv")
#colnames(kraken_arc_refseq) = kraken_arc_refseq_colnames
#write.csv(kraken_arc_refseq, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/Arc_refseq_WWTP/bracken_ampvis_otu/bracken_arc_refseq_combined.csv", row.names = FALSE)

#braken_gtdb_colnames = c("OTU","AalE_Bracken_GTDB","AalW_Bracken_GTDB","Aved_Bracken_GTDB","Bjer_Bracken_GTDB","Damh_Bracken_GTDB","Ega_Bracken_GTDB","Ejby_Bracken_GTDB","EsbE_Bracken_GTDB","EsbW_Bracken_GTDB","Fred_Bracken_GTDB","Hade_Bracken_GTDB","Hirt_Bracken_GTDB","Hjor_Bracken_GTDB","Kalu_Bracken_GTDB","Lyne_Bracken_GTDB","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#kraken_gtdb = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/GTDB/bracken_ampvis_otu/bracken_gtdb_combined.csv")
#colnames(kraken_gtdb) = kraken_gtdb_colnames
#write.csv(kraken_gtdb, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/GTDB/bracken_ampvis_otu/bracken_gtdb_combined.csv", row.names = FALSE)

#kraken_bac_refseq_colnames = c("OTU","AalE_Kraken2_Refseq","AalW_Kraken2_Refseq","Aved_Kraken2_Refseq","Bjer_Kraken2_Refseq","Damh_Kraken2_Refseq","Ega_Kraken2_Refseq","Ejby_Kraken2_Refseq","EsbE_Kraken2_Refseq","EsbW_Kraken2_Refseq","Fred_Kraken2_Refseq","Hade_Kraken2_Refseq","Hirt_Kraken2_Refseq","Hjor_Kraken2_Refseq","Kalu_Kraken2_Refseq","Lyne_Kraken2_Refseq","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#kraken_bac_refseq = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/bac_refseq/kraken_ampvis_otu/kraken_bac_refseq_combined.csv")
#colnames(kraken_bac_refseq) = kraken_bac_refseq_colnames
#write.csv(kraken_bac_refseq, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/bac_refseq/kraken_ampvis_otu/kraken_bac_refseq_combined.csv", row.names = FALSE)

#kraken_bac_refseq_wwtp_colnames = c("OTU","AalE_Kraken2_Refseq_WWTP","AalW_Kraken2_Refseq_WWTP","Aved_Kraken2_Refseq_WWTP","Bjer_Kraken2_Refseq_WWTP","Damh_Kraken2_Refseq_WWTP","Ega_Kraken2_Refseq_WWTP","Ejby_Kraken2_Refseq_WWTP","EsbE_Kraken2_Refseq_WWTP","EsbW_Kraken2_Refseq_WWTP","Fred_Kraken2_Refseq_WWTP","Hade_Kraken2_Refseq_WWTP","Hirt_Kraken2_Refseq_WWTP","Hjor_Kraken2_Refseq_WWTP","Kalu_Kraken2_Refseq_WWTP","Lyne_Kraken2_Refseq_WWTP","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#kraken_bac_refseq_wwtp = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/bac_refseq_WWTP/kraken_ampvis_otu/kraken_bac_refseq_wwtp_combined.csv")
#colnames(kraken_bac_refseq_wwtp) = kraken_bac_refseq_wwtp_colnames
#write.csv(kraken_bac_refseq_wwtp,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/bac_refseq_WWTP/kraken_ampvis_otu/kraken_bac_refseq_wwtp_combined.csv", row.names = FALSE )

#kraken_arc_refseq_colnames = c("OTU","AalE_Kraken2_WWTP","AalW_Kraken2_WWTP","Aved_Kraken2_WWTP","Bjer_Kraken2_WWTP","Damh_Kraken2_WWTP","Ega_Kraken2_WWTP","Ejby_Kraken2_WWTP","EsbE_Kraken2_WWTP","EsbW_Kraken2_WWTP","Fred_Kraken2_WWTP","Hade_Kraken2_WWTP","Hirt_Kraken2_WWTP","Hjor_Kraken2_WWTP","Kalu_Kraken2_WWTP","Lyne_Kraken2_WWTP","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#kraken_arc_refseq = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/Arc_refseq_WWTP/kraken_ampvis_otu/kraken_arc_refseq_combined.csv")
#colnames(kraken_arc_refseq) = kraken_arc_refseq_colnames
#write.csv(kraken_arc_refseq, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/Arc_refseq_WWTP/kraken_ampvis_otu/kraken_arc_refseq_combined.csv", row.names = FALSE)

#kraken_gtdb_colnames = c("OTU","AalE_Kraken2_GTDB","AalW_Kraken2_GTDB","Aved_Kraken2_GTDB","Bjer_Kraken2_GTDB","Damh_Kraken2_GTDB","Ega_Kraken2_GTDB","Ejby_Kraken2_GTDB","EsbE_Kraken2_GTDB","EsbW_Kraken2_GTDB","Fred_Kraken2_GTDB","Hade_Kraken2_GTDB","Hirt_Kraken2_GTDB","Hjor_Kraken2_GTDB","Kalu_Kraken2_GTDB","Lyne_Kraken2_GTDB","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#kraken_gtdb = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/GTDB/kraken_ampvis_otu/kraken_gtdb_combined.csv")
#colnames(kraken_gtdb) = kraken_gtdb_colnames
#write.csv(kraken_gtdb, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/GTDB/kraken_ampvis_otu/kraken_gtdb_combined.csv", row.names = FALSE)

#corekaiju_nr_colnames = c("OTU","AalE_CoreKaiju_NR_t20","AalW_CoreKaiju_NR_t20","Aved_CoreKaiju_NR_t20","Bjer_CoreKaiju_NR_t20","Damh_CoreKaiju_NR_t20","Ega_CoreKaiju_NR_t20","Ejby_CoreKaiju_NR_t20","EsbE_CoreKaiju_NR_t20","EsbW_CoreKaiju_NR_t20","Fred_CoreKaiju_NR_t20","Hade_CoreKaiju_NR_t20","Hirt_CoreKaiju_NR_t20","Hjor_CoreKaiju_NR_t20","Kalu_CoreKaiju_NR_t20","Lyne_CoreKaiju_NR_t20","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#corekaiju_nr = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/nr_t20_ampvis_otu/corekaiju_nr_ampvis_combined.csv")
#colnames(corekaiju_nr) = corekaiju_nr_colnames
#write.csv(corekaiju_nr, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/nr_t20_ampvis_otu/corekaiju_nr_ampvis_combined.csv", row.names = FALSE)

#corekaiju_refseq_colnames = c("OTU","AalE_CoreKaiju_Refseq","AalW_CoreKaiju_Refseq","Aved_CoreKaiju_Refseq","Bjer_CoreKaiju_Refseq","Damh_CoreKaiju_Refseq","Ega_CoreKaiju_Refseq","Ejby_CoreKaiju_Refseq","EsbE_CoreKaiju_Refseq","EsbW_CoreKaiju_Refseq","Fred_CoreKaiju_Refseq","Hade_CoreKaiju_Refseq","Hirt_CoreKaiju_Refseq","Hjor_CoreKaiju_Refseq","Kalu_CoreKaiju_Refseq","Lyne_CoreKaiju_Refseq","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#corekaiju_refseq = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_ampvis_otu/corekaiju_refseq_ampvis_combined.csv")
#colnames( corekaiju_refseq) = corekaiju_refseq_colnames
#write.csv( corekaiju_refseq,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_ampvis_otu/corekaiju_refseq_ampvis_combined.csv", row.names = FALSE )

#kaiju_nr_colnames = c("OTU","AalE_Kaiju_NR","AalW_Kaiju_NR","Aved_Kaiju_NR","Bjer_Kaiju_NR","Damh_Kaiju_NR","Ega_Kaiju_NR","Ejby_Kaiju_NR","EsbE_Kaiju_NR","EsbW_Kaiju_NR","Fred_Kaiju_NR","Hade_Kaiju_NR","Hirt_Kaiju_NR","Hjor_Kaiju_NR","Kalu_Kaiju_NR","Lyne_Kaiju_NR","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#kaiju_nr = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/kaiju_nr/ampvis_otu/kaiju_nr_ampvis_combined.csv")
#colnames(kaiju_nr) = kaiju_nr_colnames
#write.csv(kaiju_nr, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/kaiju_nr/ampvis_otu/kaiju_nr_ampvis_combined.csv", row.names = FALSE)

#kaiju_refseq_colnames = c("OTU","AalE_Kaiju_Refseq","AalW_Kaiju_Refseq","Aved_Kaiju_Refseq","Bjer_Kaiju_Refseq","Damh_Kaiju_Refseq","Ega_Kaiju_Refseq","Ejby_Kaiju_Refseq","EsbE_Kaiju_Refseq","EsbW_Kaiju_Refseq","Fred_Kaiju_Refseq","Hade_Kaiju_Refseq","Hirt_Kaiju_Refseq","Hjor_Kaiju_Refseq","Kalu_Kaiju_Refseq","Lyne_Kaiju_Refseq","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#kaiju_refseq = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/kaiju_refseq/ampvis_otu/kaiju_refseq_ampvis_combined.csv")
#colnames(kaiju_refseq) = kaiju_refseq_colnames
#write.csv(kaiju_refseq, "/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/kaiju_refseq/ampvis_otu/kaiju_refseq_ampvis_combined.csv", row.names = FALSE)

#corekaiju_refseq_t5_colnames = c("OTU","AalE_CoreKaiju_Refseq_t5","AalW_CoreKaiju_Refseq_t5","Aved_CoreKaiju_Refseq_t5","Bjer_CoreKaiju_Refseq_t5","Damh_CoreKaiju_Refseq_t5","Ega_CoreKaiju_Refseq_t5","Ejby_CoreKaiju_Refseq_t5","EsbE_CoreKaiju_Refseq_t5","EsbW_CoreKaiju_Refseq_t5","Fred_CoreKaiju_Refseq_t5","Hade_CoreKaiju_Refseq_t5","Hirt_CoreKaiju_Refseq_t5","Hjor_CoreKaiju_Refseq_t5","Kalu_CoreKaiju_Refseq_t5","Lyne_CoreKaiju_Refseq_t5","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#corekaiju_refseq_t5 = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_t5_ampvis_otu/corekaiju_refseq_t5_ampvis_combined.csv")
#colnames(corekaiju_refseq_t5) = corekaiju_refseq_t5_colnames
#write.csv(corekaiju_refseq_t5,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_t5_ampvis_otu/corekaiju_refseq_t5_ampvis_combined.csv", row.names = FALSE )

#corekaiju_refseq_t10_colnames = c("OTU","AalE_CoreKaiju_Refseq_t10","AalW_CoreKaiju_Refseq_t10","Aved_CoreKaiju_Refseq_t10","Bjer_CoreKaiju_Refseq_t10","Damh_CoreKaiju_Refseq_t10","Ega_CoreKaiju_Refseq_t10","Ejby_CoreKaiju_Refseq_t10","EsbE_CoreKaiju_Refseq_t10","EsbW_CoreKaiju_Refseq_t10","Fred_CoreKaiju_Refseq_t10","Hade_CoreKaiju_Refseq_t10","Hirt_CoreKaiju_Refseq_t10","Hjor_CoreKaiju_Refseq_t10","Kalu_CoreKaiju_Refseq_t10","Lyne_CoreKaiju_Refseq_t10","Kingdom","Phylum","Class","Order","Family","Genus","Species")
#corekaiju_refseq_t10 = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_t10_ampvis_otu/corekaiju_refseq_t10_ampvis_combined.csv")
#colnames(corekaiju_refseq_t10) = corekaiju_refseq_t10_colnames
#write.csv(corekaiju_refseq_t10,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_t10_ampvis_otu/corekaiju_refseq_t10_ampvis_combined.csv", row.names = FALSE )

corekaiju_refseq_t20_colnames = c("OTU","AalE_CoreKaiju_Refseq_t20","AalW_CoreKaiju_Refseq_t20","Aved_CoreKaiju_Refseq_t20","Bjer_CoreKaiju_Refseq_t20","Damh_CoreKaiju_Refseq_t20","Ega_CoreKaiju_Refseq_t20","Ejby_CoreKaiju_Refseq_t20","EsbE_CoreKaiju_Refseq_t20","EsbW_CoreKaiju_Refseq_t20","Fred_CoreKaiju_Refseq_t20","Hade_CoreKaiju_Refseq_t20","Hirt_CoreKaiju_Refseq_t20","Hjor_CoreKaiju_Refseq_t20","Kalu_CoreKaiju_Refseq_t20","Lyne_CoreKaiju_Refseq_t20","Kingdom","Phylum","Class","Order","Family","Genus","Species")
corekaiju_refseq_t20 = read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_t20_ampvis_otu/corekaiju_refseq_t20_ampvis_combined.csv")
colnames(corekaiju_refseq_t20) = corekaiju_refseq_t20_colnames
write.csv(corekaiju_refseq_t20,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_t20_ampvis_otu/corekaiju_refseq_t20_ampvis_combined.csv", row.names = FALSE )
