
for i in *_otutab.txt
do
  FILE=$(echo ${i})
  echo $FILE
  Rscript graftm_otuconversion.R $FILE
done
