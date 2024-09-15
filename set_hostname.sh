#!/bin/bash

set -e
set -o pipefail

echo "╔══════════════════════════════════════════════════╗"
echo "║              Hostname Configuration Script       ║"
echo "╚══════════════════════════════════════════════════╝"

# Update and upgrade the system
echo "Updating package lists and upgrading packages..."
sudo apt update -y && sudo apt upgrade -y

# Prompt the user for the new hostname
read -p "Please enter the new hostname: " new_hostname

# Check if the user provided a hostname
if [ -z "$new_hostname" ]; then
  echo "No hostname provided. Operation aborted."
  exit 1
fi

# Set the new hostname
echo "Setting the new hostname..."
sudo hostnamectl set-hostname "$new_hostname"

# Update /etc/hosts
echo "Updating /etc/hosts file..."
sudo sed -i "s/^127\.0\.0\.1.*$/127.0.0.1 localhost $new_hostname/" /etc/hosts

echo "The new hostname has been successfully set to: $new_hostname"
