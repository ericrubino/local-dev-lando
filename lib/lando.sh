#!/bin/bash

script_dir="$(dirname "$0")"
source "$script_dir/functions.sh"

echo -n "Creating .landorc and including it in .bashrc... "
echo 'export LANDO_HOST_NAME_DEV=host.wsl.internal' | tee "$HOME/.landorc" > /dev/null
echo 'export LANDO_HOST_GATEWAY_DEV=$(cat /etc/resolv.conf | grep nameserver | awk '"'"'{print $2; exit;}'"'"')' | tee -a "$HOME/.landorc" > /dev/null
grep -qxF 'source "$HOME/.landorc"' "$HOME/.bashrc" || echo 'source "$HOME/.landorc"' | tee -a "$HOME/.bashrc" > /dev/null
print_command_result

echo -n "Sourcing .landorc... "
. "$HOME/.landorc"
print_command_result

echo "Installing lando... "
/bin/bash -c "$(curl -fsSL https://get.lando.dev/setup-lando.sh)"
