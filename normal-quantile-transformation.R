setwd("D:/lyon/图谱课题/GWAS/phenotype")
df = read.table("zzz_phenotype1.txt",
                sep="\t",header=T,row.names = 1)
df[is.na(df)]=0
nqt <- function(a) {
  t <- (rank(a)-0.5)/length(a)
  t = qnorm(t)
  #ks.test(t,pnorm)
}

df1 = as.data.frame(apply(df,MARGIN = 1, nqt))
apply(df1,MARGIN = 2,mean)
apply(df1,MARGIN = 2,sd)
apply(df1,MARGIN = 2,ks.test,y=pnorm)
write.table(df1,"zzz_phenotype_ok.txt",sep="\t",quote=F)
