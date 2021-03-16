for i in /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/kaiju_refseq/*_summary.tsv
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript /srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/src/WWTP_sequences/ClassificationOutputToAmpvis/kaiju_corekaiju/kaiju_refseq/kaiju_taxclass2ampvis.R $FILE
done
