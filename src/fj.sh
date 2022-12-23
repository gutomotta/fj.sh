#!/usr/bin/env bash

task="$1"

source_file=fj.sh
source_command="source $source_file"

available_tasks=()

set -o errexit
set -o nounset
set -o pipefail

GENERIC_ERROR_CODE=1
INVALID_OPT_ERROR_CODE=2

if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

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

__load_tasks() {
    $source_command

    for tsk in $(declare -F | cut -d' ' -f3-)
    do
        # Do not include private functions in available_tasks
        [[ "$tsk" == __* ]] && continue
        available_tasks+=($tsk)
    done
}

__read_opts() {
    # Transform long opts in short opts
    for arg in "$@"
    do
        shift
        case "$arg" in
            '--help')
                set -- "$@" '-h'
                ;;
            '--list')
                set -- "$@" '-l'  
                ;;
            --*)
                echo "Invalid option: $arg"
                exit $INVALID_OPT_ERROR_CODE
                ;;
            *) 
                set -- "$@" "$arg"
                ;;
        esac
    done

    while getopts ":hl" opt; do
        case "${opt}" in
            h)
                echo "At the moment, fj.sh does not have an usage description."

                exit 0
                ;;
            l)
                echo "Tasks defined in your $source_file file are: "
                echo
                for tsk in "${available_tasks[@]}"
                do
                    echo $tsk
                done
                echo

                exit 0
                ;;
            ?)
                echo "Invalid option: -${OPTARG}."

                exit 2
                ;;
        esac
    done
}

__run_task() {
    shift 1
    $task "$@"
}

main() (
    __load_tasks
    __read_opts "$@"
    __run_task "$@"
)

main "$@"
