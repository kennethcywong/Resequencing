#!/bin/bash

set -e

BINPATH="/mnt/ws/Resequencing/00.bin"
DATAPATH="/mnt/ws/hw3/03.variationCalling"

#Use vcftools to calculate population statistics
#calculate pi; remember to specify your own .vcf.gz file for this calculation
$BINPATH/vcftools_0.1.13/bin/vcftools --gzvcf $DATAPATH/filtered.raw.vcf.gz --window-pi 300 --out diversity_level

python plotDiversityStatistics.py #plot the diversity level; this is a short script developed by my self, so modify it or use other ways to plot the diversity

