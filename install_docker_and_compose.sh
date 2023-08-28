#!/bin/bash

# Update the package list
sudo apt-get update

# Install Docker and related packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Optionally add the user to the docker group (be aware of the security implications)
read -p "Would you like to add your user to the docker group? [y/N] " decision
if [[ "$decision" == "y" || "$decision" == "Y" ]]; then
    sudo groupadd docker
    sudo usermod -aG docker $USER
    echo "User added to the docker group."
else
    echo "Skipped adding user to the docker group."
fi

# Install Docker Compose from the official GitHub page
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Docker and Docker Compose installation completed."
