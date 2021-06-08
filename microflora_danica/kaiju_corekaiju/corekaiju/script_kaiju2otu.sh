for i in /srv/MA/Projects/microflora_danica/analysis/classified_kaiju/core_kaiju/corekaiju2table/*_summary.tsv
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/microflora_danica/kaiju_corekaiju/corekaiju/kaiju_otuconversion.R $FILE
done
