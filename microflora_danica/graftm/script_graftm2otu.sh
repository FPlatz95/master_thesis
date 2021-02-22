#!/bin/bash

#IN_DIR="/srv/MA/users/hnguye15/test_dataset"
#GRM_DIR="/srv/MA/users/hnguye15/test_dataset/test_output7/graftm_output"

#for j in $IN_DIR/*R1_001.fastq.gz
#do
#  SAMPLER=$(echo ${j})
#  SAMPLEID=$(echo $SAMPLER | sed 's/.fastq.gz//g' | sed "s,$IN_DIR/,,g")
#  GRM_ID_DIR=$GRM_DIR"/"$SAMPLEID
#  GRM_ID_DIR2=$(echo $GRM_ID_DIR | sed 's|//|/|g')
#  mv $GRM_ID_DIR2"/combined_count_table.txt" $GRM_DIR"/"$SAMPLEID"_otutab.txt"
#  rm -r $GRM_ID_DIR2
#done
mkdir ampvis_format 2>/dev/null
for i in *_otutab.txt
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript graftm_otuconversion.R $FILE
done
