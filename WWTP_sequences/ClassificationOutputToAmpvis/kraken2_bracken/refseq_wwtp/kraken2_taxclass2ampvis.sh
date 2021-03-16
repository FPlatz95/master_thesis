for i in /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/bac_refseq_WWTP/*_kraken2.report
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/WWTP_sequences/ClassificationOutputToAmpvis/kraken2_bracken/refseq_wwtp/kraken2_taxclass2ampvis.R $FILE
done
