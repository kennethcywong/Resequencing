BINPATH=/mnt/ws/GenomeAssemblyPractice/01.Bin/fastp-master
DATAPATH=/mnt/ws/hw3/01.data
SRA_ACCESSION=$1

if [ "$#" -lt 1 ]; then
	echo "Usage: Filter the bad quality reads in PE fastq file by specifying the SRA accession number"
	echo "       $0 <sra_accession 1> <sra_accession 2> ..."
	exit
fi

for sra in "$@"
do
	$BINPATH/fastp -i $DATAPATH/${SRA_ACCESSION}_1.fastq.gz -I $DATAPATH/${SRA_ACCESSION}_2.fastq.gz -o ${SRA_ACCESSION}_1.filtered.fq.gz -O ${SRA_ACCESSION}_2.filtered.fq.gz --json ${SRA_ACCESSION}.fastp.json --html ${SRA_ACCESSION}.fastp.html --report_title "${SRA_ACCESSION} FASTP Report"
done
