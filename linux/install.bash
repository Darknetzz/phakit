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
# 4                  : $LOCAL_LINK_PATH does not exist
# 5                  : Requirements file not found in $TEMP_PATH
# 100                : Could not import config file


# ──────────────────────────────────────────────────────────────────────────── #
#                          SECTION: INCLUDES                                   #
# ──────────────────────────────────────────────────────────────────────────── #
GITHUB_INCLUDES_FILE="https://raw.githubusercontent.com/Darknetzz/phakit/main/linux/includes.bash"
source <(curl -s "$INCLUDES_FILE")
# ────────────────────────── !SECTION /INCLUDES ──────────────────────────── #





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

# Check for existence of LINK_PATH
if [ ! -d "$LOCAL_LINK_PATH" ]; then
    quit 4 "Symbolic link folder $LOCAL_LINK_PATH does not exist."
fi

# Check for existence of LOCAL_PATH and create if not exists
if [ ! -d "$LOCAL_PATH" ]; then
    mkdir -p "$LOCAL_PATH"
fi
# ─────────────────── !SECTION /CHECK DIRECTORIES ─────────────────────────── #




# ──────────────────────────────────────────────────────────────────────────── #
#                       SECTION: Check installed version                       #
# ──────────────────────────────────────────────────────────────────────────── #
# Save installed version to variable

# Check if phakit is already installed
print "Checking for existing version of phakit..."

check_installed
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
    print "Requirements script not found in $TEMP_PATH. You might need to install some packages manually. Attempting to continue..." "ERROR"
else
    print "Requirements script found: $REQUIREMENTS_SCRIPT. Installing requirements..."
    source "$REQUIREMENTS_SCRIPT"
fi
# ───────────────────────────────── !SECTION ───────────────────────────────── #


# ──────────────────────────────────────────────────────────────────────────── #
#                               SECTION: Finalize                              #
# ──────────────────────────────────────────────────────────────────────────── #
# Copy phakit to /etc
cp -r "$TEMP_PATH" "$LOCAL_PATH"

# Link `phakit` and the Python script to /usr/local/bin
update_symlinks

# Set permissions
set_permissions

# Cleanup
cleanup

quit 0
# ───────────────────────────────── !SECTION ───────────────────────────────── #

