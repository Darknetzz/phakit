#!/bin/bash

PYTHON3=$(which python3)
PIP3=$(which pip3)

# Make sure Python exists
if [ -z $PYTHON3 ]; then
    echo "[ERROR] Python 3 is not installed."
    exit 1
fi

# Make sure Python can run
if ! command -v "$PYTHON3" &> /dev/null; then
    echo "[ERROR] Python 3 seems to be installed in $PYTHON3, but returned an error. Exiting..."
    exit 1
fi

# Make sure pip is installed
if [ -z $PIP3 ]; then
    echo "[ERROR] Pip is not installed."
    exit 1
fi

# Make sure pip can run
if ! command -v "$PIP3" &> /dev/null; then
    echo "[ERROR] Pip was found at $PIP3, but returned an error. Exiting..."
    exit 1
fi

# Check if pip packages are installed
REQUIRED_PYTHON_PACKAGES="requirements"
if [ -f "$REQUIRED_PYTHON_PACKAGES" ]; then
    echo "Installing/verifying pip packages..."
    pip install -r "$REQUIRED_PYTHON_PACKAGES"
else
    echo "[ERROR] $REQUIRED_PYTHON_PACKAGES not found. Exiting..."
    exit 1
fi