#!/bin/bash

script_dir="$(dirname "$0")"
source "$script_dir/functions.sh"

if [[ -f /etc/wsl.conf ]]; then
    print_skipped
else
    echo '[network]
generateResolvConf = false' | sudo tee /etc/wsl.conf > /dev/null
    print_command_result
fi
