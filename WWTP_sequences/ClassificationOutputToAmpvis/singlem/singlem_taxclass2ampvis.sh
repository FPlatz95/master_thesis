for i in /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/singleM/classification/*singlem.csv
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/WWTP_sequences/ClassificationOutputToAmpvis/singlem/singlem_taxclass2ampvis.R $FILE
done
