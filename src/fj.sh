#!/usr/bin/env bash

VERSION=0.4.0

GENERIC_ERROR_CODE=1
INVALID_OPT_ERROR_CODE=2
INVALID_TASK_ERROR_CODE=3

set -o errexit
set -o nounset
set -o pipefail

if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

main() (
    task_called="$1"
    source_file=fj.sh
    source_command="source $source_file"
    available_tasks=()

    __validate_fjsh_file "$@"
    __load_tasks
    __read_opts "$@"
    __validate_task_called_is_defined
    __run_task "$@"
)

__load_tasks() {
    $source_command

    unset -f main

    task_called_is_defined=0
    for tsk in $(declare -F | cut -d' ' -f3-)
    do
        # Do not include private functions in available_tasks
        [[ "$tsk" == __* ]] && continue

        # Store available tasks in a list
        available_tasks+=($tsk)

        # For validating that the task called is defined
        if [[ "$tsk" == "$task_called" ]]
        then
            task_called_is_defined=1
        fi
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
            '--version')
                set -- "$@" '-v'
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

    while getopts ":hlv" opt; do
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
            v)
                echo $VERSION

                exit 0
                ;;
            ?)
                echo "Invalid option: -${OPTARG}"

                exit $INVALID_OPT_ERROR_CODE
                ;;
        esac
    done
}

__run_task() {
    shift 1
    $task_called "$@"
}

__validate_fjsh_file() {
    if test ! -f $source_file
    then
        echo "$0: Couldn't find a $source_file file in the current directory. Please create one and define your tasks first."
        exit $GENERIC_ERROR_CODE
    fi

    if egrep "^$source_command$" $source_file
    then
        echo "$0: You are sourcing $source_file in $source_file - that would lead to an infinite loop!"
        exit $GENERIC_ERROR_CODE
    fi
}

__validate_task_called_is_defined() {
    if [[ $task_called_is_defined -eq 0 ]]
    then
        echo "The task $task_called is not defined in your $source_file file."
        exit $INVALID_TASK_ERROR_CODE
    fi
}

main "$@"
