rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

######## PACKAGES #############


library(dplyr)
library(ampvis2)
library(readxl)
library(stringr)



######## FUNCTIONS ############

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
bracken_bac_refseq_dir="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/bracken/bac_refseq/"
bracken_bac_refseq_WWTP_dir="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/bracken/bac_refseq_WWTP/"
bracken_arc_refseq_WWTP_dir="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/bracken/Arc_refseq_WWTP/"

#No rank list
noranklist=read.csv(paste0(norankpath,"noranklist_corrected.csv"),stringsAsFactors = F)

#bracken bac_refseq reports
aale_bracken_bac_refseq=read.delim(paste0(bracken_bac_refseq_dir,"AalE_bac_refseq_kraken2_bracken_species.report"),sep="\t",header=F)
bjer_bracken_bac_refseq=read.delim(paste0(bracken_bac_refseq_dir,"Bjer_bac_refseq_kraken2_bracken_species.report"),sep="\t",header=F)
kalu_bracken_bac_refseq=read.delim(paste0(bracken_bac_refseq_dir,"Kalu_bac_refseq_kraken2_bracken_species.report"),sep="\t",header=F)

#bracken bac_refseq_WWTP reports
aale_bracken_bac_refseq_WWTP=read.delim(paste0(bracken_bac_refseq_WWTP_dir,"AalE_bac_refseq_WWTP_kraken2_bracken_species.report"),sep="\t",header=F)
bjer_bracken_bac_refseq_WWTP=read.delim(paste0(bracken_bac_refseq_WWTP_dir,"Bjer_bac_refseq_WWTP_kraken2_bracken_species.report"),sep="\t",header=F)
kalu_bracken_bac_refseq_WWTP=read.delim(paste0(bracken_bac_refseq_WWTP_dir,"Kalu_bac_refseq_WWTP_kraken2_bracken_species.report"),sep="\t",header=F)

#bracken arc_refseq_WWTP reports
aale_bracken_arc_refseq_WWTP=read.delim(paste0(bracken_arc_refseq_WWTP_dir,"AalE_arc_refseq_WWTP_kraken2_bracken_species.report"),sep="\t",header=F)
bjer_bracken_arc_refseq_WWTP=read.delim(paste0(bracken_arc_refseq_WWTP_dir,"Bjer_arc_refseq_WWTP_kraken2_bracken_species.report"),sep="\t",header=F)
kalu_bracken_arc_refseq_WWTP=read.delim(paste0(bracken_arc_refseq_WWTP_dir,"Kalu_arc_refseq_WWTP_kraken2_bracken_species.report"),sep="\t",header=F)


#bracken bac_refsea converted
aale_bracken_bac_refseq_tax=kraken_convert_new(aale_bracken_bac_refseq,noranklist)
bjer_bracken_bac_refseq_tax=kraken_convert_new(bjer_bracken_bac_refseq,noranklist)
kalu_bracken_bac_refseq_tax=kraken_convert_new(kalu_bracken_bac_refseq,noranklist)


#bracken bac_refseq_WWTP converted
aale_bracken_bac_refseq_WWTP_tax=kraken_convert_new(aale_bracken_bac_refseq_WWTP, noranklist)
bjer_bracken_bac_refseq_WWTP_tax=kraken_convert_new(bjer_bracken_bac_refseq_WWTP, noranklist)
kalu_bracken_bac_refseq_WWTP_tax=kraken_convert_new(kalu_bracken_bac_refseq_WWTP, noranklist)

#bracken arc_refseq_WWTP converted
aale_bracken_arc_refseq_WWTP_tax=kraken_convert_new(aale_bracken_arc_refseq_WWTP, noranklist)
bjer_bracken_arc_refseq_WWTP_tax=kraken_convert_new(bjer_bracken_arc_refseq_WWTP, noranklist)
kalu_bracken_arc_refseq_WWTP_tax=kraken_convert_new(kalu_bracken_arc_refseq_WWTP, noranklist)


