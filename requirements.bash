#!/bin/bash



# ──────────────────────────── REQUIREMENTS SCRIPT ─────────────────────────── #
#
#           This script will check for Python, pip and it's packages.
#
# ──────────────────────────────────────────────────────────────────────────── #

# Check if this script is invoked by the installer script
if [ -z "$INSTALLER" ]; then
    echo "[REQUIREMENTS.BASH] This script should not be run directly. Please run the installer script."
    exit 1
fi

# Check if we have config
if [ -z "$CONFIG_IMPORTED" ]; then
    echo "[REQUIREMENTS.BASH] Config has not been imported. Exiting..."
    exit 1
fi

# Make sure Python exists
if [ -z "$PYTHON" ]; then
    echo "[REQUIREMENTS.BASH] Python 3 is not installed."
    exit 1
fi

# Make sure Python can run
if ! command -v "$PYTHON" &> /dev/null; then
    echo "[REQUIREMENTS.BASH] Python 3 seems to be installed in $PYTHON, but returned an error. Exiting..."
    exit 1
fi

# Make sure pip is installed
if [ -z "$PIP" ]; then
    echo "[REQUIREMENTS.BASH] Pip is not installed."
    exit 1
fi

# Make sure pip can run
if ! command -v "$PIP" &> /dev/null; then
    echo "[REQUIREMENTS.BASH] Pip was found at $PIP, but returned an error. Exiting..."
    exit 1
fi

# Check if pip packages are installed
REQUIRED_PYTHON_PACKAGES="$SOURCE_PATH_DIR/requirements"
if [ -f "$REQUIRED_PYTHON_PACKAGES" ]; then
    echo "Installing/verifying pip packages..."
    $PIP install -r "$REQUIRED_PYTHON_PACKAGES"
else
    echo "[REQUIREMENTS.BASH] $REQUIRED_PYTHON_PACKAGES not found in $SOURCE_PATH_DIR. Exiting..."
    exit 1
fi

# Check if git is installed
if [ -z "$GIT" ]; then
    echo "[REQUIREMENTS.BASH] Git is not installed."
    exit 1
fi