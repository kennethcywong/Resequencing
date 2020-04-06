BINPATH=/mnt/ws/GenomeAssemblyPractice/01.Bin/FastQC
DATAPATH=/mnt/ws/hw3/01.data

if [ "$#" -lt 1 ]; then
	echo "Usage: Generate the FastQC HTML report for PE reads by specifying the SRA accession number"
	echo "       $0 <sra_accession 1> <sra_accession 2> ..."
	exit
fi

for sra in "$@"
do
	$BINPATH/fastqc -o . $DATAPATH/${1}_1.fastq.gz
	$BINPATH/fastqc -o . $DATAPATH/${1}_2.fastq.gz
done
