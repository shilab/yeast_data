from __future__ import print_function
import sys
import math

filename = sys.argv[1]

with open(filename, 'r') as f:
    for line in f:
        if "!Sample_title" in line:
            header = line.rstrip()
            ids = header.split("\t")
            ids = ids[1:]
            i=0
            results = "id"
            while i<len(ids):
                id = ids[i].split("Cy")[0]
                if "_" in ids[i]:
                    id+="_"+ids[i].split("_")[1]
                results+="\t" + id
                i+=2
            print(results)
        else:
            samples = line.rstrip().split('\t')
            id = samples[0]
            samples = samples[1:]
            i=0
            results=id+"\t"
            while i<len(samples):
                if (samples[i]=="NULL" or samples[i+1]=="NULL"):
                    results+="\tNULL"
                elif (samples[i]=="0.000000" or samples[i+1]=="0.000000"):
                    results+="\t0"
                else:
                    results+="\t" + str((float(samples[i])+float(samples[i+1])/2))
                i+=2
            print(results)
