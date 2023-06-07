#!/bin/bash

# Define source VM ID and target VM names
src_vmid=100
declare -a vm_names=("node1" "node2")

# Get maximum existing VM ID
max_vmid=$(qm list | awk 'NR>1 {print $1}' | sort -nr | head -n 1)

# If no VMs exist yet, start with ID 101
if [[ -z "$max_vmid" ]]; then
  max_vmid=100
fi

# Loop over vm_names
for vm_name in "${vm_names[@]}"
do
    # Increment max_vmid to get the next available VM ID
    ((max_vmid++))

    # Clone the VM
    qm clone $src_vmid $max_vmid --name $vm_name
    if [ $? -ne 0 ]; then
      echo "Failed to clone VM to $vm_name"
      exit 1
    else
      echo "Cloned VM to $vm_name successfully"
    fi
done
