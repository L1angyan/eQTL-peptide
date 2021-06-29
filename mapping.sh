#Quantify the expression of annotated sORFs

for i in *_1.clean.fq.gz;do

name=${i%_*}
mkdir ${name}_
cd ${name}_

hisat2 -p 5 --dta -x ~/b73V4/hisat2/b73_index -1 ../${name}_1.clean.fq.gz -2 ../${name}_2.clean.fq.gz -S ${name}.sam
samtools sort -@ 5 -o ${name}_sorted.bam ${name}.sam
rm ${name}.sam
stringtie ${name}_sorted.bam -G ~/ly/map/gwas/annotation/intergenic.gtf -p 5 -o ${name}.gtf
cd ../

done
