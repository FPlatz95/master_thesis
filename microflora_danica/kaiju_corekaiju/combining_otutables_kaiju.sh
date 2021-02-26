
echo "OTU","Kingdom","Phylum","Class","Order","Family","Genus","Species" > /srv/MA/Projects/microflora_danica/analysis/classified_kaiju/kaiju2table/ampvis_otu/kaiju_combined_otu.csv
echo "Dummy","Dummy","Dummy","Dummy","Dummy","Dummy","Dummy","Dummy" >> /srv/MA/Projects/microflora_danica/analysis/classified_kaiju/kaiju2table/ampvis_otu/kaiju_combined_otu.csv

for i in /srv/MA/Projects/microflora_danica/analysis/classified_kaiju/kaiju2table/ampvis_otu/*_ampvisotu.csv
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/microflora_danica/kaiju_corekaiju/combining_otutables_kaiju.R $FILE
done

Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/microflora_danica/kaiju_corekaiju/rearranging_otutable_kaiju.R /srv/MA/Projects/microflora_danica/analysis/classified_kaiju/kaiju2table/ampvis_otu/kaiju_combined_otu.csv
