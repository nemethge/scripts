#!/bin/bash

# Define source VM ID
src_vmid=100

# Get maximum existing VM ID
max_vmid=$(qm list | awk 'NR>1 {print $1}' | sort -nr | head -n 1)

# If no VMs exist yet, start with ID 101
if [[ -z "$max_vmid" ]]; then
  max_vmid=100
fi

# Ask for the number of nodes to create
read -p "How many nodes do you need to create? " node_count

# Check if the input is a number
if ! [[ "$node_count" =~ ^[0-9]+$ ]]; then
   echo "Invalid input! Please enter a number."
   exit 1
fi

# Loop to create the specified number of nodes
for (( i=1; i<=node_count; i++ ))
do
    # Increment max_vmid to get the next available VM ID
    ((max_vmid++))

    # Generate a VM name
    vm_name="node$i"

    # Clone the VM
    qm clone $src_vmid $max_vmid --name $vm_name
    if [ $? -ne 0 ]; then
      echo "Failed to clone VM to $vm_name"
      exit 1
    else
      echo "Cloned VM to $vm_name successfully"
    fi
done
