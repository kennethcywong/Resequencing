library(gdsfmt)
library(SNPRelate)

setwd("/mnt/ws/hw3/05.populationRelationship")

#biallelic by default
snpgdsVCF2GDS("input.vcf", "dataset1.gds")
snpgdsSummary("dataset1.gds")
genofile = snpgdsOpen("dataset1.gds")

#LD based SNP pruning
set.seed(1000)
snpset = snpgdsLDpruning(genofile,ld.threshold = 0.5)
snp.id=unlist(snpset)

# distance matrix - use IBS
#dissMatrix  =  snpgdsIBS(genofile , sample.id=NULL, snp.id=snp.id, autosome.only=TRUE,
#dissMatrix  =  snpgdsIBS(genofile , sample.id=NULL, snp.id=NULL, autosome.only=TRUE,
#     remove.monosnp=FALSE,  maf=NaN, missing.rate=NaN, num.thread=2, verbose=TRUE)
#    remove.monosnp=TRUE,  maf=NaN, missing.rate=NaN, num.thread=2, verbose=TRUE)
#print(dissMatrix$ibs)
#snpHCluster =  snpgdsHCluster(dissMatrix, sample.id=NULL, need.mat=TRUE, hang=0.01)

#cutTree = snpgdsCutTree(snpHCluster, z.threshold=15, outlier.n=5, n.perm = 5000, samp.group=NULL,
#    col.outlier="red", col.list=NULL, pch.outlier=4, pch.list=NULL,label.H=FALSE, label.Z=TRUE,
#    verbose=TRUE)

#pdf("tree.pdf")
#snpgdsDrawTree(cutTree, main = "Dataset 1",edgePar=list(col=rgb(0.5,0.5,0.5,0.75),t.col="black"),
#    y.label.kinship=T,leaflab="perpendicular")
#dev.off()

#pca
pop_dict <- c("Wuhan-Dec19","Wuhan-Dec19","USA.WI-Feb20","USA.WI-Feb20","NEPAL-Jan20","USA.WA-Feb20","USA.WA-Mar20","USA.WA-Mar20","USA.WA-Mar20","USA.WA-Mar20","USA.WA-Mar20","USA.CA-Mar20","BAT.China-Mar18","BAT.China-Mar18")

names(pop_dict) <- c("SRR11092058","SRR11092064","SRR11140744","SRR11140748","SRR11177792","SRR11241254","SRR11247077","SRR11278090","SRR11278091","SRR11278165","SRR11278166","SRR11314339","SRR11085733","SRR11085737")


sample.id <- read.gdsn(index.gdsn(genofile, "sample.id"))
pop_code <- pop_dict[sample.id]
# pop_code <- read.gdsn(index.gdsn(genofile, "sample.id"))

pca <- snpgdsPCA(genofile)
snpgdsClose(genofile)

tab <- data.frame(sample.id = pca$sample.id,pop = factor(pop_code)[match(pca$sample.id, sample.id)],EV1 = pca$eigenvect[,1],EV2 = pca$eigenvect[,2],stringsAsFactors = FALSE)
pc.percent <- round(pca$varprop*100, 2)

pdf("pca.pdf")
plot(tab$EV2, tab$EV1, pch=20, cex=2, col=as.integer(tab$pop),xlab=paste("Eigenvector 2 (", as.character(pc.percent[2]), "%)", sep=""), ylab=paste("Eigenvector 1 (", as.character(pc.percent[1]), "%)", sep=""))
legend("topleft", legend=levels(tab$pop), pch=20, col=1:nlevels(tab$pop))
dev.off()
