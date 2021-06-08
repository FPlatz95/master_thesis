filename=commandArgs(trailingOnly = F)
otutable_raw=read.csv(filename[6],check.names = F)
colnames(otutable_raw)=sub("X","",colnames(otutable_raw))
colnames(otutable_raw)=gsub("\\.","-",colnames(otutable_raw))

maxl = length(otutable_raw)
otutable_raw = otutable_raw[,c(maxl,1,9:(maxl - 1),2:8)]

write.csv(otutable_raw,"/srv/MA/Projects/microflora_danica/analysis/classified_corekaiju_t5/corekaiju_t5_ampvis_combined_arranged.csv",row.names=F)
