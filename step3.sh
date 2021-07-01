# Filtering markers

module load VCFtools/0.1.16
vcftools --gzvcf sortV4SNP1.vcf.gz --remove-indels \
--min-alleles 2 --max-alleles 2 --recode --keep sample.txt --out 368
vcftools --vcf 368.recode.vcf --freq --out freq
vcftools --vcf 368.recode.vcf --maf 0.05 --recode --out 368_maf_filter

plink --vcf 368_maf_filter.recode.vcf --maf 0.05 --geno 0.2 \
--mind 0.2 --recode vcf-iid --out maf0.05geno0.2mind0.2 --allow-extra-chr
# vcf-iid 加上ID，--geno即SNP在所有个体中的缺失率应该小于0.2，--mind即个体SNP的缺失率应该小于0.2
plink --vcf maf0.05geno0.2mind0.2.vcf --indep-pairwise 50 10 0.2 \
--out LD --allow-extra-chr
# LD pruning
plink --vcf maf0.05geno0.2mind0.2.vcf --recode vcf-iid \
--extract LD.prune.in --out prune_ok --allow-extra-chr
# extract non-LD markers
plink --vcf prune_ok.vcf --recode 12 --out admixture --allow-extra-chr
# admixture 格式
plink --vcf prune_ok.vcf --make-bed --out snp --allow-extra-chr
# 输出二进制基因型文件，用于构建Q矩阵



# Control population structure and kinship.


# Q matrix
for i in {1..15};do
bsub -J admixture -n 10 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 "admixture --cv admixture.ped $i -j10 >> log${i}.txt"
done
grep "CV error" log.txt > cv_error.txt
# admixture 分群，取cv error最小的k值及其对应的q矩阵即可，这里K=9时CVerror最小。
plink --vcf prune_ok.vcf --pca 20 --out pca --allow-extra-chr
# PCA 群体结构分析, --pca提取前20个主成分
twstats -t twtable -i pca.eigenval -o eigenvaltw.out
# 差不多也是一样的结果，分9个群，说明admixture的结果还是很可靠的。

# K matrix
gcta64 --make-grm-gz --out snp.gcta --bfile snp
Rscript kin.R
# 计算亲缘关系K矩阵

# 现在得到了：群体结构（admixture输出的q矩阵，admixture.9.Q），基因型文件（prune_ok.vcf），亲缘关系文件（K矩阵，kinship.txt）
# Now, I have got the covariants: Q matrix and K matrix as well as markers: prune_ok.vcf.
