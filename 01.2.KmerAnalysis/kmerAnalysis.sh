#!/bin/bash
BINPATH=/mnt/ws/GenomeAssemblyPractice/01.Bin/jellyfish-2.3.0/bin/
DATAPATH=/mnt/ws/hw3/01.1.DataFiltering

if [ "$#" -lt 2 ]; then
	echo "Usage: Generate the Kmer Analysis eport for PE reads by specifying the SRA accession number"
	echo "       $0 <Kmer Length> <sra_accession 1> <sra_accession 2> ..."
	exit
fi

KLEN=$1
shift

for sra in "$@"
do
	# To count the Kmers
	$BINPATH/jellyfish count -m $KLEN -s 2G -t 10 -o ${sra}_1_kmer${KLEN}_counts.jf <(zcat $DATAPATH/${sra}_1.filtered.fq.gz)
	$BINPATH/jellyfish count -m $KLEN -s 2G -t 10 -o ${sra}_2_kmer${KLEN}_counts.jf <(zcat $DATAPATH/${sra}_2.filtered.fq.gz)

	# To calculate the kmer frequency	
	$BINPATH/jellyfish histo ${sra}_1_kmer${KLEN}_counts.jf > ${sra}_1_kmer${KLEN}.histo
	$BINPATH/jellyfish histo ${sra}_2_kmer${KLEN}_counts.jf > ${sra}_2_kmer${KLEN}.histo
done
