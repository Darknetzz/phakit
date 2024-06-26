#!/bin/bash

# ────────────────────────────── INSTALL SCRIPT ────────────────────────────── #
#
#           This script will install/upgrade phakit and it's dependencies.
#           See more at https://github.com/Darknetzz/phakit
#
# ──────────────────────────────────────────────────────────────────────────── #


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
    print "Includes file imported from GitHub." "SUCCESS"
fi
# ───────────────────── !SECTION /GITHUB INCLUDES ──────────────────────────── #





# ──────────────────────────────────────────────────────────────────────────── #
#                          SECTION: CHECK DIRECTORIES                          #
# ──────────────────────────────────────────────────────────────────────────── #

# CD to home directory
print "Changing directory to $HOME..."
cd "$HOME" || quit 10 "Could not change directory to $HOME."
print "CWD: $(pwd)" "SUCCESS"

# Clean up previous installation files if they are present
if [ -d "$TEMP_PATH" ]; then
    cleanup
fi

# Check for existence of LOCAL_PATH and create if not exists
if [ ! -d "$LOCAL_PATH" ]; then
    mkdir -p "$LOCAL_PATH"
fi
# ─────────────────── !SECTION /CHECK DIRECTORIES ─────────────────────────── #




# ──────────────────────────────────────────────────────────────────────────── #
#                       SECTION: INSTALL                                       #
# ──────────────────────────────────────────────────────────────────────────── #
install_update






# ──────────────────────────────────────────────────────────────────────────── #
#                               SECTION: Finalize                              #
# ──────────────────────────────────────────────────────────────────────────── #

# Link `phakit` and the Python script to /usr/local/bin
update_symlinks

# Set permissions
set_permissions

# Cleanup
cleanup

quit 0 "Installation complete."
# ───────────────────────────────── !SECTION ───────────────────────────────── #

