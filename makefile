SHELL=/bin/bash

all: setup Data

Data: data/genotype_matrix data/expression_matrix data/genotype_positions data/expression_positions

setup:
	mkdir -p data
	mkdir -p results

data/genotypes_forRelease_1_20_05.dat:
	wget -P ./data http://blogs.ls.berkeley.edu/bremlab/files/2010/07/genotypes_forRelease_1_20_05.zip
	cd data && unzip genotypes_forRelease_1_20_05.zip

data/genotypes_forRelease_1_20_05.dat.noinfo: data/genotypes_forRelease_1_20_05.dat
	awk '$$1 !~ /^#/ {print}' data/genotypes_forRelease_1_20_05.dat > data/genotypes_forRelease_1_20_05.dat.noinfo

data/genotypes_forRelease_1_20_05.dat.noinfo.new_header: data/genotypes_forRelease_1_20_05.dat.noinfo
	cat <(head -n 1 data/genotypes_forRelease_1_20_05.dat.noinfo | sed 's/_probePairKey/id/' | sed 's/_/-/g') <(tail -n +2 data/genotypes_forRelease_1_20_05.dat.noinfo) > data/genotypes_forRelease_1_20_05.dat.noinfo.new_header

data/GSE1990_series_matrix.txt:
	wget -P ./data ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE1nnn/GSE1990/matrix/GSE1990_series_matrix.txt.gz
	gunzip data/GSE1990_series_matrix.txt.gz

data/GSE1990_series_matrix.txt.noinfo: data/GSE1990_series_matrix.txt
	awk '($$1 !~ /^!/ && $$0!='\n' && $$1 !~ /"ID/) || $$1 ~ /^!Sample_title/ {print}' data/GSE1990_series_matrix.txt | sed 's/"//g' > data/GSE1990_series_matrix.txt.noinfo

data/GSE1990_series_matrix.txt.noinfo.avg: data/GSE1990_series_matrix.txt.noinfo
	python code/calculate_expr.py data/GSE1990_series_matrix.txt.noinfo > data/GSE1990_series_matrix.txt.noinfo.avg

code/overlap.py:
	wget --no-check-certificate -P ./code https://raw.githubusercontent.com/shilab/sample_overlap/315ffbf0c4e5d203f376afa7a6f4256268fb85c5/overlap/overlap.py

data/genotypes_forRelease_1_20_05.dat.noinfo.new_header.out: data/genotypes_forRelease_1_20_05.dat.noinfo.new_header data/GSE1990_series_matrix.txt.noinfo.avg code/overlap.py 
	python code/overlap.py data/genotypes_forRelease_1_20_05.dat.noinfo.new_header data/GSE1990_series_matrix.txt.noinfo.avg

data/GSE1990_series_matrix.txt.noinfo.avg.out: data/genotypes_forRelease_1_20_05.dat.noinfo.new_header.out

data/genotype_positions: data/genotypes_forRelease_1_20_05.dat.noinfo.new_header
	cut -f 1,127,128 data/genotypes_forRelease_1_20_05.dat.noinfo.new_header > data/genotype_positions

data/GPL118.annot:
	wget -P ./data ftp://ftp.ncbi.nlm.nih.gov/geo/platforms/GPLnnn/GPL118/annot/GPL118.annot.gz 
	gunzip data/GPL118.annot.gz

data/expression_positions: data/GPL118.annot
	python code/expression_pos.py data/GPL118.annot > data/expression_positions

data/genotype_matrix: data/genotypes_forRelease_1_20_05.dat.noinfo.new_header.out
	sed 's/\t2\t/\tNULL\t/g' data/genotypes_forRelease_1_20_05.dat.noinfo.new_header.out > data/genotype_matrix

data/expression_matrix: data/GSE1990_series_matrix.txt.noinfo.avg.out
	mv data/GSE1990_series_matrix.txt.noinfo.avg.out data/expression_matrix
