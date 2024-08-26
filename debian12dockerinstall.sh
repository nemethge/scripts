# Update the package index and install required packages for Docker's repository management:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# Create the keyrings directory if it doesn’t exist:
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker's official GPG key:
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null

# Ensure the GPG key has the appropriate permissions:
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the Docker repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index again and install Docker components:
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Test the Docker installation by running the hello-world container:
sudo docker run hello-world
