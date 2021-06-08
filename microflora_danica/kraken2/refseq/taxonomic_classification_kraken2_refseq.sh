#!/bin/bash

module purge
module load Kraken2/2.1.1-foss-2018a-Perl-5.26.1
module load parallel

db_bac_refseq=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/data/custom_database/kraken2_bracken/krakendb_2021-01-02_bacteria_refseq
data_path=/srv/MA/Projects/microflora_danica/shallow_metagenomes/20003-02_trim/sequences_trim/
output_dir=/srv/MA/Projects/microflora_danica/analysis/classified_kraken2/refseq/
threads=20


# make your batch file of the samples you want to run
ls $data_path | grep _R1_001_trimmed.fastq.gz | sed 's/_R1_001_trimmed.fastq.gz//' > $output_dir/mfd_sequences.txt

# run parallel
cat $output_dir/mfd_sequences.txt | parallel -j4 kraken2 --db $db_bac_refseq --paired $data_path{}_R1_001_trimmed.fastq.gz $data_path{}_R2_001_trimmed.fastq.gz --threads $threads --report $output_dir/{}_refseq_kraken2.report '&>' $output_dir/log/{}_refseq_kraken2.log
