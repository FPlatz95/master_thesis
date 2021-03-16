module purge
module load fastp/0.20.1-foss-2018a
module load parallel

input_dir=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/data/WWTP_sequences
output_dir=/srv/MA/Projects/microflora_danica/analysis/projects/MFD_seges/results/WWTP_sequences/trimmed_reads_fastp

# make your batch file of the samples you want run
ls $input_dir | grep _R1.fastq | sed 's/_R1.fastq//' > $output_dir/wwtp_sequences.txt

# run parallel
cat $output_dir/wwtp_sequences.txt | parallel -j5 fastp -i $input_dir/{}_R1.fastq -I $input_dir/{}_R2.fastq -o $output_dir/{}_trimmed_R1.fastq -O $output_dir/{}_trimmed_R2.fastq
