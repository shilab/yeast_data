from __future__ import print_function
import sys

filename = sys.argv[1]

chr_convert = {"Chromosome I":1, "Chromosome II":2, "Chromosome III":3, 
                "Chromosome IV":4, "Chromosome V":5, "Chromosome VI": 6, 
                "Chromosome VII": 7, "Chromosome VIII": 8, "Chromosome IX": 9,
                "Chromosome X":10, "Chromosome XI": 11, "Chromosome XII": 12,
                "Chromosome XIII": 13, "Chromosome XIV": 14, "Chromosome XV": 15,
                "Chromosome XVI": 16}

print("id\tchr\tstart\tstop")

with open(filename, "r") as f:
    for line in f:
        if line[0]=="!" or line[0]=="^" or line[0]=="#" or line[0]=="I":
            continue
        temp = line.split("\t")
        raw_pos_annot = temp[14].split(",")
        if temp[14] == "":
            continue
        raw_chr = raw_pos_annot[0]
        raw_pos = raw_pos_annot[1].split("(")
        start, stop = raw_pos[1].split("..")
        if ")" in stop:
            stop = stop[0:-1]
        print(temp[0]+"\t"+str(chr_convert[raw_chr])+"\t"+start+"\t"+stop)
