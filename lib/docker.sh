#!/bin/bash

script_dir="$(dirname "$0")"
source "$script_dir/functions.sh"

echo -n "Installing Docker... "
sudo install -m 0755 -d /etc/apt/keyrings > /dev/null &&
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc > /dev/null &&
sudo chmod a+r /etc/apt/keyrings/docker.asc > /dev/null &&
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -qq update > /dev/null &&
sudo apt-get -qq install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y > /dev/null &&
sudo usermod -aG docker $USER > /dev/null
print_command_result

echo -n "Creating docker-service script... "
echo 'DOCKER_DISTRO="Ubuntu"
DOCKER_LOG_DIR=$HOME/docker_logs
mkdir -pm o=,ug=rwx "$DOCKER_LOG_DIR"
/mnt/c/Windows/System32/wsl.exe -d $DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > $DOCKER_LOG_DIR/dockerd.log 2>&1"
' | sudo tee /usr/bin/docker-service > /dev/null &&
sudo chmod +x /usr/bin/docker-service > /dev/null
print_command_result

echo -n "Setting up sudo access for dockerd... "
echo '%docker ALL=(ALL)  NOPASSWD: /usr/bin/dockerd' | sudo tee /etc/sudoers.d/dockerd > /dev/null
print_command_result

echo -n "Adding docker-service command to $HOME/.profile... "
if sudo grep -q 'docker-service' "$HOME/.profile"; then
    print_skipped
else
    echo 'docker-service' >> $HOME/.profile
    print_ok
fi

echo -n "Starting docker... "
docker-service > /dev/null
print_command_result
