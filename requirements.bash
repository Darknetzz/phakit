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

# ──────────────────────────── REQUIREMENTS SCRIPT ─────────────────────────── #
#
#           This script will check for Python, pip and it's packages.
#
# ──────────────────────────────────────────────────────────────────────────── #

# Find Python and pip
PYTHON3=$(which python3)
PYTHON="$PYTHON3"
PIP3=$(which pip3)
PIP="$PIP3"
GIT=$(which git)

# Make sure Python exists
if [ -z "$PYTHON" ]; then
    echo "[ERROR] Python 3 is not installed."
    exit 1
fi

# Make sure Python can run
if ! command -v "$PYTHON" &> /dev/null; then
    echo "[ERROR] Python 3 seems to be installed in $PYTHON, but returned an error. Exiting..."
    exit 1
fi

# Make sure pip is installed
if [ -z "$PIP" ]; then
    echo "[ERROR] Pip is not installed."
    exit 1
fi

# Make sure pip can run
if ! command -v "$PIP" &> /dev/null; then
    echo "[ERROR] Pip was found at $PIP, but returned an error. Exiting..."
    exit 1
fi

# Check if pip packages are installed
REQUIRED_PYTHON_PACKAGES="requirements"
if [ -f "$REQUIRED_PYTHON_PACKAGES" ]; then
    echo "Installing/verifying pip packages..."
    $PIP install -r "$REQUIRED_PYTHON_PACKAGES"
else
    echo "[ERROR] $REQUIRED_PYTHON_PACKAGES not found. Exiting..."
    exit 1
fi

# Check if git is installed
if [ -z "$GIT" ]; then
    echo "[ERROR] Git is not installed."
    exit 1
fi