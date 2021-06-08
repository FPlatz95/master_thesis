echo "OTU","Kingdom","Phylum","Class","Order","Family","Genus","Species" > /srv/MA/Projects/microflora_danica/analysis/classified_corekaiju_t5/corekaiju_t5_ampvis_combined.csv #Change this line
echo "Dummy","Dummy","Dummy","Dummy","Dummy","Dummy","Dummy","Dummy" >> /srv/MA/Projects/microflora_danica/analysis/classified_corekaiju_t5/corekaiju_t5_ampvis_combined.csv #Change this line

for i in /srv/MA/Projects/microflora_danica/analysis/classified_corekaiju_t5/*ampvisotu.csv #Change this line
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/microflora_danica/kaiju_corekaiju/corekaiju/corekaiju_joining.R $FILE
done

Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/WWTP_sequences/ClassificationOutputToAmpvis/table_joining/rearranging_individual_tables.R /srv/MA/Projects/microflora_danica/analysis/classified_corekaiju_t5/corekaiju_t5_ampvis_combined.csv #Change this line
