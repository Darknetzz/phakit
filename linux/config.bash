#!/bin/bash

# Check if this script is invoked by the installer script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "[REQUIREMENTS.BASH] This script should not be run directly. Please run the installer script."
    exit 1
fi

# VAR: PYTHON,PIP,GIT: Find Python and pip
PYTHON3=$(which python3)
PYTHON="$PYTHON3"
PIP3=$(which pip3)
PIP="$PIP3"
GIT=$(which git)


# ──────────────────── TEMP_*: Set the temporary variables ─────────────────── #
# VAR: TEMP_PATH: ("/root/.phakit"): Temporary dir for installation files 
TEMP_PATH="$HOME/.phakit"

# ───────────────────── LOCAL_*: Set the local variables ───────────────────── #

# VAR: LOCAL_SCRIPT_PATH: ("/usr/local/bin/phakit"): Path for the script
LOCAL_SCRIPT_PATH="/usr/local/bin/phakit"

# VAR: LOCAL_PATH ("/etc/phakit") Destination (for phakit files): /etc/phakit
LOCAL_PATH="/etc/phakit"

# VAR: LOCAL_VERSION_FILE
LOCAL_VERSION_FILE="$LOCAL_PATH/VERSION"

# VAR: LOCAL_LINK_PATH ("/usr/local/bin"): Link path for symlinks
LOCAL_LINK_PATH="/usr/local/bin"

# VAR: GITHUB_*: Set the github variables
GITHUB_BRANCH="main"
GITHUB_REPO_PATH="Darknetzz/phakit"
GITHUB_REPO_URL="https://github.com/$GITHUB_REPO_PATH"
GITHUB_RAW_URL="https://raw.githubusercontent.com/$GITHUB_REPO_PATH/$GITHUB_BRANCH"
GITHUB_VERSION_URL="$GITHUB_RAW_URL/VERSION"
GITHUB_LATEST_VERSION=$(wget -O - "$GITHUB_VERSION_URL")
GITHUB_REQUIREMENTSFILE="$GITHUB_RAW_URL/requirements"
GITHUB_FUNCTIONS_URL="$GITHUB_RAW_URL/linux/functions"


# CONFIG_IMPORTED: Set to 1 if the config file is imported
CONFIG_IMPORTED=1