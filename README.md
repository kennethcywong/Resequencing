1. Download the Refseq and annotation file
   - cd 01.data
   - wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/009/858/895/GCF_009858895.2_ASM985889v3/GCF_009858895.2_ASM985889v3_genomic.gff.gz
   - Visit https://www.ncbi.nlm.nih.gov/nuccore/NC_045512.2?report=fasta and copy and paste the fasta seq to a file NC_045512.2.fna
   - unzip the gff file

2. Download the Reads (SRA) from NCBI
   - cd 01.data
   - mkdir <SRA No.>
   - cd <SRA No.>
   - ../../../tools/sratoolkit/bin/prefetch <SRA No.>


