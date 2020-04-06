#!/bin/bash
BINPATH=/mnt/ws/GenomeAssemblyPractice/01.Bin/assembly-stats-master/build
DATAPATH=/mnt/ws/hw3/01.3.GenomeAssembly

if [ "$#" -lt 1 ]; then
	echo "Usage: Access the quality of assembled genome by specifying the SRA accession number"
	echo "       $0 <hash length>"
	exit
fi


#use assembly-stats to get staticstics of fasta/fastq files
$BINPATH/assembly-stats $DATAPATH/contigs_$1.fa 
