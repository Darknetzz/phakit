#!/bin/bash

cat << EOF
# ──────────────────────────────────────────────────────────────────────────────#
#           dP                dP       oo   dP                                  #
#           88                88            88                                  #
#   88d888b. 88d888b. .d8888b. 88  .dP  dP d8888P                               #
#   88'  `88 88'  `88 88'  `88 88888"   88   88                                 #
#   88.  .88 88    88 88.  .88 88  `8b. 88   88                                 #
#   88Y888P' dP    dP `88888P8 dP   `YP dP   dP                                 #
#   88                                                                          #
#   dP                                                                          #
# ───────────────────────────────────────────────────────────────────────────── #
#                 a PHP project/packager tool for PHP projects                  #
# ───────────────────────────────────────────────────────────────────────────── #
#                          Made with ❤️ by @Darknetzz                          #
# ───────────────────────────────────────────────────────────────────────────── #
EOF

# ────────────────────────────── INSTALL SCRIPT ────────────────────────────── #
#
#           This script will install/upgrade phakit and it's dependencies.
#           See more at https://github.com/Darknetzz/phakit
#
# ──────────────────────────────────────────────────────────────────────────── #


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

# Set the temporary path and change directory
TEMP_PATH="~/.phakit"
if [ ! -d "$TEMP_PATH" ]; then
    mkdir -p "$TEMP_PATH"
fi
cd "$TEMP_PATH"

# Set the source path
SOURCE_PATH_DIR="$TEMP_PATH"

# Set the destination path
DEST_PATH_DIR="/etc/phakit"
DEST_VERSION_FILE="$DEST_PATH_DIR/VERSION"
if [ -f "$DEST_VERSION_FILE" ]; then
    DEST_VERSION=$(cat "$DEST_VERSION_FILE")
else
    DEST_VERSION=0
fi

GITHUB_VERSION=$(curl -s https://api.github.com/repos/Darknetzz/phakit/releases/latest | grep tag_name | cut -d '"' -f 4)

echo "Starting installation..."

# Check if phakit is already installed
echo "Checking for existing version..."
if [ "$DEST_VERSION" != 0 ]; then
    echo "Version $DEST_VERSION of phakit is already installed in $DEST_PATH_DIR."
    echo "Checking for updates..."
    if [ $GITHUB_VERSION == $DEST_VERSION ]; then
        echo "No new updates available."
        exit 0
    fi
else
    echo "phakit not installed. Installing phakit..."
fi


echo "New version available ($GITHUB_VERSION)! Updating..."

# Check if the script is being run remotely
if [[ $1 == "--remote" ]]; then
    echo "Script is being run remotely."
    echo "Changing directory to $TEMP_PATH..."
    cd "$TEMP_PATH"
    echo "Downloading requirements..."
    wget https://raw.githubusercontent.com/Darknetzz/phakit/main/requirements
    echo "Downloading requirements.bash..."
    wget https://raw.githubusercontent.com/Darknetzz/phakit/main/requirements.bash
else
    echo "Script is being run locally."
fi

# ──────────────────────────────────────────────────────────────────────────── #
#                                 REQUIREMENTS                                 #
# ──────────────────────────────────────────────────────────────────────────── #
REQUIREMENTS_SCRIPT="$CWD/requirements.bash"
REQUIREMENTS_FILE="$CWD/requirements"

if [ ! -f "$REQUIREMENTS_FILE" ]; then
    echo "[ERROR] Requirements file not found in $CWD."
    exit 1
fi

# Check if requirements.bash exists
if [ ! -f "$REQUIREMENTS_SCRIPT" ]; then
    echo "[ERROR] requirements.bash not found in $CWD. Are you running with '--remote' flag?"
    echo "You might need to install some packages manually."
else
    echo "Requirements script found. Installing requirements..."
    source "$REQUIREMENTS_SCRIPT"
fi


# Change directory to home folder
# cd ~

# Clone the git repo
git clone https://github.com/Darknetzz/phakit.git phakit

# Make sure the script files are executable
chmod +x "$SOURCE_PATH_DIR/install.bash"
chmod +x "$SOURCE_PATH_DIR/phakit"
chmod +x "$SOURCE_PATH_DIR/phakit.py"

# Copy phakit to /etc
cp -r "$SOURCE_PATH_DIR" /etc

# Link `phakit` and the Python script to /usr/local/bin
ln -s "$SOURCE_PATH_DIR/phakit" /usr/local/bin/phakit
ln -s "$SOURCE_PATH_DIR/phakit.py" /usr/local/bin/phakit.py