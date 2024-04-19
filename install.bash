#!/bin/bash

# ────────────────────────────── INSTALL SCRIPT ────────────────────────────── #
#
#           This script will install/upgrade phakit and it's dependencies.
#           See more at https://github.com/Darknetzz/phakit
#
# ──────────────────────────────────────────────────────────────────────────── #

# ──────────────────────────────────────────────────────────────────────────── #
#                          SECTION: FUNCTIONS                                  #
# ──────────────────────────────────────────────────────────────────────────── #

# FUNCTION: print
print() {
    local PRINT="$1"
    local TYPE=${2:-"INFO"}
    PREPEND="${TYPE^^}"
    echo -e "\n[$PREPEND] $PRINT"
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

    print "Permissions set!"
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

    print "Updated symlinks!"
}

# FUNCTION: cleanup
cleanup() {
    print "Cleaning up previous installation files in $TEMP_PATH..."
    rm -r "$TEMP_PATH"
}

# FUNCTION: quit
quit() {
    local EXIT_CODE=${1:-0}
    if [ "$EXIT_CODE" -ne 0 ]; then
        print "Installation failed!" "ERROR"
    else
        print "Installation complete!" "SUCCESS"
    fi
    exit "$EXIT_CODE"
}
# ──────────────────────────── !SECTION /FUNCTIONS ─────────────────────────── #




# ──────────────────────────────────────────────────────────────────────────── #
#                          SECTION: PRECHECKS                                  #
# ──────────────────────────────────────────────────────────────────────────── #
# Check if we are running bash
if [ -z "$BASH_VERSION" ]; then
    print "Please run the installer using bash." "ERROR"
    quit 1
fi

# Make sure we have sudo access
if [ "$EUID" -ne 0 ]; then
    print "Please run installer as root." "ERROR"
    quit 1
fi
# ────────────────────────── !SECTION /PRECHECKS ──────────────────────────── #




# ──────────────────────────────────────────────────────────────────────────── #
#                           SECTION: CONFIG                                    #
# ──────────────────────────────────────────────────────────────────────────── #
# REVIEW: What folder should we use?
# - VAR: TEMP_PATH ("/root/.phakit"): Temporary dir for installation files 
# - VAR: DEST_PATH (/etc/phakit) Destination (for phakit files): /etc/phakit
# - VAR: LINK_PATH (/usr/local/bin): Link path for symlinks

# LINK_PATH: Set link path (for symlinks)
LINK_PATH="/usr/local/bin"

# DEST_PATH: Set the destination path
DEST_PATH="/etc/phakit"
DEST_VERSION_FILE="$DEST_PATH/VERSION"

# TEMP_PATH: Set the temporary path
TEMP_PATH="$HOME/.phakit"
# ───────────────────────────── !SECTION /CONFIG ──────────────────────────── #




# ──────────────────────────────────────────────────────────────────────────── #
#                          SECTION: CHECK DIRECTORIES                          #
# ──────────────────────────────────────────────────────────────────────────── #

# CD to home directory
cd "$HOME"

# Clean up previous installation files if they are present
if [ -d "$TEMP_PATH" ]; then
    cleanup
else

# Check for existence of folders and create them
if [ ! -d "$LINK_PATH" ]; then
    print "$LINK_PATH does not exist. Exiting..." "ERROR"
    quit 1
fi
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
    if [ $GITHUB_VERSION == $DEST_VERSION ]; then
        print "No new updates available. Version $DEST_VERSION is up to date."

        # Link `phakit` and the Python script to /usr/local/bin
        update_symlinks

        # Set permissions
        set_permissions
        
        if prompt "Do you want to do a full reinstall of phakit?"; then
            echo "Reinstalling phakit..."
            # Continue with uninstallation...
        else
            update_symlinks
            set_permissions
            quit 0
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
    print "Requirements file not found in $TEMP_PATH." "ERROR"
    quit 1
fi

# Check if requirements.bash exists
if [ ! -f "$REQUIREMENTS_SCRIPT" ]; then
    print "requirements.bash not found in $TEMP_PATH." "ERROR"
    print "You might need to install some packages manually."
else
    print "Requirements script found. Installing requirements..."
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
print "Cleaning up installation files..."
rm -r "$TEMP_PATH"

print "Installation complete!" "SUCCESS"
quit 0
# ───────────────────────────────── !SECTION ───────────────────────────────── #

