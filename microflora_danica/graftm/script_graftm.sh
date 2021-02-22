#Run GraftM
#TRM_OUT=$KAI_DIR"/terminal_output"
#mkdir $TRM_OUT 2>/dev/null
#SAMPLE1=$IN_DIR"/20003FL-02-01-160_S256_L002_R1_001.fastq.gz"
#SAMPLEID=$(echo $SAMPLE1 | sed 's/.fastq.gz//g')
#SAMPLEID=$(echo $SAMPLE1 | sed 's/.fastq.gz//g' | sed "s,$IN_DIR/,,g")
#INPUT=$IN_DIR"/20003FL-02-01-160_S256_L002_R1_001_trim.fastq.gz"
#SAMPLE2=$(echo $SAMPLE1 | sed 's/R1/R2/g')
#TAX1=$(echo $SAMPLE1 | sed 's/_trim/_classified/g')
#TAX2=$(echo $SAMPLE1 | sed 's/_trim/_unclassified/g')
#TAX3=$(echo $SAMPLE1 | sed 's/.fastq.gz/_taxoutput.txt/g')
TLOG=$(echo $SAMPLE1 | sed 's/^.*\(S.*_L\).*$/\1/' | sed 's/_L//g')
PACKAGE="/shared-nfs/MGP1000/databases/graftm/7.71.silva_v132_alpha1.gpkg"

for i in $IN_DIR/*R1_001.fastq.gz
do
SAMPLE1=$(echo ${i})
SAMPLEID=$(echo $SAMPLE1 | sed 's/.fastq.gz//g' | sed "s,$IN_DIR/,,g")
GRM_ID_DIR=$GRM_DIR"/"$SAMPLEID
GRM_ID_DIR2=$(echo $GRM_ID_DIR | sed 's|//|/|g')

graftM graft --forward $SAMPLE1 --graftm_package $PACKAGE  --threads $DTHREADS --output_directory $GRM_ID_DIR2 & #| tee $TRM_OUT/log_$TLOG.txt



FILES=$(($FILES+1))
CYC=$(($CYC+1))
if (($CYC == $PARASES)); then CYC=0; wait; fi;
done

wait

for j in $IN_DIR/*R1_001.fastq.gz
do
  SAMPLER=$(echo ${j})
  SAMPLEID=$(echo $SAMPLER | sed 's/.fastq.gz//g' | sed "s,$IN_DIR/,,g")
  GRM_ID_DIR=$GRM_DIR"/"$SAMPLEID
  GRM_ID_DIR2=$(echo $GRM_ID_DIR | sed 's|//|/|g')
  mv $GRM_ID_DIR2"/combined_count_table.txt" $GRM_DIR2"/"$SAMPLEID"_otutab.txt"
  rm -r $GRM_ID_DIR2
done

echo $FILES >> temp2_$ID.csv
echo $PARASES,$DTHREADS >> temp3_$ID.csv

#echo $SAMPLEID
#IDOUT=$TESTDIR"/"$SAMPLEID
#echo $IDOUT
#mkdir $IDOUT
#touch $IDOUT"/"$SAMPLEID".txt"
