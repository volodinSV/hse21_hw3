*#!/bin/bash

# Создание рабочей папки
mkdir hse21_hw3
cd hse21_hw3

# Установка HISAT2 (для выравниваия RNA-seq чтений на геном)
sudo apt update
apt install hisat2
hisat --version

# Установка sra-toolkit (для скачивания .fastq файлов из NCBI)
mkdir -p SRAtoolkit/local
cd SRAtoolkit
wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
tar -vxzf sratoolkit.tar.gz
cd sratoolkit.2.11.2-ubuntu64/bin
export PATH=$PATH:$PWD/SRAtoolkit/sratoolkit.2.11.2-ubuntu64/bin
which fastq-dump

# Проверка работы
cd ..
vdb-config -i
fastq-dump --stdout SRR341436 | head -n 8

# Установка FastQC
java --version
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
unzip fastqc_v0.11.9.zip
chmod a+x FastQC/fastqc
./FastQC/fastqc --help

# Установка HTSeq-count
pip install HTSeq
htseq-count --version

# Скачиваем RNA-seq данные
mkdir samples;cd samples
for srr in "SRR3414629" "SRR3414630" "SRR3414631" "SRR3414635" "SRR3414636" "SRR3414637"; do time  fastq-dump  --split-files $srr; done

# Скачиваем геном мыши mm10 (проиндексированный для HISAT2)
cd ..
wget https://genome-idx.s3.amazonaws.com/hisat/mm10_genome.tar.gz
tar -xzvf mm10_genome.tar.gz

# Скачиваем аннотацию генов GENCODE для генома мыши mm10
wget http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M25/gencode.vM25.annotation.gtf.gz
gzip -d gencode.vM25.annotation.gtf.gz

# Выравнивание чтений
ls ./samples/* | xargs -tI{} ./FastQC/fastqc {}
multiqc ./samples
mkdir -p samples/sam
mkdir -p samples/hisat

# Запускаем HISAT2 и картируем все чтения на геном мыши
time hisat2 -p 3 -x mm10/genome -U ./samples/SRR3414636_1.fastq -S ./samples/sam/SRR3414636_1.sam  2>  ./samples/hisat/SRR3414636.hisat
time hisat2 -p 3 -x mm10/genome -U ./samples/SRR3414629_1.fastq -S ./samples/sam/SRR3414629_1.sam  2>  ./samples/hisat/SRR3414629.hisat
time hisat2 -p 3 -x mm10/genome -U ./samples/SRR3414630_1.fastq -S ./samples/sam/SRR3414630_1.sam  2>  ./samples/hisat/SRR3414630.hisat
time hisat2 -p 3 -x mm10/genome -U ./samples/SRR3414631_1.fastq -S ./samples/sam/SRR3414631_1.sam  2>  ./samples/hisat/SRR3414631.hisat
time hisat2 -p 3 -x mm10/genome -U ./samples/SRR3414635_1.fastq -S ./samples/sam/SRR3414635_1.sam  2>  ./samples/hisat/SRR3414635.hisat
time hisat2 -p 3 -x mm10/genome -U ./samples/SRR3414637_1.fastq -S ./samples/sam/SRR3414637_1.sam  2>  ./samples/hisat/SRR3414637.hisat

# Отбираем только те чтения, которые откартировались уникально (флаг NH:i:1)
cd ./samples/sam
grep -P '^@|NH:i:1$' SRR3414636_1.sam > SRR3414636.uniq.sam
grep -P '^@|NH:i:1$' SRR3414629_1.sam > SRR3414629.uniq.sam
grep -P '^@|NH:i:1$' SRR3414630_1.sam > SRR3414630.uniq.sam
grep -P '^@|NH:i:1$' SRR3414631_1.sam > SRR3414631.uniq.sam
grep -P '^@|NH:i:1$' SRR3414635_1.sam > SRR3414635.uniq.sam
grep -P '^@|NH:i:1$' SRR3414637_1.sam > SRR3414637.uniq.sam

rm -v *_1.sam

# Считаем кол-во уникально-картированных чтений
grep -v '^@' SRR3414636.uniq.sam | wc -l
grep -v '^@' SRR3414637.uniq.sam | wc -l
grep -v '^@' SRR3414635.uniq.sam | wc -l
grep -v '^@' SRR3414631.uniq.sam | wc -l
grep -v '^@' SRR3414630.uniq.sam | wc -l
grep -v '^@' SRR3414629.uniq.sam | wc -l

# С помощью программы HTSeq Подсчитываем количество чтений
mkdir counts
time htseq-count --format=sam --stranded=no SRR3414636.uniq.sam  gencode.vM25.annotation.gtf > ./counts/SRR3414636.counts
time htseq-count --format=sam --stranded=no SRR3414637.uniq.sam  gencode.vM25.annotation.gtf > ./counts/SRR3414637.counts
time htseq-count --format=sam --stranded=no SRR3414635.uniq.sam  gencode.vM25.annotation.gtf > ./counts/SRR3414635.counts
time htseq-count --format=sam --stranded=no SRR3414631.uniq.sam  gencode.vM25.annotation.gtf > ./counts/SRR3414631.counts
time htseq-count --format=sam --stranded=no SRR3414630.uniq.sam  gencode.vM25.annotation.gtf > ./counts/SRR3414630.counts
time htseq-count --format=sam --stranded=no SRR3414629.uniq.sam  gencode.vM25.annotation.gtf > ./counts/SRR3414629.counts

## Смотрим сколько чтений не удалось приписать ни одному гену
# __no_feature – столько чтений соответствует участкам генома, где не аннотировано ни одного экзона
# __ambiguous – столько чтений могут принадлежать разным генам
# Общая статистика для каждого образца
cd counts
for srr in "SRR3414629" "SRR3414630" "SRR3414631" "SRR3414635" "SRR3414636" "SRR3414637"; do echo ''; echo $srr; grep '_' $srr; done

# Объединям все файлы .counts по генам в один общий файл ALL.counts
paste $(ls SRR*.counts) | cut -f1,2,4,6,8,10,12 | awk 'BEGIN {print "geneID r1 r2 r3 c1 c2 c3"}{print}' | column -t > ALL.counts
