# transform format of K matrix generated from GCTA.

library(reshape2)
tmp <- read.table(gzfile("snp.gcta.grm.gz"), header = F, stringsAsFactors = F)
ids <- read.table("snp.gcta.grm.id", header = F, stringsAsFactors = F)
tmp <- tmp[,c(1,2,4)]
result_matrix <- acast(tmp, V1~V2, value.var="V4", drop = F)
makeSymm <- function(m) {
  m[upper.tri(m)] <- t(m)[upper.tri(m)]
  return(m)
}
result_full <- makeSymm(result_matrix)
result_df <- as.data.frame(result_full)
row.names(result_df) <- ids$V2
colnames(result_df) <- ids$V2
write.table(result_df, file = "kinship.txt", row.names = F, col.names = F, sep = "\t", quote = F)
