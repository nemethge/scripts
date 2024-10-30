#!/bin/bash

# Proxmox API és token adatok
PROXMOX_IP="192.168.*.*"
NODE="pve"
TOKEN_ID="terraform_user@pve!terraform_13"
TOKEN_SECRET="*****************************"

# Eredmény fájl az Ansible inventory formátumhoz
OUTPUT_FILE="ansible_inventory.txt"
echo "[proxmox_vms]" > $OUTPUT_FILE

# Az összes VM lekérdezése a megadott node-ról
VM_LIST=$(curl -k -s "https://${PROXMOX_IP}:8006/api2/json/nodes/${NODE}/qemu" \
    -H "Authorization: PVEAPIToken=${TOKEN_ID}=${TOKEN_SECRET}" | jq -r '.data[].vmid')

# Minden VM IP-címének lekérdezése a QEMU Agent segítségével
for VMID in $VM_LIST; do
    # Guest Agent hálózati interfész adatok lekérdezése
    AGENT_DATA=$(curl -k -s "https://${PROXMOX_IP}:8006/api2/json/nodes/${NODE}/qemu/${VMID}/agent/network-get-interfaces" \
        -H "Authorization: PVEAPIToken=${TOKEN_ID}=${TOKEN_SECRET}")
    
    # VM neve lekérdezése
    VM_NAME=$(curl -k -s "https://${PROXMOX_IP}:8006/api2/json/nodes/${NODE}/qemu/${VMID}/config" \
        -H "Authorization: PVEAPIToken=${TOKEN_ID}=${TOKEN_SECRET}" | jq -r '.data.name')

    # IP címek keresése az ens18 interfészen (csak ipv4 típusú címek)
    IP_ADDRESS=$(echo "$AGENT_DATA" | jq -r '.data.result[] | select(.name == "ens18") | .["ip-addresses"][] | select(.["ip-address-type"] == "ipv4") | .["ip-address"]')

    # Ha talált IP-címet, akkor hozzáadjuk az Ansible inventory fájlhoz
    if [ -n "$IP_ADDRESS" ]; then
        echo "$VM_NAME ansible_host=$IP_ADDRESS" >> $OUTPUT_FILE
    fi
done

# Eredmény kiíratása
echo "Az Ansible inventory fájlt mentettük a következő fájlba: $OUTPUT_FILE"
