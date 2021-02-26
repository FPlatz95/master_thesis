module purge
module load parallel
module load Kaiju/1.7.0-foss-2018a

db_refseq=/space/databases/Kaiju/kaijudb_2019-12-16
db_core_pfam=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/data/custom_database/kaiju/kaiju_pfam_core_database_33.0
data_path=/srv/MA/Projects/microflora_danica/shallow_metagenomes/20003-02_trim/sequences_trim/
output_dir=/srv/MA/Projects/microflora_danica/analysis/classified_kaiju/corekaiju
output_dir2=/srv/MA/Projects/microflora_danica/analysis/classified_kaiju/corekaiju/corekaiju2table
threads=10


# make your batch file of the samples you want to run
ls $data_path | grep _R1_001_trimmed.fastq.gz | sed 's/_R1_001_trimmed.fastq.gz//' > $output_dir/wwtp_sequences.txt

# run parallel
cat $output_dir/wwtp_sequences.txt | parallel -j10 kaiju -t $db_refseq/nodes.dmp -f $db_core_pfam/corepfams_reduced.fmi -i $data_path/{}_R1_001_trimmed.fastq.gz -j $data_path/{}_R2_001_trimmed.fastq.gz -o $output_dir/{}_corekaiju_tax.out -z $threads

cat $output_dir/wwtp_sequences.txt | parallel -j10 kaiju2table -t $db_refseq/nodes.dmp -n $db_refseq/names.dmp -r species -o $output_dir2/{}_corekaiju_summary.tsv $output_dir2/{}_corekaiju_tax.out -v -l superkingdom,phylum,class,order,family,genus,species
