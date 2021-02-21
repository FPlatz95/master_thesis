#!/bin/bash
#Development script
VERSION=0.1

### Description. ----------------------------------------------------------------

USAGE="$(basename "$0") [-h] [-i dir -o dir -t threads -p -c int]
-- MFD Taxonomic Classification script $VERSION:

This is a work in progress script for assembly-free taxonomic classification of shotgun metagenomes sequenced with the Illumina platform

Arguments:
	-h  Show this help text.
	-i  Input directory.
	-o  Output directory.
	-t  Number of threads for procsess. -Default is 10
	-p  Enable parallel sessions (Run multiple instances of tools when sufficient threads are allocated)
	-c  Choose trimming tool - MUST BE SET
		0: FastQC
		1: cutadapt
		2: Trimmomatic
		3: BBTools (BBDuk.sh)
		4: fastp
		n: none

Version 0.1 Features:
-Run chosen trimming tool (cutadapt/Trimmomatic/BBTools/fastp) on all sequences found in the input directory.
-Processed files are moved to output directory to their respective folder (Original files are kept).
-Track real time, CPU time, among others used per tool, and print to a log file.
-Run parallel sessions when sufficient CPU resources are allocated in order to increase efficiency.


"
### Terminal Arguments. ---------------------------------------------------------
PSET=0

# Import user arguments
while getopts ':h i:o:t:p c:x:' OPTION; do
  case $OPTION in
    h) echo "$USAGE"; exit 1;;
    i) export IN_DIR=$OPTARG;;
    o) export OUT_DIR=$OPTARG;;
    t) export THREADS=$OPTARG;;
    p) export PSET=1;;
    c) export TRIMT=$OPTARG;;
		x) export TAXT=$OPTARG;;
    :) printf "missing argument for -$OPTARG\n" >&2; exit 1;;
    \?) printf "invalid option for -$OPTARG\n" >&2; exit 1;;
  esac
done


# Check missing arguments.
MISSING="is missing but required. Exiting."
if [ -z ${IN_DIR+x} ]; then echo "-i $MISSING"; exit 1; fi;
if [ -z ${OUT_DIR+x} ]; then echo "-o $MISSING"; exit 1; fi;
if [ -z ${THREADS+x} ]; then THREADS=10; fi;

#Defining variables
export CORE=$(($THREADS/2))
if (($THREADS == 1)); then CORE=1; fi;
TIME=$(date "+%y%m%d_%H%M%S")
export ID=$(date "+%Y%m%d%H%M%S")
export ADAPTER1=CTGTCTCTTATACACATCTCCGAGCCCACGAGAC
export ADAPTER2=CTGTCTCTTATACACATCTGACGCTGCCGACGA
export MINLEN=10
export FQC_DIR=$(echo $OUT_DIR"/FastQC_reports"| sed 's|//|/|g')
export CUT_DIR=$(echo $OUT_DIR"/trimmed_seq" | sed 's|//|/|g')
export TRIM_DIR=$(echo $OUT_DIR"/trimmo_seq"| sed 's|//|/|g')
export BB_DIR=$(echo $OUT_DIR"/bbtrim_seq" | sed 's|//|/|g')
export FASTP_DIR=$(echo $OUT_DIR"/fastp_seq" | sed 's|//|/|g')
export KRK2_DIR=$(echo $OUT_DIR"/kraken2_output" | sed 's|//|/|g')
export KAI_DIR=$(echo $OUT_DIR"/kaiju_output" | sed 's|//|/|g')
export GRM_DIR=$(echo $OUT_DIR"/graftm_output" | sed 's|//|/|g')

#export FILES=0
#TRIM1=$(echo $SAMPLE1 | sed 's/.fastq.gz/_trim.fastq.gz/g' | sed "s,$IN_DIR,$CUT_DIR,g")


#Defining functions
logcputime(){
/usr/bin/time -a -o temp1_$ID.csv -f $ID','$TOOLS','$TOOLV',%E,%U,%S,'$CORE','$THREADS',%P' $@
}
detparases(){
export PARASES=0
REM=$THREADS
while [ $REM -gt 0 ]
	do
		REM=$(($REM-$@))
		if (($REM >= 0)); then export PARASES=$(($PARASES+1)); fi;
	done
if (($PARASES == 0 || $PSET == 0)); then export PARASES=1; fi;
export CYC=0
export FILES=0
export DTHREADS=$(($THREADS/$PARASES))
export DCORE=$(($DTHREADS/2))
if (($DTHREADS <= 1)); then DCORE=1; fi;
}

