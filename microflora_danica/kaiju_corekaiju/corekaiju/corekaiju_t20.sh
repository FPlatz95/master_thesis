for i in /srv/MA/Projects/microflora_danica/analysis/classified_kaiju/kaiju2table/*_R1_001_summary.tsv
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/microflora_danica/kaiju_corekaiju/corekaiju/corekaiju_t20.R $FILE
done
