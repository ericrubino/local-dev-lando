#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)
NORMAL=$(tput sgr0)
COL=0

print_result () {
    result=$1
    color=$2

    if [ -z "$result" ]; then
        result="OK"
    fi

    if [ -z "$color" ]; then
        color="$GREEN"
    fi

    printf '%s%*s%s\n' "$color" $COL "[$result]" "$NORMAL"
}

print_command_result () {
    if [ $? -eq 0 ]; then
        print_ok
    else
        print_error
    fi
}

print_ok () {
    print_result "OK" "$GREEN"
}

print_skipped () {
    print_result "SKIPPED" "$CYAN"
}

print_error () {
    print_result "ERROR" "$RED"
}
