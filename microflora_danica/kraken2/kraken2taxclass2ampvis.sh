for i in /srv/MA/Projects/microflora_danica/analysis/classified_kraken2/*_kraken2.report
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/microflora_danica/kraken2/kraken2taxclass2ampvis.R $FILE
done
