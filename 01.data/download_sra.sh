#!/bin/bash
BINPATH=/mnt/ws/Resequencing/00.bin/sratoolkit.2.9.4-1-ubuntu64/bin

if [ "$#" -lt 1 ]; then
	echo "Usage: Download Paired-end fastq file by specifying the SRA accession number"
        echo "	     $0 <sra_accession 1> <sra_accession 2> ..."
	exit
fi

for sra in "$@"
do
	$BINPATH/fastq-dump -I --split-files --gzip -O . "$sra"
done
