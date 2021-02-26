
for i in /srv/MA/Projects/microflora_danica/analysis/classified_kaiju/kaiju2table/*_summary.tsv
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/microflora_danica/kaiju_corekaiju/kaiju_otuconversion.R $FILE
done
