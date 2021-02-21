rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

######## PACKAGES #############


library(dplyr)
library(ampvis2)
library(readxl)
library(stringr)



######## FUNCTIONS ############

gtdb_formatted = function(test) {
  m1 = c()
  for(i in 1:nrow(test)) {
    if(test[i,4] == test[max(nrow(test)),4]){
      m1[i] = test[i,3]
    }
    else if(test[i+1,4] == "S1") {
      m1[i] = test[i+1,3] + test[i,3]
    }
    else if (test[i+1,4] != "S1") {
      m1[i] = test[i,3]
    } 
    else if(test[i,4] == test[min(nrow(test)),4]){
      m1[i] = test[i,3]
    }
    else{
      NULL
    }
  }
  test$V3 = m1
  test = test
}



kraken_convert_new=function(input,list){
  data=input
  data$V6=trimws(data$V6,which="left",whitespace = " ")
  taxtab=unique(data$V4)
  taxrm=c("1","2","3","4","5","6","7","8","9","K")
  taxtab2=taxtab[grepl(paste0(taxrm,collapse="|"),taxtab)]
  for (i in taxtab2){
    data[grepl(i,data[,4]),4]=NA
  }
  tax=c("D","P","C","O","F","G","S")
  taxcol=c("Kingdom","Phylum","Class","Order","Family","Genus","Species")
  filter(data,is.na(V4)==F)
  for (i in 1:length(tax)){
    colname=taxcol[i]
    data=data%>%
      mutate("{colname}":=as.character(V6))
    if(i==length(tax)){
      data[!grepl(tax[i],data[,4]),(i+6)]=NA
    }
    else{
      data[!grepl(tax[i],data[,4]),(i+6)]=""
    }
  }
  
  
  
  data=data%>%
    filter(is.na(V4)==F)
  for (i in 1:(length(tax)-1)){
    data[grepl(tax[i],data[,4]),(i+7):13]=NA
  }
  
  
  #kraken_na_norank(data,list)
  for (k in list[,1]){
    data[data[,5]==k,7:13]=list[list[,1]==k,2:8]
  }
  
  data[grepl("U|R",data[,4]),7:13]=NA
  data=kraken_fillempty(data)
  return(data)
}

kraken_wwtpmerge=function(aale,bjer,kalu){
  full_join(aale,bjer,by=c("V5","V6","Kingdom","Phylum","Class","Order","Family","Genus","Species"),suffix=c("_aale","_bjer"))%>%
    full_join(kalu,by=c("V5","V6","Kingdom","Phylum","Class","Order","Family","Genus","Species"))%>%
    mutate(aale_kraken2=V3_aale)%>%
    mutate(bjer_kraken2=V3_bjer)%>%
    mutate(kalu_kraken2=V3)
}


kraken_convertotu=function(input, name = "_kraken"){
  output=input%>%
    mutate(OTU=paste0("OTU",V5,name))%>%
    select(c(25,22:24,7:13))
  output=output[-1:-2,]
  return(output)
}



kraken_fillempty=function(data){
  maxl=max(length(data))
  for (i in 7:(maxl-1)){
    while(length(ind <- which(data[i] == "")) > 0){
      data[ind,i] <- data[ind-1,i]
    }
  }
  return(data)
}

######## VARIABLES ############

#Directories
norankpath="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/"
kraken2_bac_refseq_dir="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/bac_refseq/"
kraken2_bac_refseq_WWTP_dir="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/bac_refseq_WWTP/"
kraken2_arc_refseq_WWTP_dir="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/Arc_refseq_WWTP/"

#No rank list
noranklist=read.csv(paste0(norankpath,"noranklist_corrected.csv"),stringsAsFactors = F)

#Kraken2 bac_refseq reports
aale_kraken2_bac_refseq=read.delim(paste0(kraken2_bac_refseq_dir,"AalE_bac_refseq_kraken2.report"),sep="\t",header=F)
bjer_kraken2_bac_refseq=read.delim(paste0(kraken2_bac_refseq_dir,"Bjer_bac_refseq_kraken2.report"),sep="\t",header=F)
kalu_kraken2_bac_refseq=read.delim(paste0(kraken2_bac_refseq_dir,"Kalu_bac_refseq_kraken2.report"),sep="\t",header=F)

#Kraken2 bac_refseq_WWTP reports
aale_kraken2_bac_refseq_WWTP=read.delim(paste0(kraken2_bac_refseq_WWTP_dir,"AalE_bac_refseq_WWTP_kraken2.report"),sep="\t",header=F)
bjer_kraken2_bac_refseq_WWTP=read.delim(paste0(kraken2_bac_refseq_WWTP_dir,"Bjer_bac_refseq_WWTP_kraken2.report"),sep="\t",header=F)
kalu_kraken2_bac_refseq_WWTP=read.delim(paste0(kraken2_bac_refseq_WWTP_dir,"Kalu_bac_refseq_WWTP_kraken2.report"),sep="\t",header=F)

