filename=commandArgs(trailingOnly = F)

library(dplyr)
library(ggplot2)


kaiju_combineotu=function(total,input){
  data=total%>%
    full_join(input,by=c("Kingdom","Phylum","Class","Order","Family","Genus","Species"),suffix=c("_x","_y"))%>%
    select(-OTU_x,-OTU_y)
  maxl=length(data)
  if (total$Kingdom[1]=="Dummy"){
    #print("DummyTrue")
    output=data%>%
      mutate(OTU=paste0("OTU",1:nrow(data),"_kaijiu"))%>%
      select(OTU,(ncol(data)),Kingdom,Phylum,Class,Order,Family,Genus,Species)%>%
      filter(Kingdom!="Dummy")
  }
  else{
    output=data%>%
      mutate(OTU=paste0("OTU",1:nrow(data),"_kaiju"))
  }
}
total_otu_table=read.csv("/srv/MA/Projects/microflora_danica/analysis/classified_kaiju/kaiju2table/ampvis_otu/kaiju_combined_otu.csv",header=T,stringsAsFactors = F)
file2=read.csv(filename[6],header=T,stringsAsFactors = F)
otu=kaiju_combineotu(total_otu_table,file2)
write.csv(otu,"/srv/MA/Projects/microflora_danica/analysis/classified_kaiju/kaiju2table/ampvis_otu/kaiju_combined_otu.csv",row.names=F)
