#!/bin/bash

# ──────────────────────────────────────────────────────────────────────────── #
#               SECTION: #1 CONFIG (GLOBAL VARS)                               #
# ──────────────────────────────────────────────────────────────────────────── #
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
# GITHUB_LATEST_VERSION=$(wget -O - "$GITHUB_VERSION_URL")
GITHUB_LATEST_VERSION=$(curl -s "$GITHUB_VERSION_URL")
GITHUB_REQUIREMENTSFILE="$GITHUB_RAW_URL/requirements"
GITHUB_FUNCTIONS_URL="$GITHUB_RAW_URL/linux/functions"


# ──────────────────────────────────────────────────────────────────────────── #
#                               !SECTION                                       #
# ──────────────────────────────────────────────────────────────────────────── #












# ──────────────────────────────────────────────────────────────────────────── #
#                              SECTION: #2 FUNCTIONS                           #
# ──────────────────────────────────────────────────────────────────────────── #

# ────────────────────────────── FUNCTION: print ───────────────────────────── #
print() {
    local PRINT="$1"
    local TYPE=${2:-"INFO"}
    local PREPEND="${TYPE^^}"

    # Define colors
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local BLUE='\033[0;34m'
    local PURPLE='\033[0;35m'
    local NC='\033[0m' # No Color

    # Choose color based on message type
    local COLOR=$NC
    case $PREPEND in
        "ERROR") COLOR=$RED;;
        "SUCCESS") COLOR=$GREEN;;
        "WARNING") COLOR=$YELLOW;;
        "INFO") COLOR=$BLUE;;
        "PROMPT") COLOR=$PURPLE;;
        *) COLOR=$NC;;
    esac

    # Print message
    echo -e "${COLOR}[$PREPEND]${NC} $PRINT"
}

# ─────────────────────────── FUNCTION: prompt_user ────────────────────────── #
prompt() {
    local PROMPT="$1"
    # Prompt the user for verification
    print "$PROMPT" "PROMPT"
    read -r -p "Continue? (y/N) " response
    case "$response" in
    [yY][eE][sS]|[yY]) 
        return 1
        ;;
    *)
        return 0
        ;;
    esac
}

# ───────────────────────── FUNCTION: set_permissions ──────────────────────── #
set_permissions() {

    print "Setting permissions..."

    # Set permissions for the destination folder
    chmod -R 775 "$LOCAL_PATH"

    # Make all files in the directory executable
    find "$LOCAL_PATH" -type f -exec chmod +x {} \;

    # # Set permissions for symlinks (should not be necessary, but just in case)
    # chmod 775 "$LOCAL_LINK_PATH/phakit"
    # chmod 775 "$LOCAL_LINK_PATH/phakit.py"

    # # And make them executable
    # chmod +x "$LOCAL_LINK_PATH/phakit"
    # chmod +x "$LOCAL_LINK_PATH/phakit.py"
}

# ───────────────────────── FUNCTION: update_symlinks ──────────────────────── #
update_symlinks() {
    print "Updating symlinks..."

    # Remove the symlinks if they exist (even if they're dangling)
    print "Removing old symlinks in $LOCAL_LINK_PATH"
    [ -L "$LOCAL_LINK_PATH/phakit" ] && rm "$LOCAL_LINK_PATH/phakit"
    [ -L "$LOCAL_LINK_PATH/phakit.py" ] && rm "$LOCAL_LINK_PATH/phakit.py"

    if [ -L "$LOCAL_LINK_PATH/phakit" ] || [ -L "$LOCAL_LINK_PATH/phakit.py" ] ; then
        quit 180 "Unable to remove symlinks."
    fi
    print "Old symlinks removed." "SUCCESS"

    # Create new symlinks
    print "Creating new symlinks..."
    ln -s "$LOCAL_PATH/phakit" "$LOCAL_LINK_PATH/phakit"
    ln -s "$LOCAL_PATH/phakit.py" "$LOCAL_LINK_PATH/phakit.py"

    if [ ! -L "$LOCAL_LINK_PATH/phakit" ] || [ ! -L "$LOCAL_LINK_PATH/phakit.py" ]; then
        quit 181 "Unable to create symlinks."
    fi
    print "Symlinks updated." "SUCCESS"
}

# ───────────────────────────── FUNCTION: cleanup ──────────────────────────── #
cleanup() {
    print "Cleaning up previous installation files in $TEMP_PATH..."
    rm -r "$TEMP_PATH"
}

