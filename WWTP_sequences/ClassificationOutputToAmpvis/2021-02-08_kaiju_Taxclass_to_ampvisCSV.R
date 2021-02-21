rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

######## PACKAGES #############


library(dplyr)
library(ampvis2)
library(readxl)
library(stringr)



######## FUNCTIONS ############


kaiju_refseq_dir="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/output_refseq/kaiju/summary/"
pfamkaiju_refseq_dir="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/output_refseq/corekaiju/summary/"

kaiju_nr_dir="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/output_nr/kaiju/summary/"
pfamkaiju_nr_dir="/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/output_nr/corekaiju/summary/"


#kaiju refseq
aale_kaiju_refseq=read.delim(paste0(kaiju_refseq_dir,"AalE_kaiju_summary.tsv"))
bjer_kaiju_refseq=read.delim(paste0(kaiju_refseq_dir,"Bjer_kaiju_summary.tsv"))
kalu_kaiju_refseq=read.delim(paste0(kaiju_refseq_dir,"Kalu_kaiju_summary.tsv"))

#pfamkaiju refseq
aale_pfamkaiju_refseq=read.delim(paste0(pfamkaiju_refseq_dir,"AalE_corekaiju_summary.tsv"))
bjer_pfamkaiju_refseq=read.delim(paste0(pfamkaiju_refseq_dir,"Bjer_corekaiju_summary.tsv"))
kalu_pfamkaiju_refseq=read.delim(paste0(pfamkaiju_refseq_dir,"Kalu_corekaiju_summary.tsv"))

#kaiju nr
aale_kaiju_nr=read.delim(paste0(kaiju_nr_dir,"AalE_kaiju_summary.tsv"))
bjer_kaiju_nr=read.delim(paste0(kaiju_nr_dir,"Bjer_kaiju_summary.tsv"))
kalu_kaiju_nr=read.delim(paste0(kaiju_nr_dir,"Kalu_kaiju_summary.tsv"))

#pfamkaiju nr
aale_pfamkaiju_nr=read.delim(paste0(pfamkaiju_nr_dir,"AalE_corekaiju_summary.tsv"))
bjer_pfamkaiju_nr=read.delim(paste0(pfamkaiju_nr_dir,"Bjer_corekaiju_summary.tsv"))
kalu_pfamkaiju_nr=read.delim(paste0(pfamkaiju_nr_dir,"Kalu_corekaiju_summary.tsv"))


wwtpmerge=function(aale,bjer,kalu){
  full_join(aale,bjer,by=c("taxon_id","taxon_name"),suffix=c("_AalE","_Bjer"))%>%
    full_join(kalu,by=c("taxon_id","taxon_name"))%>%
    mutate(file_Kalu=file)%>%
    mutate(percent_Kalu=percent)%>%
    mutate(reads_Kalu=reads)%>%
    select(-file,-reads,-percent)
}

total_kaiju_refseq=wwtpmerge(aale_kaiju_refseq,bjer_kaiju_refseq,kalu_kaiju_refseq)
total_kaiju_nr=wwtpmerge(aale_kaiju_nr,bjer_kaiju_nr,kalu_kaiju_nr)

refseq_taxname=strsplit(as.character(total_kaiju_refseq$taxon_name),";")
nr_taxname=strsplit(as.character(total_kaiju_nr$taxon_name),";")

#numvec=1:length(aale_kaiju_refseq$file)

insert_tax=function(input,taxsplit){
  input%>%
    mutate(Kingdom=sapply(taxsplit,function(x) x[1]))%>%
    mutate(Phylum=sapply(taxsplit,function(x) x[2]))%>%
    mutate(Class=sapply(taxsplit,function(x) x[3]))%>%
    mutate(Order=sapply(taxsplit,function(x) x[4]))%>%
    mutate(Family=sapply(taxsplit,function(x) x[5]))%>%
    mutate(Genus=sapply(taxsplit,function(x) x[6]))%>%
    mutate(Species=sapply(taxsplit,function(x) x[7]))
}

