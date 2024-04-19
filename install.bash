#!/bin/bash

# ────────────────────────────── INSTALL SCRIPT ────────────────────────────── #
#
#           This script will install/upgrade phakit and it's dependencies.
#           See more at https://github.com/Darknetzz/phakit
#
# ──────────────────────────────────────────────────────────────────────────── #

# Exit code reference: 
# 0                  : Success
# 1                  : Not running bash
# 2                  : Not running as root
# 3                  : Could not change directory to $HOME
# 4                  : $LINK_PATH does not exist
# 5                  : Requirements file not found in $TEMP_PATH
# 100                : Could not import config file

# ──────────────────────────────────────────────────────────────────────────── #
#                          SECTION: FUNCTIONS                                  #
# ──────────────────────────────────────────────────────────────────────────── #

# FUNCTION: print
print() {
    local PRINT="$1"
    local TYPE=${2:-"INFO"}
    local PREPEND="${TYPE^^}"

    # Define colors
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local BLUE='\033[0;34m'
    local NC='\033[0m' # No Color

    # Choose color based on message type
    local COLOR=$NC
    case $PREPEND in
        "ERROR") COLOR=$RED;;
        "SUCCESS") COLOR=$GREEN;;
        "WARNING") COLOR=$YELLOW;;
        "INFO") COLOR=$BLUE;;
    esac

    # Print message
    echo -e "${COLOR}[$PREPEND]${NC} $PRINT"
}

# FUNCTION: prompt_user
prompt() {
    local PROMPT="$1"
    # Prompt the user for verification
    read -p "$PROMPT (y/N) " -n 1 -r
    echo    # move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        return 1
    fi
    return 0
}

# FUNCTION: set_permissions
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

}

# FUNCTION: update_symlinks
update_symlinks() {
    print "Updating symlinks..."

    # Remove old links
    rm "$LINK_PATH/phakit"
    rm "$LINK_PATH/phakit.py"

    # Link `phakit` and the Python script to /usr/local/bin
    ln -s "$DEST_PATH/phakit" "$LINK_PATH/phakit"
    ln -s "$DEST_PATH/phakit.py" "$LINK_PATH/phakit.py"

}

# FUNCTION: cleanup
cleanup() {
    print "Cleaning up previous installation files in $TEMP_PATH..."
    rm -r "$TEMP_PATH"
}

# FUNCTION: quit
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
# ──────────────────────────── !SECTION /FUNCTIONS ─────────────────────────── #




# ──────────────────────────────────────────────────────────────────────────── #
#                          SECTION: PRECHECKS                                  #
# ──────────────────────────────────────────────────────────────────────────── #
# Check if we are running bash
if [ -z "$BASH_VERSION" ]; then
    quit 1 "Please run the installer using bash."
fi

# Make sure we have sudo access
if [ "$EUID" -ne 0 ]; then
    quit 2 "Please run installer as root."
fi
# ────────────────────────── !SECTION /PRECHECKS ──────────────────────────── #




# ──────────────────────────────────────────────────────────────────────────── #
#                                    CONFIG                                    #
# ──────────────────────────────────────────────────────────────────────────── #
CONFIG_IMPORTED="0"
if [ -f "config" ]; then
    source "config"
else
    print "No config file found. Fetching from GitHub..."
    source <(curl -s https://raw.githubusercontent.com/Darknetzz/phakit/main/config)
fi

if [ "$CONFIG_IMPORTED" -ne "1" ]; then
    echo "Could not import config file."
    exit 100 
fi




# ──────────────────────────────────────────────────────────────────────────── #
#                          SECTION: CHECK DIRECTORIES                          #
# ──────────────────────────────────────────────────────────────────────────── #

# CD to home directory
print "Changing directory to $HOME..."
cd "$HOME" || quit 3 "Could not change directory to $HOME."
print "CWD: $(pwd)" "SUCCESS"

# Clean up previous installation files if they are present
if [ -d "$TEMP_PATH" ]; then
    cleanup
fi

# Check for existence of LINK_PATH, and quit if it does not exist
if [ ! -d "$LINK_PATH" ]; then
    quit 4 "$LINK_PATH does not exist."
fi

# Check for existence of DEST_PATH and create them
if [ ! -d "$DEST_PATH" ]; then
    mkdir -p "$DEST_PATH"
fi
# ─────────────────── !SECTION /CHECK DIRECTORIES ─────────────────────────── #




# ──────────────────────────────────────────────────────────────────────────── #
#                       SECTION: Check installed version                       #
# ──────────────────────────────────────────────────────────────────────────── #
# Save installed version to variable
if [ -f "$DEST_VERSION_FILE" ]; then
    DEST_VERSION=$(cat "$DEST_VERSION_FILE")
else
    DEST_VERSION="0"
fi

GITHUB_VERSION=$(wget -O - https://raw.githubusercontent.com/Darknetzz/phakit/main/VERSION)

# Check if phakit is already installed
print "Checking for existing version..."
if [ "$DEST_VERSION" == "0" ]; then
    print "phakit not installed. Installing phakit..."
else
    print "Version $DEST_VERSION is already installed in $DEST_PATH."
    print "Checking for updates..."
    if [ "$GITHUB_VERSION" == "$DEST_VERSION" ]; then
        print "No new updates available. Version $DEST_VERSION is up to date."       
        if prompt "Do you want to do reinstall phakit (this could help with broken links/permissions)?"; then
            echo "Reinstalling phakit..."
            # Continue with uninstallation...
        else
            quit 0 "Installation cancelled."
        fi
    fi
fi

print "Version $GITHUB_VERSION will be installed..."
# ───────────────────────────────── !SECTION ───────────────────────────────── #



# ──────────────────────────────────────────────────────────────────────────── #
#                                SECTION GIT CLONE                             #
# ──────────────────────────────────────────────────────────────────────────── #

# NOTE: $TEMP_PATH does not need to be created as git clone will do it for us
# EDIT: We could probably just create it anyway
mkdir -p "$TEMP_PATH"

# Clone the git repo to $TEMP_PATH
git clone https://github.com/Darknetzz/phakit.git "$TEMP_PATH"
# ───────────────────────────────── !SECTION ───────────────────────────────── #




# ──────────────────────────────────────────────────────────────────────────── #
#                        SECTION: REQUIREMENTS                                 #
# ──────────────────────────────────────────────────────────────────────────── #
REQUIREMENTS_SCRIPT="$TEMP_PATH/requirements.bash"
REQUIREMENTS_FILE="$TEMP_PATH/requirements"

if [ ! -f "$REQUIREMENTS_FILE" ]; then
    quit 5 "Requirements file not found in $TEMP_PATH."
fi

# Check if requirements.bash exists
if [ ! -f "$REQUIREMENTS_SCRIPT" ]; then
    print "requirements.bash not found in $TEMP_PATH. You might need to install some packages manually. Attempting to continue..." "ERROR"
else
    print "Requirements script found: $REQUIREMENTS_SCRIPT. Installing requirements..."
    source "$REQUIREMENTS_SCRIPT"
fi
# ───────────────────────────────── !SECTION ───────────────────────────────── #


# ──────────────────────────────────────────────────────────────────────────── #
#                               SECTION: Finalize                              #
# ──────────────────────────────────────────────────────────────────────────── #
# Copy phakit to /etc
cp -r "$TEMP_PATH" "$DEST_PATH"

# Link `phakit` and the Python script to /usr/local/bin
update_symlinks

# Set permissions
set_permissions

# Cleanup
cleanup

quit 0
# ───────────────────────────────── !SECTION ───────────────────────────────── #

