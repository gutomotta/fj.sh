#!/bin/bash

source_file=fj.sh
source_command="source $source_file"

if egrep "^$source_command$" $source_file
then
    echo "$0: You are sourcing $source_file in $source_file - that would lead to an infinite loop!"
    exit 1
fi

source fj.sh

task="$1"
shift 1

$task "$@"
