for i in /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/GTDB/*_species.report
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/WWTP_sequences/ClassificationOutputToAmpvis/kraken2_bracken/gtdb/bracken_taxclass2ampvis.R $FILE
done
