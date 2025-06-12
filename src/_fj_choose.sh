#!/usr/bin/env bash

__fj_choose_prompt() {
    selected="$1"
    shift
    options=("$@")
    printf "Use arrows, j/k, or Ctrl-n/Ctrl-p to navigate, Enter to select:\n"
    for i in "${!options[@]}"
    do
        if [ "$i" -eq "$selected" ]
        then
            printf " > \033[1;32m%s\033[0m\n" "${options[i]}"
        else
            printf "   %s\n" "${options[i]}"
        fi
    done
}

_fj_choose() {
    if [ $# -lt 2 ]
    then
        printf "Usage: select_option <variable_name> <option1> [option2 ...]\n" >&2
        return 1
    fi

    local __resultvar=$1
    shift
    local options=("$@")

    if [ ${#options[@]} -eq 0 ]
    then
        printf "Error: No options provided.\n" >&2
        return 1
    fi

    local selected=0
    local ESC=$(printf "\033")
    local num_lines=$(( ${#options[@]} + 1 ))  # options + instruction line

    # Print initial menu once
    __fj_choose_prompt $selected "${options[@]}"

    while true
    do
        printf "\033[%dA" "$num_lines"  # move cursor up to redraw menu
        __fj_choose_prompt $selected "${options[@]}"

        IFS= read -rsn1 key

        if [[ $key == $ESC ]]
        then
            read -rsn2 key
            case $key in
                "[A") ((selected--)) || true;;  # Up arrow
                "[D") ((selected--)) || true;;  # Left arrow
                "[B") ((selected++)) || true;;  # Down arrow
                "[C") ((selected++)) || true;;  # Right arrow
            esac
        elif [[ $key == $'\x0e' ]]
        then
            ((selected++)) || true # Ctrl-n
        elif [[ $key == $'\x10' ]]
        then
            ((selected--)) || true # Ctrl-p
        elif [[ $key == "j" ]]
        then
            ((selected++)) || true
        elif [[ $key == "k" ]]
        then
            ((selected--)) || true
        elif [[ $key == "" ]]
        then
            # Assign result to variable named by $__resultvar
            local selected_value="${options[selected]}"

            # Safely assign to caller's variable
            if printf -v "$__resultvar" "$selected_value" 2>/dev/null
            then
                :
            else
                # fallback if printf -v not supported
                eval "$__resultvar=\"\$selected_value\""
            fi
            return 0
        fi

        # Wrap selection
        if [ $selected -lt 0 ]
        then
            selected=$((${#options[@]} - 1))
        elif [ $selected -ge ${#options[@]} ]
        then
            selected=0
        fi
    done
}
