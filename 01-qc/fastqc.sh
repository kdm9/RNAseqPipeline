#!/bin/bash
set -o nounset
set -o errexit


# source common function script
scriptdir="$(dirname $(readlink -f $0))"
basedir="$scriptdir/.."

source "$basedir/common.sh"
getDefaultOptions $@

fqfiles=$(findFastqFiles $input/)

echo fastqc $args -o "$output" $fqfiles
fastqc $args -o "$output" $fqfiles
