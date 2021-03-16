library(dplyr)
library(stringr)

######## FUNCTIONS ############

inserttax = function(input){
  taxsplit = strsplit(as.character(input$Group.1),";")
  input %>%
    mutate(Kingdom=sapply(taxsplit,function(x) x[2])) %>%
    mutate(Phylum=sapply(taxsplit,function(x) x[3]))%>%
    mutate(Class=sapply(taxsplit,function(x) x[4]))%>%
    mutate(Order=sapply(taxsplit,function(x) x[5]))%>%
    mutate(Family=sapply(taxsplit,function(x) x[6]))%>%
    mutate(Genus=sapply(taxsplit,function(x) x[7]))%>%
    mutate(Species=sapply(taxsplit,function(x) x[8]))
}

singlem_convertotu=function(input){
  input %>%
    mutate(OTU=paste0("OTU",1:nrow(input),"_singlem")) %>%
    select(c(10,2,3:9)) %>%
    filter(Kingdom == c("Bacteria", "Archaea"))
}

filepath_load=commandArgs(trailingOnly = F)
filepath = filepath_load[6]
filename_split = as.vector(strsplit(filepath, "/"))
filename_split = unlist(filename_split)
filename_grep = grep("singlem.csv", filename_split, value = TRUE)
filename = gsub('_.*', "", filename_grep)

singlem_load = read.delim(filepath, header = TRUE)

singlem_trimmed_partial = singlem_load %>%
  select(c("num_hits","taxonomy")) %>%
  rename(!!filename := num_hits)

singlem_trimmed = aggregate(x = singlem_trimmed_partial[,1], by = list(singlem_trimmed_partial[,2]), FUN = sum) %>% rename(!!filename := x)

singlem_taxsplit = inserttax(singlem_trimmed)

singlem_taxsplit$Kingdom = str_replace(singlem_taxsplit$Kingdom, " d__", "")
singlem_taxsplit$Phylum = str_replace(singlem_taxsplit$Phylum, " p__", "")
singlem_taxsplit$Class = str_replace(singlem_taxsplit$Class, " c__", "")
singlem_taxsplit$Order = str_replace(singlem_taxsplit$Order, " o__", "")
singlem_taxsplit$Family = str_replace(singlem_taxsplit$Family, " f__", "")
singlem_taxsplit$Genus = str_replace(singlem_taxsplit$Genus, " g__", "")
singlem_taxsplit$Species = str_replace(singlem_taxsplit$Species, " s__", "")

singlem = singlem_convertotu(singlem_taxsplit)

write.csv(singlem, paste0("/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/singleM/ampvis_otu/", filename, "_singlem_ampvisotu.csv"), row.names = FALSE)
