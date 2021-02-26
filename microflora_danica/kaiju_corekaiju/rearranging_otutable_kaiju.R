otutable_raw=read.csv("/srv/MA/Projects/microflora_danica/analysis/classified_kaiju/kaiju2table/ampvis_otu/kaiju_combined_otu.csv",check.names = F)
colnames(otutable_raw)=sub("X","",colnames(otutable_raw))
colnames(otutable_raw)=gsub("\\.","-",colnames(otutable_raw))

maxl = length(otutable_raw)
otutable_raw = otutable_raw[,c(maxl,1,9:(maxl - 1),2:8)]

write.csv(otutable_raw,"/srv/MA/Projects/microflora_danica/analysis/classified_kaiju/kaiju2table/ampvis_otu/kaiju_combined_otu.csv",row.names=F)

#"X20003FL.02.01.01","Kingdom","Phylum","Class","Order","Family","Genus","Species","X20003FL.02.01.02","X20003FL.02.01.03","X20003FL.02.01.04","X20003FL.02.01.05","OTU"
