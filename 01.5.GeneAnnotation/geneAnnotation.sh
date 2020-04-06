#!/bin/bash
BINPATH=/mnt/ws/GenomeAssemblyPractice/01.Bin/Prodigal-GoogleImport
DATAPATH=/mnt/ws/hw3/01.3.GenomeAssembly

if [ "$#" -lt 1 ]; then
	echo "Usage: Annotate the GENE function in the assembled genome"
	echo "       $0 <Hash Length>"
	exit
fi

$BINPATH/prodigal -i $DATAPATH/contigs_$1.fa -o gene_annotation.gff -f gff -a proteins.translation.fa #use prodigal to annotate the protein coding genes

