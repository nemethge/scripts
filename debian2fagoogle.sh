#!/bin/bash

# Exit on error
set -e

echo "Starting SSH 2FA setup..."

# Update package list and install necessary packages
sudo apt update && sudo apt install -y libpam-google-authenticator

# Configure time synchronization
echo "Configuring time synchronization..."
if systemctl is-active --quiet ntpsec.service; then
    echo "ntpsec is already running, skipping NTP setup"
elif systemctl is-active --quiet ntp.service; then
    echo "ntp is already running, skipping NTP setup"
else
    # Install and configure ntpsec (preferred on Debian)
    sudo apt install -y ntpsec
    sudo systemctl enable ntpsec.service
    sudo systemctl start ntpsec.service
fi

# Backup original config files
echo "Creating backups of configuration files..."
sudo cp /etc/pam.d/sshd /etc/pam.d/sshd.bak
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Configure PAM for SSH
echo "Configuring PAM..."
# Create new PAM configuration
cat << 'EOF' | sudo tee /etc/pam.d/sshd
# Standard Un*x password updating.
@include common-password

# Standard Un*x authentication.
@include common-auth

# Google Authenticator
auth required pam_google_authenticator.so nullok

# Standard Un*x session setup and teardown.
@include common-session

# Print the message of the day upon successful login.
session optional pam_motd.so motd=/run/motd.dynamic
session optional pam_motd.so noupdate

# Print the status of the user's mailbox upon successful login.
session optional pam_mail.so standard noenv
EOF

# Configure SSH
echo "Configuring SSH..."
# Create a temporary file with the new SSH configuration
cat << 'EOF' > /tmp/sshd_config_new
# SSH 2FA Configuration
PasswordAuthentication yes
ChallengeResponseAuthentication yes
KbdInteractiveAuthentication yes
UsePAM yes
AuthenticationMethods password,keyboard-interactive

# Keep existing settings
Port 22
Protocol 2
PermitRootLogin no
X11Forwarding no
EOF

# Append the existing config without the parameters we're explicitly setting
grep -vE '^(PasswordAuthentication|ChallengeResponseAuthentication|KbdInteractiveAuthentication|UsePAM|AuthenticationMethods)' /etc/ssh/sshd_config >> /tmp/sshd_config_new

# Replace the old config with the new one
sudo mv /tmp/sshd_config_new /etc/ssh/sshd_config
sudo chmod 644 /etc/ssh/sshd_config
sudo chown root:root /etc/ssh/sshd_config

# Test SSH configuration
echo "Testing SSH configuration..."
sudo sshd -t
if [ $? -ne 0 ]; then
    echo "SSH configuration test failed. Rolling back changes..."
    sudo cp /etc/pam.d/sshd.bak /etc/pam.d/sshd
    sudo cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
    sudo systemctl restart ssh
    exit 1
fi

# Restart SSH service
echo "Restarting SSH service..."
sudo systemctl restart ssh

# Print instructions
echo "Installation complete! Please follow these steps:"
echo "1. Run 'google-authenticator' command to set up 2FA for your user"
echo "2. When prompted:"
echo "   - Answer 'y' to time-based tokens"
echo "   - Scan the QR code with your authenticator app"
echo "   - Answer 'y' to update your ~/.google_authenticator file"
echo "   - Answer 'y' to disallow multiple uses"
echo "   - Answer 'n' to increase window"
echo "   - Answer 'y' to rate limiting"
echo ""
echo "IMPORTANT: Keep your SSH session open and test the new configuration in a new terminal!"
echo "The login sequence will be:"
echo "1. First enter your password"
echo "2. Then enter your Google Authenticator code"
echo ""
echo "If you can't log in, restore the backup files:"
echo "sudo cp /etc/pam.d/sshd.bak /etc/pam.d/sshd"
echo "sudo cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config"
echo "sudo systemctl restart ssh"  
