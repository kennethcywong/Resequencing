1. Download the Refseq and annotation file
   ```bash
   cd 01.data
   - wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/009/858/895/GCF_009858895.2_ASM985889v3/GCF_009858895.2_ASM985889v3_genomic.gff.gz
   ```
   - Visit https://www.ncbi.nlm.nih.gov/nuccore/NC_045512.2?report=fasta and copy and paste the fasta seq to a file NC_045512.2.fn
   - unzip the gff file

2. Download the NGS Reads (SRA) Fastq files from NCBI
   ```bash
   cd 01.data
   ./download_sra.sh <SRA accession number 1> <SRA accession number 2> ...
   ```

3. Quality Control of the NGS Reads
   - generate the FastQC html report
   ```bash
   cd 01.1.DataFiltering
   ./01.runQC.sh <SRA accession number 1> <SRA accession number 2> ...
   ```

   - filter the bad quality reads
   ```bash
   ./02.runDataFiltering.sh <SRA accession number 1> <SRA accession number 2> ..."
   ```

4. Kmer Analysis
   ```bash
   cd 01.2.KmerAnalysis
   ./kmerAnalysis.sh <Kmer Length> <SRA accession number 1> <SRA accession number 2> ..."
   ```
   - To estimate genome heterozygosity, repeat content, and size from sequencing reads using a kmer-based statistical approach, pleae visit the website http://qb.cshl.edu/genomescope/
   - Please upload the \*.histo file to the website.
   - The data in histo does not coverage and peak cannot find in this analysis, do not know why?
 
5. De-novo genome assembly
   ```bash
   cd /mnt/ws/hw3/01.3.GenomeAssembly
   ./genomeAssembly.sh <Hash Length> <exp. coverage> <sra_accession 1> <sra_accession 2> ...
   ```
   - Max. hash length is 127, please try the optimised hash length so that the N-50 and max contig. length is maximized.
   - Expected coverage is the depth of the NGS sequencing data, can be found from SRA Study data in NCBI website (e.g. 24293 for SRR11059946)

6. Access the quality of assembled genome
   ```bash
   cd /mnt/ws/hw3/01.4.GenomeAssemblyAssessment
   ./genomeAssessment.sh <hash length>
   ```
   - Or BLASTN the assembed FASTA file and see the blast result is good or not.

7. Annotate the assembled genome 
   ```bash
   cd /mnt/ws/hw3/01.5.GeneAnnotation
   ./geneAnnotation.sh <Hash Length>
   ```
   - Test the annotate result by searching the annotated proteins in BLASTP and see the blast result is good or not.

8. Build the Phylogenetic Tree
   ```bash
   cd /mnt/ws/hw3/01.6.PhylogeneticTree
   ./multipleSequenceAlignAndTreeConstruction.sh <de novo assembled fasta file>
   ```
  
9. Mapping to reference genome
   - If the de-novo assembly genome is good enough, use the fasta file generated in Step 5 and functional annotation from Step 7.
     Otherwise, use the download reference genome and annotation file from Step 1.
   ```bash
   cd /mnt/ws/hw3/02.mapping
   ./01.mapping.sh
   ```

10. Variation calling by GATK best practice
   ```bash 
   cd /mnt/ws/hw3/03.variationCalling
   ./01.gatkVariationCalling.sh
   ```

11. Calculate the diversity level amongs the sample population
   ```bash
   cd /mnt/ws/hw3/04.populationDiversity
   ./01.calcStatistics.sh <window size in nt>
   ```

12. Build the Phylogenetic Tree
   ```bash
   cd /mnt/ws/hw3/05.populationRelationship
   python vcf2phylip.py -i <vcf filename>   # *.phy file is generated and use as input to dnaml
   /mnt/ws/Resequencing/00.bin/phylip-3.695/exe/dnaml   # Input the *.phy filename
   ```
   The tree can be found in output file "outfile".

13. PCA Analysis based on the VCF file
   ```bash
   cd /mnt/ws/hw3/05.populationRelationship
   cp <vcf file> input.vcf
   Rscript Tree_pca_only.R
   ```
   The PCA plot will be saved as pca.pdf
   
