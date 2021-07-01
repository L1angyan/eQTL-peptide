library("rMVP")
# transform format of marker
# Full-featured function (Recommended)
MVP.Data(fileVCF="prune_ok.vcf",
         #filePhe="Phenotype.txt",
         fileKin=FALSE,
         filePC=FALSE,
         out="mvp"
         )
# Only convert genotypes
#MVP.Data.VCF2MVP("myVCF.vcf", out='mvp') # the genotype data should be fully imputed before using this function


# transform format of K matrix
# read from file
MVP.Data.Kin("kinship.txt", out="mvp", priority='memory', sep='\t')
# calculate from mvp_geno_file
#MVP.Data.Kin(TRUE, mvp_prefix='mvp', out='mvp')


# transform format of Q matrix
# read from file
MVP.Data.PC("admixture.9.Q", out='mvp', sep='\t')
# calculate from mvp_geno_file
#MVP.Data.PC(TRUE, mvp_prefix='mvp', perc=1, pcs.keep=5)


# Input data
genotype <- attach.big.matrix("mvp.geno.desc")
phenotype <- read.table("zzz_phenotype_ok.txt",head=TRUE)
map <- read.table("mvp.geno.map" , head = TRUE)
Kinship <- attach.big.matrix("mvp.kin.desc")
Covariates_PC <- bigmemory::as.matrix(attach.big.matrix("mvp.pc.desc"))

#GWAS
for(i in 2:ncol(phenotype)){
  imMVP <- MVP(
    phe=phenotype[, c(1, i)],
    geno=genotype,
    map=map,
    K=Kinship,
    CV.GLM=Covariates_PC,
    CV.MLM=Covariates_PC,
    CV.FarmCPU=Covariates_PC,
    #nPC.GLM=5,
    #nPC.MLM=3,
    #nPC.FarmCPU=3,
    priority="speed",
    ncpus=10,
    vc.method="BRENT",
    maxLoop=10,
    method.bin="static",
    #permutation.threshold=TRUE,
    #permutation.rep=100,
    threshold=0.05,
    method=c("GLM", "MLM", "FarmCPU")
  )
  gc()
}
