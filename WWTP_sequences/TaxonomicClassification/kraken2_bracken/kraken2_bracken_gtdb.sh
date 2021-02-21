#!/bin/bash

module purge
module load Kraken2/2.1.1-foss-2018a-Perl-5.26.1
module load Bracken/2.6.0-foss-2018a
module load parallel

db_gtdb=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/data/custom_database/kraken2_bracken/kraken_GTDB_database
data_path=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/trimmed_reads_fastp
output_dir1=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2
output_dir2=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/kraken2/GTDB
threads=20


# make your batch file of the samples you want to run
ls $data_path | grep _R1.fastq | sed 's/_R1.fastq//' > $output_dir1/wwtp_sequences.txt

# run parallel
cat $output_dir1/wwtp_sequences.txt | parallel -j3 kraken2 --db $db_gtdb --paired $data_path/{}_R1.fastq $data_path/{}_R2.fastq --threads $threads --report $output_dir2/{}_gtdb_kraken2.report '&>' $output_dir1/log/{}_gtdb_kraken2.log

cat $output_dir1/wwtp_sequences.txt | parallel -j3 bracken -d $db_gtdb -i $output_dir2/{}_gtdb_kraken2.report -o $output_dir2/{}_gtdb_bracken.report '&>' $output_dir1/log/{}_gtdb_bracken2.log
