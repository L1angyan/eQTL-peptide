# Based on the GTF file of mapping and quantification
# I would like to merge all GTF file to generate a table including phenotypes.

name=""
for i in *.gtf;do
grep -w transcript $i |grep peptide_maize > ${i%.gtf}.txt
name=$name" "${i%.gtf}.txt
done

python3 zzz_phenotype.py $name
