#!/bin/bash

# source common function script
scriptdir="$(dirname $(readlink -f $0))"
basedir="$scriptdir/.."

source "$basedir/common.sh"
getDefaultOptions $@

for fq in $input/*.f[aq]*
do
	fqname="$(basename $fq)"
	sample=$(basename $output)
	outputFile="$output/${fqname%%.*}.$args.fq.gz"
	seqtk sample "$fq" $args | gzip - >"$outputFile"
done