trimname(){
export SAMPLE1=$(echo ${i})
export SAMPLE2=$(echo ${i} | sed 's/R1/R2/g')
export TRIM1=$(echo $SAMPLE1 | sed 's/.fastq.gz/_trim.fastq.gz/g' | sed "s,$IN_DIR,$1,g")
export TRIM2=$(echo $SAMPLE2 | sed 's/.fastq.gz/_trim.fastq.gz/g' | sed "s,$IN_DIR,$1,g")
export TLOG=$(echo $SAMPLE1 | sed 's/^.*\(S.*_L\).*$/\1/' | sed 's/_L//g')
}


#Run FastQC
runfastqc(){
mkdir $FQC_DIR 2>/dev/null
module purge
module load FastQC/0.11.7-Java-1.8.0_172
TOOLS="FastQC"
TOOLV="0.11.7"
logcputime bash script_fastqc.sh
}

#Run Cutadapt - TRIMT=1
runcut(){
	mkdir $CUT_DIR 2>/dev/null
	module purge
	module load cutadapt/2.8-foss-2018a-Python-3.6.4
	TOOLS="cutadapt"
	TOOLV="v2.8"
	detparases 8
	logcputime bash script_cutadapt.sh
}

#Run trimmomatic - TRIMT=2
runtrimmo(){
	mkdir $TRIM_DIR 2>/dev/null
	module purge
	module load Trimmomatic/0.36-Java-1.8.0_172
	TOOLS="Trimmomatic"
	TOOLV="v0.36"
	detparases 6
	logcputime bash script_trimmomatic.sh
}

#Run BBTools - TRIMT=3
runbb(){
	mkdir $BB_DIR 2>/dev/null
	module purge
	#module load Java/13.0.1
	module load BBMap/38.87-foss-2018a
	TOOLS="BBTools"
	TOOLV="v38.87"
	detparases 8
	logcputime bash script_bbtools.sh
}

#Run Fastp (local) - TRIMT=4
runfastp(){
	mkdir $FASTP_DIR 2>/dev/null
	module purge
	TOOLS="Fastp"
	TOOLV="v0.21"
	detparases 8
	logcputime bash script_fastp.sh
}

#Run GraftM - TAXT=1
rungraftm(){
	#if (($TRIM != n)); then echo "GraftM must run on untrimmed reads"; exit 1; fi;
	mkdir $GRM_DIR 2>/dev/null
	module purge
	module load GraftM/0.13.1-foss-2018a-Python-3.6.4
	TOOLS="GraftM"
	TOOLV="0.13.1"
	detparases 1
	logcputime bash script_graftm.sh
}

#Run Kraken2 - TAXT=2
runkraken2(){
	mkdir $KRK2_DIR 2>/dev/null
	module purge
	module load Kraken2/2.1.0-foss-2018a-Perl-5.26.1
	TOOLS="Kraken2"
	TOOLV="2.1.0"
	logcputime bash script_kraken2.sh
}

#Run Kaiju - TAXT=3
runkaiju(){
	mkdir $KAI_DIR 2>/dev/null
	module purge
	module load Kaiju/1.7.0-foss-2018a
	TOOLS="Kaiju"
	TOOLV="1.7.0"
	logcputime bash script_kaiju.sh
}



#Export functions
export -f detparases
export -f trimname

#Print start time to terminal
echo Start time: $(date "+%T %D")
#Create log file and define header names
echo ID,Tool Name,Version,Real Time,User Time,Sys Time,Cores,Threads,%CPU > temp1_$ID.csv
echo Files processed > temp2_$ID.csv
echo Parallel Sesssions,Threads per Session > temp3_$ID.csv

#Run script
echo Running script. Please wait...

module purge

case $TRIMT in
  0) echo "Skipping Trimming...";;
  1) runcut;;
  2) runtrimmo;;
  3) runbb;;
  4) runfastp;;
  *) printf "invalid option for -c\n" >&2; rm temp1_$ID.csv; rm temp2_$ID.csv; rm temp3_$ID.csv; exit 1;;
esac

case $TAXT in
  0) echo "Skipping taxonomic classification...";;
  1) rungraftm;;
  2) runkraken2;;
  3) runkaiju;;
  *) printf "invalid option for -x\n" >&2; rm temp1_$ID.csv; rm temp2_$ID.csv; rm temp3_$ID.csv; exit 1;;
esac

#Print log file
paste -d , temp1_$ID.csv temp2_$ID.csv temp3_$ID.csv > log/log_$TIME.csv

#Remove temp files
rm temp1_$ID.csv
rm temp2_$ID.csv
rm temp3_$ID.csv


#Clear all active modules
module purge

#Print end time to terminal and log file
echo Finished: $(date "+%T %D")