#Kraken2 arc_refseq_WWTP reports
aale_kraken2_arc_refseq_WWTP=read.delim(paste0(kraken2_arc_refseq_WWTP_dir,"AalE_arc_refseq_WWTP_kraken2.report"),sep="\t",header=F)
bjer_kraken2_arc_refseq_WWTP=read.delim(paste0(kraken2_arc_refseq_WWTP_dir,"Bjer_arc_refseq_WWTP_kraken2.report"),sep="\t",header=F)
kalu_kraken2_arc_refseq_WWTP=read.delim(paste0(kraken2_arc_refseq_WWTP_dir,"Kalu_arc_refseq_WWTP_kraken2.report"),sep="\t",header=F)

#Kraken2 GTDB reports
aale_kraken2_gtdb = read.delim("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/GTDB/AalE_GTDB_WWTP_kraken2.report",sep="\t",header=F)
bjer_kraken2_gtdb = read.delim("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/GTDB/Bjer_GTDB_WWTP_kraken2.report",sep="\t",header=F)
kalu_kraken2_gtdb = read.delim("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/GTDB/Kalu_GTDB_WWTP_kraken2.report",sep="\t",header=F)


#Kraken2 bac_refsea converted
aale_kraken2_bac_refseq_tax=kraken_convert_new(aale_kraken2_bac_refseq,noranklist)
bjer_kraken2_bac_refseq_tax=kraken_convert_new(bjer_kraken2_bac_refseq,noranklist)
kalu_kraken2_bac_refseq_tax=kraken_convert_new(kalu_kraken2_bac_refseq,noranklist)


#Kraken2 bac_refseq_WWTP converted
aale_kraken2_bac_refseq_WWTP_tax=kraken_convert_new(aale_kraken2_bac_refseq_WWTP, noranklist)
bjer_kraken2_bac_refseq_WWTP_tax=kraken_convert_new(bjer_kraken2_bac_refseq_WWTP, noranklist)
kalu_kraken2_bac_refseq_WWTP_tax=kraken_convert_new(kalu_kraken2_bac_refseq_WWTP, noranklist)

#Kraken2 arc_refseq_WWTP converted
aale_kraken2_arc_refseq_WWTP_tax=kraken_convert_new(aale_kraken2_arc_refseq_WWTP, noranklist)
bjer_kraken2_arc_refseq_WWTP_tax=kraken_convert_new(bjer_kraken2_arc_refseq_WWTP, noranklist)
kalu_kraken2_arc_refseq_WWTP_tax=kraken_convert_new(kalu_kraken2_arc_refseq_WWTP, noranklist)


#Kraken2 GTDB converted 
aale_kraken2_gtdb_formatted = gtdb_formatted(aale_kraken2_gtdb)
bjer_kraken2_gtdb_formatted = gtdb_formatted(bjer_kraken2_gtdb)
kalu_kraken2_gtdb_formatted = gtdb_formatted(kalu_kraken2_gtdb)

aale_kraken2_gtdb_tax=kraken_convert_new(aale_kraken2_gtdb_formatted,noranklist)
bjer_kraken2_gtdb_tax=kraken_convert_new(bjer_kraken2_gtdb_formatted,noranklist)
kalu_kraken2_gtdb_tax=kraken_convert_new(kalu_kraken2_gtdb_formatted,noranklist)


#Kraken2 bac_refseq merged and OTU table
kraken_bac_refseq_merge=kraken_wwtpmerge(aale_kraken2_bac_refseq_tax,bjer_kraken2_bac_refseq_tax,kalu_kraken2_bac_refseq_tax)
kraken_bac_refseq_otu=kraken_convertotu(kraken_bac_refseq_merge, name = "_kraken_bac_refseq")
kraken_bac_refseq_otu = kraken_bac_refseq_otu %>% 
  rename(
    aale_kraken2_bac_refseq = aale_kraken2,
    bjer_kraken2_bac_refseq = bjer_kraken2,
    kalu_kraken2_bac_refseq = kalu_kraken2
  )

#Kraken2 bac_refseq_WWTP merged and OTU table
kraken_bac_refseq_WWTP_merge=kraken_wwtpmerge(aale_kraken2_bac_refseq_WWTP_tax,bjer_kraken2_bac_refseq_WWTP_tax,kalu_kraken2_bac_refseq_WWTP_tax)
kraken_bac_refseq_WWTP_otu=kraken_convertotu(kraken_bac_refseq_WWTP_merge, name = "_kraken_bac_refseq_WWTP")
kraken_bac_refseq_WWTP_otu = kraken_bac_refseq_WWTP_otu %>% 
  rename(
    aale_kraken2_bac_WWTP_refseq = aale_kraken2,
    bjer_kraken2_bac_WWTP_refseq = bjer_kraken2,
    kalu_kraken2_bac_WWTP_refseq = kalu_kraken2
  )