# ────────────────────────────── FUNCTION: quit ────────────────────────────── #
quit() {
    local EXIT_CODE=${1:-0}
    local MESSAGE=${2}

    if [ "$EXIT_CODE" -ne 0 ]; then
        local TYPE="ERROR"
        if [ -z "$MESSAGE" ]; then
            MESSAGE="Installation not complete."
        fi
    else
        local TYPE="SUCCESS"
        if [ -z "$MESSAGE" ]; then
            MESSAGE="Installation complete."
        fi
    fi

    print "$MESSAGE" "$TYPE"
    print "Exiting with code $EXIT_CODE..."
    exit "$EXIT_CODE"
}

# ─────────────────────────── FUNCTION install_update ────────────────────────── #
install_update() {

    # Show latest version
    if [ -z "$GITHUB_LATEST_VERSION" ]; then
        quit 11 "GITHUB_LATEST_VERSION is empty. Something is wrong here." "ERROR"
    fi
    print "Latest version of phakit available: $GITHUB_LATEST_VERSION"


    # Check if installed
    if [ -z "$LOCAL_VERSION" ] || [ "$LOCAL_VERSION" == "0" ]; then
        print "phakit is not installed"
    else
        print "Your version of phakit: $LOCAL_VERSION"
    fi

    # Check there is a newer version
    if [ "$GITHUB_LATEST_VERSION" == "$LOCAL_VERSION" ]; then
        print "No new updates available. Your version of phakit ($LOCAL_VERSION) is up to date."
    else 
        print "New update: $GITHUB_LATEST_VERSION" "SUCCESS"
    fi

    # Prompt for installation regardless
    if ! prompt "Do you want to do install the latest version from GitHub (this could help with broken links/permissions)?"; then
        quit 0 "Update cancelled."
    fi

    # NOTE: $TEMP_PATH does not need to be created as git clone will do it for us
    # EDIT: We could probably just create it anyway
    mkdir -p "$TEMP_PATH"

    # Clone the git repo to $TEMP_PATH
    git clone https://github.com/Darknetzz/phakit.git "$TEMP_PATH"

    # Copy phakit to /etc
    cp -r "$TEMP_PATH/"* "$LOCAL_PATH"
}


# ──────────────────────────────────────────────────────────────────────────── #
#                              !SECTION /FUNCTIONS                             #
# ──────────────────────────────────────────────────────────────────────────── #







# ──────────────────────────────────────────────────────────────────────────── #
#                           SECTION: #3 PRECHECKS                              #
# ──────────────────────────────────────────────────────────────────────────── #
# Check if we are running bash
if [ -z "$BASH_VERSION" ]; then
    quit 160 "Precheck failed: Please run the installer using bash."
fi

# Make sure we have sudo access
if [ "$EUID" -ne 0 ]; then
    quit 161 "Precheck failed: Please run installer as root."
fi

# Check if this script is invoked by the installer script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    quit 162 "Precheck failed: This script should not be run directly."
fi

# Check if we have /usr/local/bin
if [ ! -d "$LOCAL_LINK_PATH" ]; then
    quit 163 "Precheck failed: $LOCAL_LINK_PATH does not exist."
fi
# ──────────────────────────────────────────────────────────────────────────── #
#                             !SECTION: /PRECHECKS                             #
# ──────────────────────────────────────────────────────────────────────────── #


















# ──────────────────────────────────────────────────────────────────────────── #
#                             SECTION: #4 REQUIREMENTS                         #
# ──────────────────────────────────────────────────────────────────────────── #

# ────────────────────────────────── python ────────────────────────────────── #
# Make sure Python exists
if [ -z "$PYTHON" ]; then
    quit 170 "Requirement not satisfied: Python 3 is not installed."
fi

# Make sure Python can run
if ! command -v "$PYTHON" &> /dev/null; then
    quit 171 "Requirement not satisfied: Python 3 seems to be installed in $PYTHON, but returned an error."
fi

# ──────────────────────────────────── pip ─────────────────────────────────── #
# Make sure pip is installed
if [ -z "$PIP" ]; then
    quit 172 "Requirement not satisfied: Pip is not installed."
fi

# Make sure pip can run
if ! command -v "$PIP" &> /dev/null; then
    quit 173 "Requirement not satisfied: Pip was found at $PIP, but returned an error."
fi

# ──────────────────────────────────── git ─────────────────────────────────── #
# Check if git is installed
if [ -z "$GIT" ]; then
    quit 174 "Requirement not satisfied: Git is not installed."
fi
# ──────────────────────────────────────────────────────────────────────────── #
#                            !SECTION                                          #
# ──────────────────────────────────────────────────────────────────────────── #



INCLUDES_IMPORTED="1"