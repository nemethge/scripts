#!/bin/bash

echo "╔══════════════════════════════════════════════════╗"
echo "║            Hostname beállító script              ║"
echo "╚══════════════════════════════════════════════════╝"

read -p "Kérem, adja meg az új hostname-t: " new_hostname

if [ -z "$new_hostname" ]; then
  echo "Nem adott meg hostname-t. A művelet megszakítva."
  exit 1
fi

# Beállítja az új hostname-t a hostnamectl segítségével
sudo hostnamectl set-hostname $new_hostname

# Eltávolítja a régi 127.0.0.1-hez rendelt bejegyzéseket
sudo sed -i '/127.0.0.1/!b;/localhost/!d' /etc/hosts

# Hozzáadja az új hostname-t az /etc/hosts fájlhoz
echo "127.0.0.1 $new_hostname" | sudo tee -a /etc/hosts

echo "Az új hostname sikeresen beállítva: $new_hostname"
