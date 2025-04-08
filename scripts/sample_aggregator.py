from Bio import SeqIO
import pandas as pd
import os
import re

file_names = sorted([fn for fn in os.listdir(".") if '_count.txt' in fn])

f = file_names[0]
pattern = '_count.txt'
samplename = re.split(pattern, f, 1)[0]
all_count_table = pd.read_csv(f, names=['Seq', samplename])
all_count_table["Seq"] = all_count_table["Seq"].str.upper()

for f in file_names[1:]:
    samplename = re.split(pattern, f, 1)[0]
    #print(samplename)
    new_df = pd.read_csv(f, names=['Seq', samplename])
    new_df["Seq"] = new_df["Seq"].str.upper()
    all_count_table = pd.merge(all_count_table, new_df, on='Seq', how='outer')

all_count_table.to_csv('count_table.csv', index = False)
