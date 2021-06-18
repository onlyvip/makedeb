#!/usr/bin/env bash

# Install needed packages
echo "Installing needed packages..."
apt update
apt install wget sudo gpg git -y

wget -qO - "https://${proget_server}/debian-feeds/makedeb.pub" | gpg --dearmor | tee /usr/share/keyrings/makedeb-archive-keyring.gpg &> /dev/null
echo "deb [signed-by=/usr/share/keyrings/makedeb-archive-keyring.gpg arch=all] https://${proget_server} makedeb main" | tee /etc/apt/sources.list.d/makedeb.list

apt update
apt install makedeb -y

# Create user
useradd user

# Set perms
chmod 777 * -R

# Build makedeb
cd src
sudo -u user './makedeb.sh'