#!/bin/bash
module purge
module load parallel
module load SingleM/0.12.1-foss-2018a-Python-2.7.14


data_path=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/data/WWTP_sequences
output_dir=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/singleM
threads=12


# make your batch file of the samples you want to run
ls $data_path | grep _R1.fastq | sed 's/_R1.fastq//' > $output_dir/classification/wwtp_sequences.txt

# run parallel
cat $output_dir/classification/wwtp_sequences.txt | parallel -j8 singlem pipe --sequences $data_path/{}_R1.fastq --otu_table $output_dir/classification/{}_singlem.csv --threads $threads '&>' $output_dir/log/{}_singleM.log
