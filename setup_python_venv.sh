#!/bin/bash

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is not installed. Installing Python 3..."
    sudo apt update
    sudo apt install -y python3 python3-venv
else
    echo "Python 3 is already installed."
fi

# Check if venv module is available
if ! python3 -m venv --help &> /dev/null; then
    echo "Python 3 venv module is not installed. Installing python3-venv..."
    sudo apt install -y python3-venv
else
    echo "Python 3 venv module is already available."
fi

# Prompt for the virtual environment name
read -p "Enter the name for your virtual environment: " venv_name

# Create the virtual environment
python3 -m venv "$venv_name"
echo "Virtual environment '$venv_name' created."

# Activate the virtual environment
echo "Activating the virtual environment..."
source "$venv_name/bin/activate"

echo "Virtual environment '$venv_name' is now active. You can install packages using 'pip'."
echo "To deactivate, simply type 'deactivate'."
