library(dplyr)
library(stringr)


######## FUNCTIONS ############
kraken_fillempty=function(data){
  maxl=max(length(data))
  for (i in 7:(maxl-1)){
    while(length(ind <- which(data[i] == "")) > 0){
      data[ind,i] <- data[ind-1,i]
    }
  }
  return(data)
}

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


kraken_convertotu=function(input){
  output=input%>%
    mutate(OTU=paste0("OTU",1:nrow(input),"_kraken"))%>%
    select(c(14,3,7:13)) %>%
    filter(V3 > 0) %>%
    filter(!is.na(Kingdom))
  return(output)
}

kraken_convert = function(data){
  taxtab = unique(data$V4)
  taxrm=c("1","2","3","4","5","6","7","8","9","K")
  taxtab2 = taxtab[grepl(paste0(taxrm,collapse="|"),taxtab)]
  data = gtdb_formatted(data)
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
  data[grepl("U|R",data[,4]),7:13]=NA
  data = kraken_fillempty(data)
  data = kraken_convertotu(data)
  return(data)
}

filepath_load=commandArgs(trailingOnly = F)
filepath = filepath_load[6]
filename_split = as.vector(strsplit(filepath, "/"))
filename_split = unlist(filename_split)
filename_grep = grep(".report", filename_split, value = TRUE)
filename = gsub('_.*', "", filename_grep)

kraken_load = read.delim(filepath, header = FALSE)
kraken_otu = kraken_convert(kraken_load)
kraken_otu = kraken_otu %>% rename(!!filename := V3)

kraken_otu$Kingdom = str_trim(kraken_otu$Kingdom)
kraken_otu$Phylum = str_trim(kraken_otu$Phylum)
kraken_otu$Class = str_trim(kraken_otu$Class)
kraken_otu$Order = str_trim(kraken_otu$Order)
kraken_otu$Family = str_trim(kraken_otu$Family)
kraken_otu$Genus = str_trim(kraken_otu$Genus)
kraken_otu$Species = str_trim(kraken_otu$Species)

kraken_otu$Kingdom = str_replace(kraken_otu$Kingdom, "d__", "")
kraken_otu$Phylum = str_replace(kraken_otu$Phylum, "p__", "")
kraken_otu$Class = str_replace(kraken_otu$Class, "c__", "")
kraken_otu$Order = str_replace(kraken_otu$Order, "o__", "")
kraken_otu$Family = str_replace(kraken_otu$Family, "f__", "")
kraken_otu$Genus = str_replace(kraken_otu$Genus, "g__", "")
kraken_otu$Species = str_replace(kraken_otu$Species, "s__", "")


write.csv(kraken_otu, paste0("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/GTDB/kraken_ampvis_otu/", filename, "_gtdb_kraken_ampvisotu.csv"), row.names = FALSE)
