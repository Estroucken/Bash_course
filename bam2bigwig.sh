#!/usr/bin/env bash

#create and activate conda environment
source $(dirname $(dirname $(which mamba)))/etc/profile.d/conda.sh
conda create --name bam2bigwig --yes deeptools samtools
conda activate bam2bigwig

#define input and output arguments
input_dir=$1
output_dir=$2

#create output directory and copy input files into output dir
mkdir $output_dir
cp $input_dir/*.bam $output_dir

#create log
log=log.txt


#create list of input files for for loop
input_files=$(ls ${output_dir})
cd $output_dir

#loop over input files
for file in ${input_files[@]}; do
	file_no_suffix=${file%.*}
	echo $file_no_suffix >> $log
	outfile=$(basename $file_no_suffix).bw
	nice samtools index -b $file > $log 2>&1
	nice bamCoverage -b $file -o $outfile > $log 2>&1
done

rm *.bam
rm *.bai

echo Emma Stroucken
