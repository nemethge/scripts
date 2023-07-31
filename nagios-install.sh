#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt -y full-upgrade

# Check if reboot is required
if [ -f /var/run/reboot-required ]; then
    sudo reboot -f
fi

# Install necessary packages
sudo apt install vim wget curl build-essential unzip openssl libssl-dev apache2 php libapache2-mod-php php-gd libgd-dev -y

# Navigate to home directory
cd ~

# Get the latest version of Nagios
NAGIOS_VER=$(curl -s https://api.github.com/repos/NagiosEnterprises/nagioscore/releases/latest|grep tag_name | cut -d '"' -f 4)

# Download and extract Nagios
wget https://github.com/NagiosEnterprises/nagioscore/releases/download/$NAGIOS_VER/$NAGIOS_VER.tar.gz
tar xvzf $NAGIOS_VER.tar.gz
cd $NAGIOS_VER

# Configure and install Nagios
./configure --with-httpd-conf=/etc/apache2/sites-enabled
sudo make install-groups-users
sudo usermod -a -G nagios www-data
sudo make all
sudo make install
sudo make install-daemoninit
sudo make install-commandmode
sudo make install-config
sudo make install-webconf

# Configure Apache
sudo a2enmod rewrite cgi
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
sudo chown www-data:www-data /usr/local/nagios/etc/htpasswd.users
sudo chmod 640 /usr/local/nagios/etc/htpasswd.users

# Navigate to home directory
cd ~

# Get the latest version of Nagios plugins
VER=$(curl -s https://api.github.com/repos/nagios-plugins/nagios-plugins/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/release-//')

# Download and extract Nagios plugins
wget https://github.com/nagios-plugins/nagios-plugins/releases/download/release-$VER/nagios-plugins-$VER.tar.gz
tar xvf nagios-plugins-$VER.tar.gz
cd nagios-plugins-$VER

# Configure and install Nagios plugins
./configure --with-nagios-user=nagios --with-nagios-group=nagios
sudo make
sudo make install

# Restart Apache and start Nagios service
sudo systemctl restart apache2
sudo systemctl start nagios.service

# Display IP address
ip a
