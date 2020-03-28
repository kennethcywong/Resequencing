import argparse
import gzip

chrs = {'NC_045512.2':"1"}

parser = argparse.ArgumentParser(description='manual to this script')
parser.add_argument('--gvcf', type=str, required=True, help='The input gvcf file', metavar='input.gvcf')
#parser.add_argument('--batch-size', type=int, default=32)
args = parser.parse_args()

with gzip.open(args.gvcf, 'r') as f:
    for line in f:
        for chr, num in chrs.items():
            line = line.replace(chr, num)
        print line.strip()
