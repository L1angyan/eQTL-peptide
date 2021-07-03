# post GWAS analysis
# Exemplify the result of FarmCpu

# cat *FarmCPU_signals.csv > zzz_farmcpu.txt
# python3

def peptide(l):
    p = ""
    pl=[]
    for i in l:
        if "peptide_maize" in i:
            p=i.split(".")[0]
            pl.append(p)
        else:
            pl.append(p)
    return(pl)

def parse_ID(i):
    l=i.split(";")
    ID=l[0].split('"')[1]
    #tpm=l[6].split('"')[1]
    return(ID)

df = pd.read_table("zzz_farmcpu.txt",sep=",",header=None)
df[8]=peptide(df.iloc[:,7])
func = lambda x:"peptide_maize" not in x
df = df[df.iloc[:,7].map(func)]
df.columns = ["SNP","snp_chr","snp_pos","ref","alt","effect","se","snp_Pvalue","peptide"]

gtf = pd.read_table("~/ly/map/gwas/annotation/intergenic.gtf",sep="\t",header=None)
gtf = gtf[gtf[2]=="transcript"]
gtf["peptide"]=gtf[8].apply(parse_ID)
gtf = gtf.loc[:,[0,3,4,6,"peptide"]]
gtf.columns = ["peptide_chr","peptide_pos1","peptide_pos2","peptide_strand","peptide"]

df = pd.merge(df,gtf,on="peptide")
# df.to_csv("zzz_merge_farmcpu.txt",sep="\t",index=None)
# Now, I have got a table containing all of the eQTL information.





