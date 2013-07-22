#!/bin/bash

# source common function script
scriptdir="$(dirname $(readlink -f $0))/.."

source "$scriptdir/common.sh"
getDefaultOptions

scythe $args -o $output $input