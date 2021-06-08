for i in /srv/MA/Projects/microflora_danica/analysis/classified_kraken2/refseq/*_kraken2.report
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/microflora_danica/kraken2/refseq/kraken2_taxclass2ampvis_refseq.R $FILE
done
