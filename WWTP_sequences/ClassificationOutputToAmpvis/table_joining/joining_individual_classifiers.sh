echo "OTU","Kingdom","Phylum","Class","Order","Family","Genus","Species" > /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_t20_ampvis_otu/corekaiju_refseq_t20_ampvis_combined.csv #Change this line
echo "Dummy","Dummy","Dummy","Dummy","Dummy","Dummy","Dummy","Dummy" >> /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_t20_ampvis_otu/corekaiju_refseq_t20_ampvis_combined.csv #Change this line

for i in /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_t20_ampvis_otu/*ampvisotu.csv #Change this line
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/WWTP_sequences/ClassificationOutputToAmpvis/table_joining/joining_individual_classifiers.R $FILE
done

Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/WWTP_sequences/ClassificationOutputToAmpvis/table_joining/rearranging_individual_tables.R /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju/refseq_t20_ampvis_otu/corekaiju_refseq_t20_ampvis_combined.csv #Change this line
