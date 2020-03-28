#!/bin/bash

BINPATH="/mnt/ws/Resequencing/00.bin"
DATAPATH="/mnt/ws/hw3/01.data"
REFSEQ="NC_045512.2.fna"
SPECIES="sars_cov_2"

sra_list=(SRR11085737 SRR11092064 SRR11085733 SRR11140744 SRR11140748 SRR11177792 SRR11241254 SRR11247077 SRR11278090 SRR11278091 SRR11278165 SRR11278166 SRR11314339 SRR11092058)

#use hisat2 for mapping
##step1, build index
$BINPATH/hisat2/hisat2-build $DATAPATH/$REFSEQ $SPECIES

#build index using samtools for converting bam files, without this, bam file would be of no reference information
$BINPATH/samtools-1.9/samtools faidx $DATAPATH/$REFSEQ

##step2, mapping the downloaded sequences in sra format to the reference (and use samtools to change to bam file, and also to sort the resulted bam file)
# Use hisat instead of bwa because it accept SRA format directly and output as BAM
for sra in ${sra_list[@]}
do
	$BINPATH/hisat2/hisat2 -x $SPECIES --threads 1 --sra-acc $sra |$BINPATH/samtools-1.9/samtools view -S -b -t $DATAPATH/$REFSEQ -|$BINPATH/samtools-1.9/samtools sort - > $sra.sorted.bam &

#	$BINPATH/hisat2/hisat2 -x $SPECIES --threads 4 --sra-acc $sra | $BINPATH/samtools-1.9/samtools sort - > $sra.sorted.bam &
done
wait

##step3, build index for sorted bam files for later uses
# ../00.bin/samtools-1.9/samtools index *.sorted.bam
ls -1 *.sorted.bam|xargs -I{} -P0 bash -c "$BINPATH/samtools-1.9/samtools index {}"
