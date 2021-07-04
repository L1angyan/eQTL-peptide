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

def sort(df):
    return(df.sort_values("snp_pos"))

def cluster(i):
    l_list=[]
    l=[]
    for k in range(len(i)):
        diff = i.iloc[k,13]
        if diff>=0 and diff<=10000:
            l.append(i.iloc[k,2])
        else:
            l=[i.iloc[k,2]]
        l_list.append(l)
    return(l_list)

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
#df.to_csv("zzz_merge_farmcpu.txt",sep="\t",index=None)
df = df.groupby("snp_chr").apply(sort)
df = df.reset_index(drop=True)
for i in df["snp_chr"].drop_duplicates():
    name="df_"+i
    locals()[name]=df[df["snp_chr"]==i]
    locals()[name].drop_duplicates(inplace=True)
    locals()[name]["snp_pos_diff"]=locals()[name]["snp_pos"].diff()
    #locals()[name].shape
    #b=locals()[name]["snp_pos"].diff()<10000
    #locals()[name][b].index
    locals()[name]["interval"]=cluster(locals()[name])
    locals()[name].to_csv("zzz_"+name+".txt",sep="\t",index=None)
    
# Now, I have get 10+ table file including eQTL information seperated by tab.
# ll
#-rw-r--r-- 1 yliang LLi   10177 Jul  4 15:34 zzz_df_1.txt
#-rw-r--r-- 1 yliang LLi    6443 Jul  4 15:34 zzz_df_2.txt
#-rw-r--r-- 1 yliang LLi    6659 Jul  4 15:34 zzz_df_3.txt
#-rw-r--r-- 1 yliang LLi    5851 Jul  4 15:34 zzz_df_4.txt






