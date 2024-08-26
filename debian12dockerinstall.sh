#!/bin/bash

# 1. Frissítsd a csomaglistát és telepítsd a szükséges csomagokat:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# 2. Hozd létre a kulcstartó könyvtárat, ha még nem létezik:
sudo install -m 0755 -d /etc/apt/keyrings

# 3. Töltsd le és add hozzá a Docker hivatalos GPG kulcsát:
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null

# 4. Állítsd be a megfelelő jogosultságokat a kulcsra:
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 5. Add hozzá a Docker repository-t:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 6. Frissítsd a csomaglistát és telepítsd a Docker csomagokat:
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 7. Ellenőrizd a Docker telepítését:
sudo docker run hello-world
