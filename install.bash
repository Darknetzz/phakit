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

# Config
CWD=$(pwd)
PATH_SCRIPT_NAME="./phakit"

SOURCE_PATH_DIR="$CWD"
SOURCE_VERSION_FILE="$SOURCE_PATH_DIR/VERSION"
SOURCE_VERSION=$(cat $SOURCE_VERSION_FILE)

DEST_PATH_DIR="/etc/phakit"
DEST_VERSION_FILE="$DEST_PATH_DIR/VERSION"
DEST_VERSION=$(cat $DEST_VERSION_FILE)

REQUIREMENTS_SCRIPT="$CWD/requirements.bash"

# Check if requirements.bash exists
if [ ! -f $REQUIREMENTS_SCRIPT ]; then
    echo "[WARNING] requirements.bash not found. You might need to install some packages manually."
else
    echo "Requirements script found. Installing requirements..."
    source "$REQUIREMENTS_SCRIPT"
fi

# Check if phakit is already installed
echo "Checking for existing version..."
if [ -d $DEST_PATH_DIR -a -f $DEST_VERSION_FILE ]; then
    echo "phakit version $DEST_VERSION is already installed in $DEST_PATH_DIR. Upgrading to latest version..."
else
    echo "phakit not installed. Installing phakit..."
fi


# Change directory to home folder
# cd ~

# Clone the git repo
git clone https://github.com/Darknetzz/phakit.git phakit

# Make sure the script files are executable
chmod +x "$CWD/install.bash"
chmod +x "$CWD/phakit"
chmod +x "$CWD/phakit.py"

# Copy phakit to /etc
cp -r phakit /etc

# Link `phakit` and the Python script to /usr/local/bin
ln -s ~/phakit/phakit /usr/local/bin/phakit
ln -s ~/phakit/phakit.py /usr/local/bin/phakit.py