#Kraken2 arc_refseq_WWTP merged and OTU table
kraken_arc_refseq_WWTP_merge=kraken_wwtpmerge(aale_kraken2_arc_refseq_WWTP_tax,bjer_kraken2_arc_refseq_WWTP_tax,kalu_kraken2_arc_refseq_WWTP_tax)
kraken_arc_refseq_WWTP_otu=kraken_convertotu(kraken_arc_refseq_WWTP_merge, name = "_kraken_arc_refseq_WWTP")
kraken_arc_refseq_WWTP_otu = kraken_arc_refseq_WWTP_otu %>% 
  rename(
    aale_kraken2_arc_WWTP_refseq = aale_kraken2,
    bjer_kraken2_arc_WWTP_refseq = bjer_kraken2,
    kalu_kraken2_arc_WWTP_refseq = kalu_kraken2
  )

#Kraken2 GTDB merged and OTU table
kraken_GTDB_merge=kraken_wwtpmerge(aale_kraken2_gtdb_tax,bjer_kraken2_gtdb_tax,kalu_kraken2_gtdb_tax)
kraken_GTDB_otu=kraken_convertotu(kraken_GTDB_merge, name = "_kraken_GTDB")
kraken_GTDB_otu = kraken_GTDB_otu %>% 
  rename(
    aale_kraken2_GTDB = aale_kraken2,
    bjer_kraken2_GTDB = bjer_kraken2,
    kalu_kraken2_GTDB = kalu_kraken2
  )

kraken_GTDB_otu$Kingdom = str_replace(kraken_GTDB_otu$Kingdom, "d__", "")
kraken_GTDB_otu$Phylum = str_replace(kraken_GTDB_otu$Phylum, "p__", "")
kraken_GTDB_otu$Class = str_replace(kraken_GTDB_otu$Class, "c__", "")
kraken_GTDB_otu$Order = str_replace(kraken_GTDB_otu$Order, "o__", "")
kraken_GTDB_otu$Family = str_replace(kraken_GTDB_otu$Family, "f__", "")
kraken_GTDB_otu$Genus = str_replace(kraken_GTDB_otu$Genus, "g__", "")
kraken_GTDB_otu$Species = str_replace(kraken_GTDB_otu$Species, "s__", "")

#Kraken2 bac_refseq remove duplicates and viruses
kraken_bac_refseq_otu_clean = kraken_bac_refseq_otu[!duplicated(kraken_bac_refseq_otu$OTU),]
kraken_bac_refseq_otu_clean1 = kraken_bac_refseq_otu_clean[kraken_bac_refseq_otu_clean$Kingdom != "Viruses",]


#Kraken2 bac_refseq_WWTP remove duplicates and viruses
kraken_bac_refseq_WWTP_otu_clean = kraken_bac_refseq_WWTP_otu[!duplicated(kraken_bac_refseq_WWTP_otu$OTU),]
kraken_bac_refseq_WWTP_otu_clean1 = kraken_bac_refseq_WWTP_otu_clean[kraken_bac_refseq_WWTP_otu_clean$Kingdom != "Viruses",]


#Kraken2 arc_refseq_WWTP remove duplicates and viruses
kraken_arc_refseq_WWTP_otu_clean = kraken_arc_refseq_WWTP_otu[!duplicated(kraken_arc_refseq_WWTP_otu$OTU),]
kraken_arc_refseq_WWTP_otu_clean1 = kraken_arc_refseq_WWTP_otu_clean[kraken_arc_refseq_WWTP_otu_clean$Kingdom != "Viruses",]


#Kraken2 GTDB remove duplicates and viruses 
kraken_GTDB_otu_clean = kraken_GTDB_otu[!duplicated(kraken_GTDB_otu$OTU),]
kraken_GTDB_otu_clean1 = kraken_GTDB_otu_clean[kraken_GTDB_otu_clean$Kingdom != "Viruses",]


### Merging Tables ### 
merged_OTU = kraken_bac_refseq_otu_clean1 %>%
  full_join(kraken_bac_refseq_WWTP_otu_clean1, by=c("OTU","Kingdom","Phylum","Class","Order","Family","Genus","Species")) %>% 
  full_join(kraken_arc_refseq_WWTP_otu_clean1, by=c("OTU","Kingdom","Phylum","Class","Order","Family","Genus","Species")) %>% 
  full_join(kraken_GTDB_otu_clean1, by=c("OTU","Kingdom","Phylum","Class","Order","Family","Genus","Species"))
merged_OTU = merged_OTU[,c(1,2,3,4,12,13,14,15,16,17,18,19,20,5,6,7,8,9,10,11)]
write.csv(merged_OTU,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/kraken2_variableDB_ampvis.csv", row.names = FALSE)

### Test for CSV file to ampvis ### 
rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

kraken2_ampvis = amp_load(read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/kraken2_variableDB_ampvis.csv"))
amp_heatmap(kraken2_ampvis, tax_empty = "remove")
