filename=commandArgs(trailingOnly = F)

library(dplyr)



combineotu=function(total,input){
  data=total%>%
    full_join(input,by=c("Kingdom","Phylum","Class","Order","Family","Genus","Species"),suffix=c("_x","_y"))%>%
    select(-OTU_x,-OTU_y)
  maxl=length(data)
  if (total$Kingdom[1]=="Dummy"){
    #print("DummyTrue")
    output=data%>%
      mutate(OTU=paste0("OTU",1:nrow(data),"_graftm_midas"))%>% #Change this line
      select(OTU,(ncol(data)),Kingdom,Phylum,Class,Order,Family,Genus,Species)%>%
      filter(Kingdom!="Dummy")
  }
  else{
    output=data%>%
      mutate(OTU=paste0("OTU",1:nrow(data),"_graftm_midas")) #Change this line
  }
}

total_otu_table=read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/01_midas_combined_count/ampvis_otu/graftm_midas_combined_otu.csv",header=T,stringsAsFactors = F) #Change this line
file2=read.csv(filename[6],header=T,stringsAsFactors = F)
otu=combineotu(total_otu_table,file2)
write.csv(otu,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/01_midas_combined_count/ampvis_otu/graftm_midas_combined_otu.csv",row.names=F) #Change this line
