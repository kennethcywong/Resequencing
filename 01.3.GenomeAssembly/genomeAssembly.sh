#!/bin/bash
BINPATH=/mnt/ws/GenomeAssemblyPractice/01.Bin/velvet_1.2.10
DATAPATH=/mnt/ws/hw3/01.1.DataFiltering

if [ "$#" -lt 3 ]; then
	echo "Usage: De-novo genome assembly from filtered PE reads by specifying the SRA accession number"
	echo "       $0 <Hash Length> <exp. coverage> <sra_accession 1> <sra_accession 2> ..."
	exit
fi

HASH_LEN=$1	#79
EXP_COV=$2 	#200

shift 2
for sra in "$@"
do
	$BINPATH/velveth ./ $HASH_LEN -shortPaired -fastq.gz -separate $DATAPATH/${sra}_1.filtered.fq.gz $DATAPATH/${sra}_2.filtered.fq.gz #construct the graph
	$BINPATH/velvetg ./ -exp_cov $EXP_COV #resolve the graph
done
