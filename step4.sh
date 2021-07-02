# Assocaition analysis using R package: rMVP.

module load R/3.6.0
Rscript association.R

mv peptide*GLM* ./zzz_glm
mv peptide*MLM* ./zzz_mlm
mv peptide*FarmCPU* ./zzz_farmcpu
