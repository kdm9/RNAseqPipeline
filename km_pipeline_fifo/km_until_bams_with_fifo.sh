#!/bin/bash

wsdir="/home/kevin/ws"
refdir="${wsdir}/refseqs"

sample=$1

# setup

if [ ! -d reads ]
then
	echo "No ./reads/ directory"
	exit -1
fi

if [ ! -d reads/${sample} ]
then
	echo "Error: sample '${sample}' does not exist"
	exit -1
fi


################################ QC ############################################ 
#echo "Initial FastQC"
#mkdir -p qc/before/${sample}
#time bash ${scriptdir}/01-qc/fastqc.sh -i reads/${sample} -o qc/before/${sample} -a ""
#check_return

## SCYTHE ##
echo "Run scythe"
mkdir -p qcd/${sample}/

scythe_in="$(find reads/${sample} -name \*.f[aq]\*)"
scythe_out="qcd/${sample}"
scythe_args="-a ${refdir}/truseq_adapters.fasta"
for fq in $scythe_in
do
	fqname="$(basename $fq)"
	outputFile="$scythe_out/${fqname%%.*}.noadapt.fifo"
	mkfifo ${outputFile}
	echo "scythe $scythe_args $fq >$outputFile &"
done


################################### align #########################################
echo "Align with subread"

mkdir -p align/${sample}

subread_in="$(find ${scythe_out} -type p | sort)" # need sort to keep R1/R2 files in order 
subread_out="align/${sample}/${sample}.fifo"
subread_args="-i ${refdir}/TAIR10_gen/TAIR10_gen"

mkfifo ${subread_out}
fq1="$(echo $subread_in |cut -d ' ' -f 1)"
fq2="$(echo $subread_in |cut -d ' ' -f 2)"
echo "subread-align $subread_args -r \"${fq1}\" -R \"${fq2}\" -o \"$subread_out\" &"


echo "samtools view -S -b $subread_out >\"$(basename subread_out .fifo).bam\""

# remove temps/fifos
echo "find -type p -delete"
