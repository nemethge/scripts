#!/bin/bash

# Prompt the user to enter the ID of the virtual machine they wish to unlock and delete
read -p "Enter the ID of the virtual machine you wish to unlock and delete: " vmid

# Check if the virtual machine exists
if ! qm status $vmid > /dev/null 2>&1; then
  echo "Virtual machine with ID $vmid does not exist"
  exit 1
fi

# Check if the virtual machine is already stopped
if qm status $vmid | grep -q stopped; then
  echo "Virtual machine with ID $vmid is already stopped"
else
  # Stop the virtual machine
  qm stop $vmid --timeout 30
  if [ $? -ne 0 ]; then
    echo "Failed to stop virtual machine with ID $vmid"
    exit 1
  else
    echo "Virtual machine with ID $vmid stopped successfully"
  fi
fi

# Unlock the virtual machine
qm unlock $vmid
if [ $? -ne 0 ]; then
  echo "Failed to unlock virtual machine with ID $vmid"
  exit 1
else
  echo "Virtual machine with ID $vmid unlocked successfully"
fi

# Delete the virtual machine
qm destroy $vmid
if [ $? -ne 0 ]; then
  echo "Failed to delete virtual machine with ID $vmid"
  exit 1
else
  echo "Virtual machine with ID $vmid deleted successfully"
fi
