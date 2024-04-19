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
#                   SECTION: GITHUB INCLUDES                                   #
# ──────────────────────────────────────────────────────────────────────────── #
INCLUDES_IMPORTED="0"
GITHUB_INCLUDES_URL="https://raw.githubusercontent.com/Darknetzz/phakit/main/linux/includes.bash"
source <(curl -s "$GITHUB_INCLUDES_URL")

if [ -z "$INCLUDES_IMPORTED" ] || [ "$INCLUDES_IMPORTED" -ne "1" ]; then
    echo "Could not import includes file from GitHub ($GITHUB_INCLUDES_URL). Exiting..."
    exit 100
else
    print "Includes file imported." "SUCCESS"
fi
# ───────────────────── !SECTION /GITHUB INCLUDES ──────────────────────────── #





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

