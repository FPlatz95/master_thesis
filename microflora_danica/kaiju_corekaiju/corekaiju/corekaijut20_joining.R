filename=commandArgs(trailingOnly = F)

library(dplyr)
library(readr)

combineotu=function(total,input){
  data=total%>%
    full_join(input,by=c("Kingdom","Phylum","Class","Order","Family","Genus","Species"),suffix=c("_x","_y"))%>%
    select(-OTU_x,-OTU_y)
  maxl=length(data)
  if (total$Kingdom[1]=="Dummy"){
    #print("DummyTrue")
    output=data%>%
      mutate(OTU=paste0("OTU",1:nrow(data),"_corekaiju_t20"))%>% #Change this line
      select(OTU,(ncol(data)),Kingdom,Phylum,Class,Order,Family,Genus,Species)%>%
      filter(Kingdom!="Dummy")
  }
  else{
    output=data%>%
      mutate(OTU=paste0("OTU",1:nrow(data),"_corekaiju_t20")) #Change this line
  }
}

total_otu_table=read_csv("/srv/MA/Projects/microflora_danica/analysis/classified_corekaiju_t20/corekaiju_t20_ampvis_combined.csv") #Change this line
file2=read_csv(filename[6])
otu=combineotu(total_otu_table,file2)
write.csv(otu,"/srv/MA/Projects/microflora_danica/analysis/classified_corekaiju_t20/corekaiju_t20_ampvis_combined.csv",row.names=F) #Change this line
