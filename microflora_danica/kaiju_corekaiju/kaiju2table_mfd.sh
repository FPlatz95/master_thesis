module purge
module load parallel
module load Kaiju/1.7.0-foss-2018a

db_refseq=/space/databases/Kaiju/kaijudb_2019-12-16
data_path=/srv/MA/Projects/microflora_danica/analysis/classified_kaiju

# make your batch file of the samples you want to run
ls $data_path | grep .taxoutput.txt | sed 's/_taxoutput.txt//' > $data_path/kaiju2table/mfd_sequences.txt

cat $data_path/kaiju2table/mfd_sequences.txt | parallel -j10 kaiju2table -t $db_refseq/nodes.dmp -n $db_refseq/names.dmp -r species -o $data_path/kaiju2table/{}_summary.tsv $data_path/{}_taxoutput.txt -v -l superkingdom,phylum,class,order,family,genus,species
