#!/bin/bash

# Fájlnév, amelyben az IP-címek listája található
ip_file="blocked_ips.txt"

# Tiltott portok
blocked_ports=("80" "443")

# IP-címek beolvasása a fájlból
readarray -t ips < "$ip_file"

# Firewalld szabályok hozzáadása
for ip in "${ips[@]}"
do
    # Tiltott portokhoz való hozzáférés letiltása
    for port in "${blocked_ports[@]}"
    do
        sudo firewall-cmd --permanent --add-rich-rule="rule family='ipv4' source address='$ip' port port='$port' protocol='tcp' reject"
    done
done

# Firewalld szabályok újratöltése
sudo firewall-cmd --reload
