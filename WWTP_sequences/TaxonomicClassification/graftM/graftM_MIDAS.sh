#!/bin/bash
module purge
module load parallel
module load GraftM/0.13.1-foss-2018a-Python-3.6.4


samples_path=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM
data_path=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/data/WWTP_sequences
graftm_package=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/data/QIIME_fa_file_MiDAS_3.gpkg
output_dir=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/graftM
threads=8


# make your batch file of the samples you want run
ls $data_path | grep _R1.fastq | sed 's/.fastq.gz//' > $samples_path/wwtp_sequences.txt

# run parallel
cat $samples_path/wwtp_sequences.txt | parallel -j6 graftM graft --forward $data_path/{} --graftm_package $graftm_package --output_directory $output_dir/{}_MIDAS --threads $threads '&>' $output_dir/log/{}_graftm_MIDAS.log
