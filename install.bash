#!/bin/bash

# ────────────────────────────── INSTALL SCRIPT ────────────────────────────── #
#
#           This script will install/upgrade phakit and it's dependencies.
#           See more at https://github.com/Darknetzz/phakit
#
# ──────────────────────────────────────────────────────────────────────────── #

# ──────────────────────────────────────────────────────────────────────────── #
#                                   FUNCTIONS                                  #
# ──────────────────────────────────────────────────────────────────────────── #
update_symlinks() {
    local $DEST_PATH=${$1:-"/etc/phakit"}
    local $LINK_PATH=${$2:-"/usr/local/bin"}

    echo "Updating symlinks..."

    # Remove old links
    rm "$LINK_PATH/phakit"
    rm "$LINK_PATH/phakit.py"

    # Link `phakit` and the Python script to /usr/local/bin
    ln -s "$DEST_PATH/phakit" "$LINK_PATH/phakit"
    ln -s "$DEST_PATH/phakit.py" "$LINK_PATH/phakit.py"

    echo "Done!"
}

# ──────────────────────────────────────────────────────────────────────────── #
#                                   PRECHECKS                                  #
# ──────────────────────────────────────────────────────────────────────────── #
# Check if we are running bash
if [ -z "$BASH_VERSION" ]; then
    echo "[ERROR] Please run the installer using bash."
    exit 1
fi

# Make sure we have sudo access
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] Please run installer as root."
    exit 1
fi


# ──────────────────────────────────────────────────────────────────────────── #
#                                    CONFIG                                    #
# ──────────────────────────────────────────────────────────────────────────── #
# REVIEW: What folder should we use?

# Store current folder for later
CWD=$(pwd)

# Set link path (for symlinks)
LINK_PATH="/usr/local/bin"

# Set the temporary path and change directory
TEMP_PATH="$HOME/.phakit"
if [ ! -d "$TEMP_PATH" ]; then
    mkdir -p "$TEMP_PATH"
fi
cd "$TEMP_PATH"

# Set the destination path
DEST_PATH="/etc/phakit"
DEST_VERSION_FILE="$DEST_PATH/VERSION"
if [ -f "$DEST_VERSION_FILE" ]; then
    DEST_VERSION=$(cat "$DEST_VERSION_FILE")
else
    DEST_VERSION="0"
fi

GITHUB_VERSION=$(wget -O - https://raw.githubusercontent.com/Darknetzz/phakit/main/VERSION)

# Check if phakit is already installed
echo "Checking for existing version..."
if [ "$DEST_VERSION" == "0" ]; then
    echo "phakit not installed. Installing phakit..."
else
    echo "Version $DEST_VERSION of phakit is already installed in $DEST_PATH."
    echo "Checking for updates..."
    if [ $GITHUB_VERSION == $DEST_VERSION ]; then
        echo "No new updates available. Version $DEST_VERSION is up to date."
        update_symlinks "$DEST_PATH"
        exit 0
    fi
fi


echo "New version available ($GITHUB_VERSION)! Updating..."

# Clone the git repo
git clone https://github.com/Darknetzz/phakit.git "$TEMP_PATH"

# ──────────────────────────────────────────────────────────────────────────── #
#                                 REQUIREMENTS                                 #
# ──────────────────────────────────────────────────────────────────────────── #
REQUIREMENTS_SCRIPT="$TEMP_PATH/requirements.bash"
REQUIREMENTS_FILE="$TEMP_PATH/requirements"

if [ ! -f "$REQUIREMENTS_FILE" ]; then
    echo "[ERROR] Requirements file not found in $TEMP_PATH."
    exit 1
fi

# Check if requirements.bash exists
if [ ! -f "$REQUIREMENTS_SCRIPT" ]; then
    echo "[ERROR] requirements.bash not found in $TEMP_PATH. Are you running with '--remote' flag?"
    echo "You might need to install some packages manually."
else
    echo "Requirements script found. Installing requirements..."
    source "$REQUIREMENTS_SCRIPT"
fi


# Change directory to home folder
# cd "$HOME"

# Copy phakit to /etc
cp -r "$TEMP_PATH" "$DEST_PATH"

# Make sure the script files are executable
chmod -R 775 "$DEST_PATH"
chmod +x "$DEST_PATH/install.bash"
chmod +x "$DEST_PATH/phakit"
chmod +x "$DEST_PATH/phakit.py"

# Link `phakit` and the Python script to /usr/local/bin
update_symlinks

# Set permissions for symlinks
chmod 775 "$LINK_PATH/phakit"
chmod 775 "$LINK_PATH/phakit.py"
# And make them executable
chmod +x "$LINK_PATH/phakit"
chmod +x "$LINK_PATH/phakit.py"

# Cleanup
rm -r "$TEMP_PATH"