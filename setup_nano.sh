#!/bin/bash

# ==========================================
# Nano Editor Setup Script
# Installs syntax highlighting and useful defaults
# Compatible with: Debian/Ubuntu/Mint
# ==========================================

NANORC_FILE="$HOME/.nanorc"
NANO_SYNTAX_DIR="$HOME/.nano"

echo ">> Starting Nano configuration setup..."

# 1. Check for Git (required to clone syntax definitions)
if ! command -v git &> /dev/null; then
    echo ">> Git not found. Installing..."
    sudo apt update && sudo apt install -y git
else
    echo ">> Git is already installed."
fi

# 2. Install or Update Syntax Highlighting (scopatz/nanorc)
if [ -d "$NANO_SYNTAX_DIR" ]; then
    echo ">> Syntax highlighting directory exists. Updating..."
    cd "$NANO_SYNTAX_DIR" && git pull
else
    echo ">> Cloning syntax highlighting repository..."
    git clone https://github.com/scopatz/nanorc.git "$NANO_SYNTAX_DIR"
fi

# 3. Configure .nanorc
# Helper function to add config only if it doesn't exist
add_config() {
    local description="$1"
    local command="$2"
    
    if grep -Fxq "$command" "$NANORC_FILE"; then
        echo "   [SKIP] $description (already active)"
    else
        echo "$command" >> "$NANORC_FILE"
        echo "   [OK] Added $description"
    fi
}

echo ">> Applying settings to $NANORC_FILE..."
touch "$NANORC_FILE"

# --- Configuration Section ---

# Syntax highlighting include (must use full path, NOT ~)
add_config "Syntax Highlighting include" "include \"$HOME/.nano/*.nanorc\""

# UI Settings
add_config "Line Numbers" "set linenumbers"
add_config "Mouse Support" "set mouse"
# NOTE: Nano 8.x does NOT support set smooth → removed

# Indentation Settings
add_config "Auto Indentation" "set autoindent"
add_config "Tab Size (4 spaces)" "set tabsize 4"
add_config "Convert Tabs to Spaces" "set tabstospaces"

# System Settings
# Nano 8.x does NOT support 'set nobackup' → removed

echo ">> Setup complete! Open nano to see the changes."
