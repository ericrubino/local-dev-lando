#!/bin/bash

script_dir="$(dirname "$0")"
source "$script_dir/functions.sh"

# Cache sudo password
sudo ls > /dev/null

echo -n "Setting up sudo... "

if [[ -f /etc/sudoers.d/user ]]; then
    print_skipped
else
    echo "$USER ALL=(ALL)  NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/user" > /dev/null
    print_command_result
fi
