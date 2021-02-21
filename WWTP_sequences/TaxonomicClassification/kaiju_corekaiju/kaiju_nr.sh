module purge
module load parallel
module load Kaiju/1.7.0-foss-2018a

db_nr=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/data/custom_database/kaiju/kaiju_nrdb_2020-12-03
data_path=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/trimmed_reads_fastp
output_dir1=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju
output_dir2=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kaiju/kaiju_nr
threads=20


# make your batch file of the samples you want to run
ls $data_path | grep _R1.fastq | sed 's/_R1.fastq//' > $output_dir1/wwtp_sequences.txt

# run parallel
cat $output_dir1/wwtp_sequences.txt | parallel -j3 kaiju -t $db_nr/nodes.dmp -f $db_nr/nr/kaiju_db_nr.fmi -i $data_path/{}_R1.fastq -j $data_path/{}_R2.fastq -o $output_dir2/{}_kaiju_nr_tax.out -z $threads '&>' $output_dir1/log/{}_kaiju_nr.log

cat $output_dir1/wwtp_sequences.txt | parallel -j3 kaiju2table -t $db_nr/nodes.dmp -n $db_nr/names.dmp -r species -o $output_dir2/{}_kaiju_nr_summary.tsv $output_dir2/{}_kaiju_nr_tax.out -v -l superkingdom,phylum,class,order,family,genus,species '&>' $output_dir1/log/{}_corekaiju.log
