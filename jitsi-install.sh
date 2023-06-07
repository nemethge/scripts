#!/bin/bash

# Update the system
apt-get update
apt-get upgrade -y

# Install gnupg2 if not present
if ! command -v gpg > /dev/null; then
    apt-get install -y gnupg2
fi

# Install OpenJDK
apt-get install -y openjdk-11-jre-headless

# Add the Jitsi repository
echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list
wget -qO -  https://download.jitsi.org/jitsi-key.gpg.key | apt-key add -

# Update the package list
apt-get update

# Check if the repository is added successfully
if ! apt-cache policy | grep -q 'download.jitsi.org'; then
    echo "Failed to add Jitsi repository"
    exit 1
fi

# Install Jitsi Meet
apt-get install -y jitsi-meet

# Configure Jitsi Meet
if [ -f /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh ]; then
    /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
else
    echo "Failed to find Let's Encrypt script"
    exit 1
fi