kaijuotutable=function(input,taxsplit,read1,read2,read3,suffix){
  input%>%
    insert_tax(taxsplit)%>%
    mutate("{read1}":=reads_AalE)%>%
    mutate("{read2}":=reads_Bjer)%>%
    mutate("{read3}":=reads_Kalu)%>%
    mutate(OTU=paste0("OTU_",taxon_id,suffix))%>%
    select(OTU,read1,read2,read3,Kingdom,Phylum,Class,Order,Family,Genus,Species)%>%
    filter(OTU!=paste0("OTU_NA",suffix))
}

corekaiju=function(kaiju,pfam){
  kaiju%>%
    inner_join(pfam,by=c("taxon_id","taxon_name"),suffix=c("_kaiju","_pfam"))%>%
    filter(reads_pfam>20)%>%
    filter(is.na(taxon_id)!=T)%>%
    mutate(file=file_kaiju)%>%
    mutate(percent=percent_kaiju)%>%
    mutate(reads=reads_kaiju)%>%
    select(c("file","percent","reads","taxon_id","taxon_name"))
}

aale_corekaiju_refseq=corekaiju(aale_kaiju_refseq,aale_pfamkaiju_refseq)
bjer_corekaiju_refseq=corekaiju(bjer_kaiju_refseq,bjer_pfamkaiju_refseq)
kalu_corekaiju_refseq=corekaiju(kalu_kaiju_refseq,kalu_pfamkaiju_refseq)
total_corekaiju_refseq=wwtpmerge(aale_corekaiju_refseq,bjer_corekaiju_refseq,kalu_corekaiju_refseq)
refseq_coretaxname=strsplit(as.character(total_corekaiju_refseq$taxon_name),";")

aale_corekaiju_nr=corekaiju(aale_kaiju_nr,aale_pfamkaiju_nr)
bjer_corekaiju_nr=corekaiju(bjer_kaiju_nr,bjer_pfamkaiju_nr)
kalu_corekaiju_nr=corekaiju(kalu_kaiju_nr,kalu_pfamkaiju_nr)
total_corekaiju_nr=wwtpmerge(aale_corekaiju_nr,bjer_corekaiju_nr,kalu_corekaiju_nr)
nr_coretaxname=strsplit(as.character(total_corekaiju_nr$taxon_name),";")

total_kaiju_refseq_tax=kaijuotutable(total_kaiju_refseq,refseq_taxname,"AalE_kaiju_refseq","Bjer_kaiju_refseq","Kalu_kaiju_refseq","_kairef")
total_corekaiju_refseq_tax=kaijuotutable(total_corekaiju_refseq,refseq_coretaxname,"AalE_corekaiju_refseq","Bjer_corekaiju_refseq","Kalu_corekaiju_refseq","_corekr")
total_kaiju_nr_tax=kaijuotutable(total_kaiju_nr,nr_taxname,"AalE_kaiju_nr","Bjer_kaiju_nr","Kalu_kaiju_nr","_kainr")
total_corekaiju_nr_tax=kaijuotutable(total_corekaiju_nr,nr_coretaxname,"AalE_corekaiju_nr","Bjer_corekaiju_nr","Kalu_corekaiju_nr","_corekn")

otu_kaiju=full_join(total_kaiju_refseq_tax,total_corekaiju_refseq_tax)%>%
  full_join(total_kaiju_nr_tax)%>%
  full_join(total_corekaiju_nr_tax)
#amp_kaiju_ref=amp_load(total_kaiju_refseq_tax)

otu_kaiju=otu_kaiju[,c(1:4,12:20,5:11)]
write.csv(otu_kaiju,"/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/output_nr/kaiju_coreKaiju_variableDB_ampvis.csv", row.names = FALSE)

### Test for CSV file to ampvis ### 

rm(list=ls()) # Clear workspace
graphics.off() # Clear plots
cat("\014") # Clear console

kaiju_ampvis = amp_load(read.csv("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/kaiju_coreKaiju_variableDB_ampvis.csv"))
amp_heatmap(kaiju_ampvis, tax_empty = "remove")
