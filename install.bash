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
print() {
    local PRINT="$1"
    local TYPE=${2:-"INFO"}
    PREPEND="${TYPE^^}"
    echo -e "\n[$PREPEND] $PRINT"
}

set_permissions() {

    print "Setting permissions..."

    # Set permissions for the destination folder
    chmod -R 775 "$DEST_PATH"

    # Make all files in the directory executable
    find "$DEST_PATH" -type f -exec chmod +x {} \;

    # Set permissions for symlinks (should not be necessary, but just in case)
    chmod 775 "$LINK_PATH/phakit"
    chmod 775 "$LINK_PATH/phakit.py"

    # And make them executable
    chmod +x "$LINK_PATH/phakit"
    chmod +x "$LINK_PATH/phakit.py"

    print "Permissions set!"
}

update_symlinks() {
    print "Updating symlinks..."

    # Remove old links
    rm "$LINK_PATH/phakit"
    rm "$LINK_PATH/phakit.py"

    # Link `phakit` and the Python script to /usr/local/bin
    ln -s "$DEST_PATH/phakit" "$LINK_PATH/phakit"
    ln -s "$DEST_PATH/phakit.py" "$LINK_PATH/phakit.py"

    print "Updated symlinks!"
}

# ──────────────────────────────────────────────────────────────────────────── #
#                                   PRECHECKS                                  #
# ──────────────────────────────────────────────────────────────────────────── #
# Check if we are running bash
if [ -z "$BASH_VERSION" ]; then
    print "Please run the installer using bash." "ERROR"
    exit 1
fi

# Make sure we have sudo access
if [ "$EUID" -ne 0 ]; then
    print "Please run installer as root." "ERROR"
    exit 1
fi


# ──────────────────────────────────────────────────────────────────────────── #
#                                    CONFIG                                    #
# ──────────────────────────────────────────────────────────────────────────── #
# REVIEW: What folder should we use?

# Store current folder for later
CWD=$(pwd)

# LINK_PATH: Set link path (for symlinks)
LINK_PATH="/usr/local/bin"

# DEST_PATH: Set the destination path
DEST_PATH="/etc/phakit"
DEST_VERSION_FILE="$DEST_PATH/VERSION"

# TEMP_PATH: Set the temporary path
TEMP_PATH="$HOME/.phakit"

# Check for existence of folders and create them
if [ ! -d "$LINK_PATH" ]; then
    echo "[ERROR] $LINK_PATH does not exist. Exiting..."
    exit 1
fi
if [ ! -d "$TEMP_PATH" ]; then
    mkdir -p "$TEMP_PATH"
fi

if [ ! -d "$DEST_PATH" ]; then
    mkdir -p "$DEST_PATH"
fi

# Save installed version to variable
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
    echo "Version $DEST_VERSION is already installed in $DEST_PATH."
    echo "Checking for updates..."
    if [ $GITHUB_VERSION == $DEST_VERSION ]; then
        echo "No new updates available. Version $DEST_VERSION is up to date."
        update_symlinks
        set_permissions
        exit 0
    fi
fi

echo "Version $GITHUB_VERSION will be installed..."

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

# Set permissions
set_permissions

# Cleanup
rm -r "$TEMP_PATH"