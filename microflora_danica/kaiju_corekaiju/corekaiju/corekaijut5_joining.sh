echo "OTU","Kingdom","Phylum","Class","Order","Family","Genus","Species" > /srv/MA/Projects/microflora_danica/analysis/classified_corekaiju_t5/corekaiju_t5_ampvis_combined.csv #Change this line
echo "Dummy","Dummy","Dummy","Dummy","Dummy","Dummy","Dummy","Dummy" >> /srv/MA/Projects/microflora_danica/analysis/classified_corekaiju_t5/corekaiju_t5_ampvis_combined.csv #Change this line

for i in /srv/MA/Projects/microflora_danica/analysis/classified_corekaiju_t5/*ampvisotu.csv #Change this line
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/microflora_danica/kaiju_corekaiju/corekaiju/corekaijut5_joining.R $FILE
done

Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/microflora_danica/kaiju_corekaiju/corekaiju/rearranging_individual_tables_t20.R /srv/MA/Projects/microflora_danica/analysis/classified_corekaiju_t5/corekaiju_t5_ampvis_combined.csv #Change this line
