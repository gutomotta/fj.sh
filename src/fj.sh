#!/bin/bash

source_file=fj.sh
source_command="source $source_file"

if test ! -f $source_file
then
    echo "$0: Could not find a $source_file file in the current directory! You should probably create one :)"
    exit 1
fi

if egrep "^$source_command$" $source_file
then
    echo "$0: You are sourcing $source_file in $source_file - that would lead to an infinite loop!"
    exit 1
fi

$source_command

task="$1"
shift 1

$task "$@"
