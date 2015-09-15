all: setup Data

Data: data/genotypes_forRelease_1_20_05.dat data/GSE1990_family.soft

setup:
	mkdir -p data
	mkdir -p results

data/genotypes_forRelease_1_20_05.dat:
	wget -P ./data http://blogs.ls.berkeley.edu/bremlab/files/2010/07/genotypes_forRelease_1_20_05.zip
	cd data && unzip genotypes_forRelease_1_20_05.zip

data/GSE1990_family.soft:
	wget -P ./data ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE1nnn/GSE1990/soft/GSE1990_family.soft.gz
	gunzip data/GSE1990_family.soft.gz
