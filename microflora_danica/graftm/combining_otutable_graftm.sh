#!/bin/bash

echo "OTU","Kingdom","Phylum","Class","Order","Family","Genus","Species" > graftm_combined_otu.csv
echo "Dummy","Dummy","Dummy","Dummy","Dummy","Dummy","Dummy","Dummy" >> graftm_combined_otu.csv

for i in *_otutab.txt.csv
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript rscript_combinegraftmotu.R $FILE
done

Rscript rscript_fixcolnames.R
