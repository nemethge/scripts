#!/bin/bash

# Step 1: Update the package lists
sudo apt-get update

# Step 2: Install required packages
sudo apt-get install ca-certificates curl gnupg -y

# Step 3: Create the directory for keyrings
sudo install -m 0755 -d /etc/apt/keyrings

# Step 4: Download and add Docker's GPG key to keyring
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Step 5: Set appropriate permissions for the GPG key
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Step 6: Add Docker repository to sources.list
echo "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
$(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Step 7: Update package lists again after adding the repository
sudo apt-get update

# Step 8: Install Docker packages
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
