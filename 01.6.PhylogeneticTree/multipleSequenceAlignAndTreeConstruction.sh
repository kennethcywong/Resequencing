#!/bin/bash
BINPATH=/mnt/ws/GenomeAssemblyPractice/01.Bin/
DATAPATH=/mnt/ws/hw3/01.3.GenomeAssembly

if [ "$#" -lt 1 ]; then
        echo "Usage: Generate the Kmer Analysis eport for PE reads by specifying the SRA accession number"
        echo "       $0 <de novo assembled fasta file>"
        exit
fi

cat $1 related_species.fasta > species.fa #prepare the fasta file with all the sequences to be aligned
$BINPATH/clustalo -i species.fa -o aligned_new.phylip --threads=16 --outfmt=phy #run the multiple sequence alignment
$BINPATH/phylip-3.697/src/dnaml #after this step, you will need to input the file "aligned.phylip" for the phylogenetic tree construction
