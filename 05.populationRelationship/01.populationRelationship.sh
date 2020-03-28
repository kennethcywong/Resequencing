#!/bin/bash

set -e

BINPATH="/mnt/ws/Resequencing/00.bin"
DATAPATH="/mnt/ws/hw3/03.variationCalling"

# Construct phylogenetic tree and conduct PCA analysis using SNPRelate;!important! You need to install R and SNPRelate by your self, for which you can refer to http://www.bioconductor.org/packages/release/bioc/vignettes/SNPRelate/inst/doc/SNPRelateTutorial.html#installation-of-the-package-snprelate
python prepareInput.py --gvcf $DATAPATH/filtered.raw.vcf.gz > input.vcf #First, to use a short script to change the contig/scaffold/chr names to numric values (1,2,3,...); otherwise, the following commands will be problematic

$BINPATH/vcftools_0.1.13/bin/vcftools --vcf input.vcf --remove exclude_sample_list --recode #To exclude possible high missing individuals before constructing the phylogenetic tree and pca; only for the example provided here; you need to modify this command according to your own situation

#Using SNPRelate package in R for this analysis, so install SNPRelate first
R  --no-save < TreePCR.R # Use the R package, snprelate, to conduct the pca and tree analysis; also, the chromosome names should be modified. prepareInput.py,

# Conduct population structure analysis using admixture; !important! You need to download plink and admixture if you do not have them, or cannot execute them directly
$BINPATH/plink/plink --allow-no-sex --no-sex --no-parents --no-fid --no-pheno --mind 0.2 --vcf input.vcf --make-bed #Prepare input bed format files (ped format without detailed information will not work here)
$BINPATH/admixture_linux-1.3.0/bin/admixture plink.bed 3

R  --no-save < plotAdmixtureResult.R
