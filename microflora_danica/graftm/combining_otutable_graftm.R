filename=commandArgs(trailingOnly = F)
print(filename[6])

library(dplyr)
library(ggplot2)

graftm_combineotu=function(total,input){
  data=total%>%
    full_join(input,by=c("Kingdom","Phylum","Class","Order","Family","Genus","Species"),suffix=c("_x","_y"))%>%
    select(-OTU_x,-OTU_y)
  maxl=length(data)
  if (total$Kingdom[1]=="Dummy"){
    #print("DummyTrue")
    output=data%>%
      mutate(OTU=paste0("OTU",1:nrow(data),"_graftm"))%>%
      select(OTU,(ncol(data)),Kingdom,Phylum,Class,Order,Family,Genus,Species)%>%
      filter(Kingdom!="Dummy")%>%
      filter(Kingdom!=" Eukaryota")
  }
  else{
    output=data%>%
      mutate(OTU=paste0("OTU",1:nrow(data),"_graftm"))%>%
      select(OTU,1:(maxl-8),(maxl),Kingdom,Phylum,Class,Order,Family,Genus,Species)%>%
      filter(Kingdom!=" Eukaryota")
  }
}
total_otu_table=read.csv("graftm_combined_otu.csv",header=T,stringsAsFactors = F)
#print(total_otu_table)
file2=read.csv(filename[6],header=T,stringsAsFactors = F)
#print(file2)
otu=graftm_combineotu(total_otu_table,file2)
#print(otu)
write.csv(otu,"kaiju_combined_otu.csv",row.names=F)
