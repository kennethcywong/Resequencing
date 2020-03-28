#!/bin/bash

set -e

cleanup() {
	rm -rf mark_dup/*
	rm -rf raw.GDBI/*
	rm -rf GDBI
	rm -rf vcf/*
	rm -rf raw_vcf/*
	rm -rf recal/*
	rm vcf_list.txt
	rm raw_vcf_list.txt
}
trap cleanup ERR EXIT

BINPATH="/mnt/ws/Resequencing/00.bin"
DATAPATH="/mnt/ws/hw3/01.data"
BAMPATH="/mnt/ws/hw3/02.mapping"
REFSEQ="NC_045512.2.fna"
REFSEQ_NO="NC_045512.2"
SPECIES="sars_cov_2"

sra_list=(SRR11085737 SRR11092064 SRR11085733 SRR11140744 SRR11140748 SRR11177792 SRR11241254 SRR11247077 SRR11278090 SRR11278091 SRR11278165 SRR11278166 SRR11314339 SRR11092058)

# To call SNPs and small insertions and deletions using gatk pipeline according to the best practice suggested by GATK documentation

## Before start, build dictionary for the reference
if [ ! -f "$DATAPATH/${REFSEQ_NO}.dict" ]; then
	$BINPATH/gatk-4.1.0.0/gatk CreateSequenceDictionary -R $DATAPATH/$REFSEQ
fi

## First round of variation calling, to generate possible variation sites to be used for base quality score recalibration
### Step 1.1, mark the PCR duplications using MarkDuplicates

if [ ! -d "mark_dup" ]
then
	mkdir mark_dup
fi

for sra in ${sra_list[@]}
do
	$BINPATH/gatk-4.1.0.0/gatk MarkDuplicates --INPUT $BAMPATH/$sra.sorted.bam --OUTPUT mark_dup/$sra.sorted.marked_duplicates.bam --METRICS_FILE mark_dup/$sra.marked_dup_metrics.txt
	$BINPATH/gatk-4.1.0.0/gatk AddOrReplaceReadGroups -I mark_dup/$sra.sorted.marked_duplicates.bam -O mark_dup/$sra.sorted.marked_duplicates.add_read_group.bam -LB $sra -PL ILLUMINA -PU 1 -SM $sra
	$BINPATH/samtools-1.9/samtools index mark_dup/$sra.sorted.marked_duplicates.add_read_group.bam
	rm mark_dup/$sra.sorted.marked_duplicates.bam
done

### Step 1.2, call possible variation for the first round
#### Step 1.2.1 call variants per-sample

if [ ! -d "raw_vcf" ]
then
mkdir raw_vcf
fi

if [ -d "raw.GDBI" ]
then
    \rm -rf raw.GDBI
fi

for sra in ${sra_list[@]}
do
	$BINPATH/gatk-4.1.0.0/gatk --java-options "-Xmx1g" HaplotypeCaller -R $DATAPATH/$REFSEQ -I mark_dup/$sra.sorted.marked_duplicates.add_read_group.bam -O raw_vcf/$sra.raw.g.vcf.gz -ERC GVCF
done

### Step 1.2.2 Consolidate GVCFs

for sra in ${sra_list[@]} #generate the sample name list first
do
	printf "$sra\traw_vcf/$sra.raw.g.vcf.gz\n" >> raw_vcf_list.txt
done

$BINPATH/gatk-4.1.0.0/gatk --java-options "-Xmx1g -Xms1g" GenomicsDBImport --sample-name-map raw_vcf_list.txt --genomicsdb-workspace-path raw.GDBI -L NC_045512.2

### Step 1.2.3 Joint-Call Cohort
$BINPATH/gatk-4.1.0.0/gatk --java-options "-Xms1g" GenotypeGVCFs -R $DATAPATH/$REFSEQ -V gendb://raw.GDBI -O raw.vcf.gz

### Step 1.2.4 Filter variations (no known variations available, so use hard filtering instead)
$BINPATH/gatk-4.1.0.0/gatk VariantFiltration -R $DATAPATH/$REFSEQ -V raw.vcf.gz --filter-expression "QD<20.0" --filter-name "raw_filter" -O filtered.raw.vcf.gz

rm raw_vcf_list.txt

## Step 1.3  Quality score recalibration and re-run the variation calling to obtain the final variation dataset

### Step 1.3.1 Recalibration
if false; then	# Skip this step if some of the $sra.recal_data.table file is empty
if [ ! -d "recal" ]
then
mkdir recal
fi

for sra in ${sra_list[@]}
do
	$BINPATH/gatk-4.1.0.0/gatk BaseRecalibrator -I mark_dup/$sra.sorted.marked_duplicates.add_read_group.bam -R $DATAPATH/$REFSEQ --known-sites filtered.raw.vcf.gz -O recal/$sra.recal_data.table
	$BINPATH/gatk-4.1.0.0/gatk ApplyBQSR -I mark_dup/$sra.sorted.marked_duplicates.add_read_group.bam -R $DATAPATH/$REFSEQ --bqsr-recal-file recal/$sra.recal_data.table -O recal/$sra.bam
rm mark_dup/$sra.sorted.marked_duplicates.add_read_group.bam
done
fi

### Step 1.3.2 Call variations per-sample

if [ ! -d "vcf" ]
then
mkdir vcf
fi

for sra in ${sra_list[@]}
do
#	$BINPATH/gatk-4.1.0.0/gatk --java-options "-Xmx1g" HaplotypeCaller -R $DATAPATH/$REFSEQ -I recal/$sra.bam -O vcf/$sra.g.vcf.gz -ERC GVCF
	$BINPATH/gatk-4.1.0.0/gatk --java-options "-Xmx1g" HaplotypeCaller -R $DATAPATH/$REFSEQ -I mark_dup/$sra.sorted.marked_duplicates.add_read_group.bam -O vcf/$sra.g.vcf.gz -ERC GVCF
done


### Step 1.3.3 Consolidate GVCFs
for sra in ${sra_list[@]} #generate the sample name list first
do
	printf "$sra\tvcf/$sra.g.vcf.gz\n" >> vcf_list.txt
done

$BINPATH/gatk-4.1.0.0/gatk --java-options "-Xmx1g -Xms1g" GenomicsDBImport --sample-name-map vcf_list.txt --genomicsdb-workspace-path GDBI -L NC_045512.2

### Step 1.3.4 Joint-Call Cohort
$BINPATH/gatk-4.1.0.0/gatk --java-options "-Xms1g" GenotypeGVCFs -R $DATAPATH/$REFSEQ -V gendb://GDBI -O final.vcf.gz

### Step 1.3.5 Filter variations
$BINPATH/gatk-4.1.0.0/gatk VariantFiltration -R $DATAPATH/$REFSEQ -V final.vcf.gz --filter-expression "QD<20.0" --filter-name "my_filter" -O filtered.final.vcf.gz

rm vcf_list.txt