#bracken bac_refseq merged and OTU table
bracken_bac_refseq_merge=kraken_wwtpmerge(aale_bracken_bac_refseq_tax,bjer_bracken_bac_refseq_tax,kalu_bracken_bac_refseq_tax)
bracken_bac_refseq_otu=kraken_convertotu(bracken_bac_refseq_merge, name = "_bracken_bac_refseq")
bracken_bac_refseq_otu = bracken_bac_refseq_otu %>% 
  rename(
    aale_bracken_bac_refseq = aale_kraken2,
    bjer_bracken_bac_refseq = bjer_kraken2,
    kalu_bracken_bac_refseq = kalu_kraken2
  )

#bracken bac_refseq_WWTP merged and OTU table
bracken_bac_refseq_WWTP_merge=kraken_wwtpmerge(aale_bracken_bac_refseq_WWTP_tax,bjer_bracken_bac_refseq_WWTP_tax,kalu_bracken_bac_refseq_WWTP_tax)
bracken_bac_refseq_WWTP_otu=kraken_convertotu(bracken_bac_refseq_WWTP_merge, name = "_bracken_bac_refseq_WWTP")
bracken_bac_refseq_WWTP_otu = bracken_bac_refseq_WWTP_otu %>% 
  rename(
    aale_bracken_bac_WWTP_refseq = aale_kraken2,
    bjer_bracken_bac_WWTP_refseq = bjer_kraken2,
    kalu_bracken_bac_WWTP_refseq = kalu_kraken2
  )

#bracken arc_refseq_WWTP merged and OTU table
bracken_arc_refseq_WWTP_merge=kraken_wwtpmerge(aale_bracken_arc_refseq_WWTP_tax,bjer_bracken_arc_refseq_WWTP_tax,kalu_bracken_arc_refseq_WWTP_tax)
bracken_arc_refseq_WWTP_otu=kraken_convertotu(bracken_arc_refseq_WWTP_merge, name = "_bracken_arc_refseq_WWTP")
bracken_arc_refseq_WWTP_otu = bracken_arc_refseq_WWTP_otu %>% 
  rename(
    aale_bracken_arc_WWTP_refseq = aale_kraken2,
    bjer_bracken_arc_WWTP_refseq = bjer_kraken2,
    kalu_bracken_arc_WWTP_refseq = kalu_kraken2
  )


#Kraken2 bac_refseq remove duplicates and viruses
bracken_bac_refseq_otu_clean = bracken_bac_refseq_otu[!duplicated(bracken_bac_refseq_otu$OTU),]
bracken_bac_refseq_otu_clean1 = bracken_bac_refseq_otu_clean[bracken_bac_refseq_otu_clean$Kingdom != "Viruses",]


#Kraken2 bac_refseq_WWTP remove duplicates and viruses
bracken_bac_refseq_WWTP_otu_clean = bracken_bac_refseq_WWTP_otu[!duplicated(bracken_bac_refseq_WWTP_otu$OTU),]
bracken_bac_refseq_WWTP_otu_clean1 = bracken_bac_refseq_WWTP_otu_clean[bracken_bac_refseq_WWTP_otu_clean$Kingdom != "Viruses",]


#Kraken2 arc_refseq_WWTP remove duplicates and viruses
bracken_arc_refseq_WWTP_otu_clean = bracken_arc_refseq_WWTP_otu[!duplicated(bracken_arc_refseq_WWTP_otu$OTU),]
bracken_arc_refseq_WWTP_otu_clean1 = bracken_arc_refseq_WWTP_otu_clean[bracken_arc_refseq_WWTP_otu_clean$Kingdom != "Viruses",]



### Merging Tables ### 
merged_OTU = bracken_bac_refseq_otu_clean1 %>%
  full_join(bracken_bac_refseq_WWTP_otu_clean1, by=c("OTU","Kingdom","Phylum","Class","Order","Family","Genus","Species")) %>% 
  full_join(bracken_arc_refseq_WWTP_otu_clean1, by=c("OTU","Kingdom","Phylum","Class","Order","Family","Genus","Species"))  
merged_OTU = merged_OTU[,c(1:4,12:17, 5:11)]
write.csv(merged_OTU,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/bracken/bracken_variableDB_ampvis.csv", row.names = FALSE)

### Test for CSV file to ampvis ### 
rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

bracken_ampvis = amp_load(read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/bracken/bracken_variableDB_ampvis.csv"))
amp_heatmap(kraken2_ampvis, tax_empty = "remove")
