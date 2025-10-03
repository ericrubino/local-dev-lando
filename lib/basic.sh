#!/bin/bash

script_dir="$(dirname "$0")"
source "$script_dir/functions.sh"

NODE_VERSION=20
PHP_VERSION=8.3

WINDOWS_USER=""
GIT_NAME=""
GIT_EMAIL=""

if [[ $# -gt 0 ]]; then
    WINDOWS_USER="$1"
fi

if [[ $# -gt 1 ]]; then
    GIT_NAME="$2"
fi

if [[ $# -gt 2 ]]; then
    GIT_EMAIL="$3"
fi

if [[ "$WINDOWS_USER" == "" ]]; then
    read -p "Windows Username: " WINDOWS_USER
fi

if [[ "$GIT_NAME" == "" ]]; then
    read -p "Full Name: " GIT_NAME
fi

if [[ "$GIT_EMAIL" == "" ]]; then
    read -p "Email Address: " GIT_EMAIL
fi

echo -n "Installing the latest system updates (this could take a while)... "
sudo apt-get -qq update > /dev/null &&
sudo apt-get -qq upgrade -y &> /dev/null &&
sudo apt-get -qq autoremove -y > /dev/null
print_command_result

echo -n "Installing dev packages... "
sudo add-apt-repository -y ppa:ondrej/php > /dev/null &&
sudo apt-get -qq install -y --no-install-recommends apt-transport-https ca-certificates curl gnupg2 > /dev/null &&
sudo apt-get -qq install -y git unzip php${PHP_VERSION}-cli php${PHP_VERSION}-curl php${PHP_VERSION}-mysql php${PHP_VERSION}-xml php${PHP_VERSION}-mbstring php${PHP_VERSION}-gd php${PHP_VERSION}-xdebug php${PHP_VERSION}-zip > /dev/null &&
sudo update-alternatives --set php /usr/bin/php${PHP_VERSION} > /dev/null
print_command_result

echo -n "Configuring git... "
git config --global user.name "$GIT_NAME" > /dev/null && git config --global user.email "$GIT_EMAIL" > /dev/null
print_command_result

echo -n "Installing composer... "
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php > /dev/null &&
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer > /dev/null
print_command_result

echo -n "Installing Node $NODE_VERSION... "
curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash - > /dev/null &&
sudo apt-get -qq update > /dev/null &&
sudo apt-get -qq install -y nodejs > /dev/null
print_command_result

echo -n "Installing gulp-cli... "
sudo npm install --silent -g gulp-cli &> /dev/null
print_command_result

if [ ! -d "$HOME/.ssh" ]; then
    echo -n "Creating $HOME/.ssh directory... "
    mkdir -p "$HOME/.ssh" > /dev/null &&
    chmod 700 "$HOME/.ssh"
    print_command_result
fi

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    if [ -f "/mnt/c/Users/${WINDOWS_USER}/.ssh/id_rsa" ]; then
        echo -n "Copying Windows SSH key... "
        cp -f "/mnt/c/Users/${WINDOWS_USER}/.ssh/id_rsa" "$HOME/.ssh/id_rsa" > /dev/null &&
        cp -f "/mnt/c/Users/${WINDOWS_USER}/.ssh/id_rsa.pub" "$HOME/.ssh/id_rsa.pub" > /dev/null &&
        chmod 400 "$HOME/.ssh/id_rsa" "$HOME/.ssh/id_rsa.pub" > /dev/null
        print_command_result
    else
        echo -n "Generating a new SSH key... "
        ssh-keygen -q -f "$HOME/.ssh/id_rsa" -N "" > /dev/null
        print_command_result

        if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
            echo "You have a new SSH key in WSL2. Please make sure to add the following key to BitBucket:"
            cat "$HOME/.ssh/id_rsa.pub"
            echo ""
            read -p 'Press any key to continue.' var
        fi
    fi
fi

if [ -f "$HOME/.ssh/id_rsa" ] && [ ! -f "/mnt/c/Users/${WINDOWS_USER}/.ssh/id_rsa" ]; then
    if [ ! -d "/mnt/c/Users/${WINDOWS_USER}/.ssh" ]; then
        echo -n "Creating .ssh folder in your Windows profile... "
        mkdir -p "/mnt/c/Users/${WINDOWS_USER}/.ssh" > /dev/null
        print_command_result
    fi

    echo -n "Copying SSH key to your Windows profile... "
    cp -f "$HOME/.ssh/id_rsa" "/mnt/c/Users/${WINDOWS_USER}/.ssh/id_rsa" > /dev/null &&
    cp -f "$HOME/.ssh/id_rsa.pub" "/mnt/c/Users/${WINDOWS_USER}/.ssh/id_rsa.pub" > /dev/null
    print_command_result
fi
