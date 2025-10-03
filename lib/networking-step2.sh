#!/bin/bash

script_dir="$(dirname "$0")"
source "$script_dir/functions.sh"

# Cache sudo password
sudo ls > /dev/null

echo -n "Backing up /etc/resolv.conf... "
if [ -f /etc/resolv.conf.orig ]; then
    print_skipped
elif [ -f /etc/resolv.conf ]; then
    sudo cp /etc/resolv.conf /etc/resolv.conf.orig > /dev/null
    print_command_result
else
    print_skipped
fi

if [[ -L /etc/resolv.conf ]]; then
    echo -n "Removing old /etc/resolv.conf symlink... "
    sudo unlink /etc/resolv.conf > /dev/null
    print_command_result
fi

echo -n "Setting up resolv.conf to point to 8.8.8.8... "
echo 'nameserver 8.8.8.8' | sudo tee /etc/resolv.conf > /dev/null
print_command_result
