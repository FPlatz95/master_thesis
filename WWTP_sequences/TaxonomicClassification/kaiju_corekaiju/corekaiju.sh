module purge
module load parallel
module load Kaiju/1.7.0-foss-2018a

db_refseq=/space/databases/Kaiju/kaijudb_2019-12-16
db_core_pfam=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/data/custom_database/kaiju/kaiju_pfam_core_database_33.0
data_path=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/trimmed_reads_fastp
output_dir1=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju
output_dir2=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/corekaiju
threads=20


# make your batch file of the samples you want to run
ls $data_path | grep _R1.fastq | sed 's/_R1.fastq//' > $output_dir1/wwtp_sequences.txt

# run parallel
cat $output_dir1/wwtp_sequences.txt | parallel -j3 kaiju -t $db_refseq/nodes.dmp -f $db_core_pfam/corepfams_reduced.fmi -i $data_path/{}_R1.fastq -j $data_path/{}_R2.fastq -o $output_dir2/{}_corekaiju_tax.out -z $threads '&>' $output_dir1/log/{}_corekaiju.log

cat $output_dir1/wwtp_sequences.txt | parallel -j3 kaiju2table -t $db_refseq/nodes.dmp -n $db_refseq/names.dmp -r species -o $output_dir2/{}_corekaiju_summary.tsv $output_dir2/{}_corekaiju_tax.out -v -l superkingdom,phylum,class,order,family,genus,species '&>' $output_dir1/log/{}_corekaiju.log
