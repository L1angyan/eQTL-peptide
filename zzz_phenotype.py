def parse_ID(i):
    l=i.split(";")
    ID=l[2].split('"')[1]
    #tpm=l[6].split('"')[1]
    return(ID)

def parse_tpm(i):
    l=i.split(";")
    tpm=l[6].split('"')[1]
    return(float(tpm))

def present(i):
    l=(sum(i>=0.1)>184)
    return(l)

def transform(i):
    from sklearn.preprocessing import QuantileTransformer
    #from sklearn.preprocessing import scale
    q=QuantileTransformer(n_quantiles=184,output_distribution="normal")
    i = q.fit_transform(i)
    #i = scale(i,axis=1, with_mean=True, with_std=True, copy=True)
    return(i)
#normal quantile transform
    
import pandas as pd
import sys
merge=pd.DataFrame(columns=["ID"])
ipf = sys.argv[1:]
for i in ipf:
    name=i.split(".")[0]
    df = pd.read_table(i,sep="\t",header=None)
    df["ID"]=df[8].map(parse_ID)
    df[name]=df[8].map(parse_tpm)
    df=df[["ID",name]]
    merge=pd.merge(merge,df,on="ID",how="outer")

merge.to_csv("zzz_phenotype.txt",sep="\t",index=None)
df = pd.read_table("zzz_phenotype.txt",sep="\t",index_col=0)
df = df[df.apply(present,axis=1)]
#对每一行用present函数，保留TPM表达量中位数大于0.1的基因
df.to_csv("zzz_phenotype1.txt",sep='\t')
#a = pd.DataFrame(transform(np.array(df)))
#q.fit_transform(i)需要输入二维np.array
#a.columns = list(df.columns)
#a.index=list(df.index)
