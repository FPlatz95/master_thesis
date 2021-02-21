#Commands run before every database build
module purge
module load Kraken2/2.1.1-foss-2018a-Perl-5.26.1
module load Bracken/2.6.0-foss-2018a
wwtp_genomes_path=/srv/MA/users/fplatz16/krakendb_custom_test/aalE_genomes/
database_path=/srv/MA/users/fplatz16/krakendb_custom



#krakendb_2021-01-02_bacteria_refseq
kraken2-build --download-taxonomy --threads 20 --db krakendb_2021-01-02_bacteria_refseq
kraken2-build --download-library bacteria --threads 20 --db $database_path/krakendb_2021-01-02_bacteria_refseq
kraken2-build --download-library archaea --threads 20 --db $database_path/krakendb_2021-01-02_bacteria_refseq
kraken2-build --build --threads 20 --db $database_path/krakendb_2021-01-02_bacteria_refseq
bracken-build -d $database_path/krakendb_2021-01-02_bacteria_refseq -t 20 -k 35 -l 150


#krakendb_2021-01-02_bacteria_refseq_WWTPGenomes
kraken2-build --download-taxonomy --threads 20 --db $database_path/krakendb_2021-01-02_bacteria_refseq_WWTPGenomes
kraken2-build --download-library bacteria --threads 20 --db $database_path/krakendb_2021-01-02_bacteria_refseq_WWTPGenomes
find $wwtp_genomes_path -name '*.fa' -print0 | xargs -0 -I{} -n1 kraken2-build --add-to-library {} --db $database_path/krakendb_2021-01-02_bacteria_refseq_WWTPGenomes
kraken2-build --download-library archaea --threads 30 --db $database_path/krakendb_2021-01-02_bacteria_refseq_WWTPGenomes
kraken2-build --build --threads 30 --db $database_path/krakendb_2021-01-02_bacteria_refseq_WWTPGenomes
bracken-build -d $database_path/krakendb_2021-01-02_bacteria_refseq_WWTPGenomes -t 20 -k 35 -l 150


#krakendb_2021-01-02_archea_refseq_WWTPGenomes
kraken2-build --download-taxonomy --threads 20 --db $database_path/krakendb_2021-01-02_archea_refseq_WWTPGenomes
kraken2-build --download-library archaea --threads 20 --db $database_path/krakendb_2021-01-02_archea_refseq_WWTPGenomes
find $wwtp_genomes_path -name '*.fa' -print0 | xargs -0 -I{} -n1 kraken2-build --add-to-library {} --db $database_path/krakendb_2021-01-02_archea_refseq_WWTPGenomes
kraken2-build --build --threads 20 --db $database_path/krakendb_2021-01-02_archea_refseq_WWTPGenomes
bracken-build -d $database_path/krakendb_2021-01-02_archea_refseq_WWTPGenomes -t 20 -k 35 -l 150
