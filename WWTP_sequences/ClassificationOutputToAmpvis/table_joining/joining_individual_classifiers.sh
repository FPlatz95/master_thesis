echo "OTU","Kingdom","Phylum","Class","Order","Family","Genus","Species" > /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/01_midas_combined_count/ampvis_otu/graftm_midas_combined_otu.csv
echo "Dummy","Dummy","Dummy","Dummy","Dummy","Dummy","Dummy","Dummy" >> /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/01_midas_combined_count/ampvis_otu/graftm_midas_combined_otu.csv

for i in /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/01_midas_combined_count/ampvis_otu/*graftm.csv
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/WWTP_sequences/ClassificationOutputToAmpvis/table_joining/joining_individual_classifiers.R $FILE
done

Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/WWTP_sequences/ClassificationOutputToAmpvis/table_joining/rearranging_individual_tables.R /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM/01_midas_combined_count/ampvis_otu/graftm_midas_combined_otu.csv
