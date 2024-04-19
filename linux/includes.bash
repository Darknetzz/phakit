# ──────────────────────────────────────────────────────────────────────────── #
#                              SECTION: FUNCTIONS                              #
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

# ─────────────────────────── FUNCTION: prompt_user ────────────────────────── #
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

# ───────────────────────── FUNCTION: set_permissions ──────────────────────── #
set_permissions() {

    print "Setting permissions..."

    # Set permissions for the destination folder
    chmod -R 775 "$LOCAL_PATH"

    # Make all files in the directory executable
    find "$LOCAL_PATH" -type f -exec chmod +x {} \;

    # Set permissions for symlinks (should not be necessary, but just in case)
    chmod 775 "$LOCAL_LINK_PATH/phakit"
    chmod 775 "$LOCAL_LINK_PATH/phakit.py"

    # And make them executable
    chmod +x "$LOCAL_LINK_PATH/phakit"
    chmod +x "$LOCAL_LINK_PATH/phakit.py"

}

# ───────────────────────── FUNCTION: update_symlinks ──────────────────────── #
update_symlinks() {
    print "Updating symlinks..."

    # Remove old links
    rm "$LOCAL_LINK_PATH/phakit"
    rm "$LOCAL_LINK_PATH/phakit.py"

    # Link `phakit` and the Python script to /usr/local/bin
    ln -s "$LOCAL_PATH/phakit" "$LOCAL_LINK_PATH/phakit"
    ln -s "$LOCAL_PATH/phakit.py" "$LOCAL_LINK_PATH/phakit.py"

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

# ──────────────────────── FUNCTION: check_installed ─ ─────────────────────── #
check_installed() {
    # Check if LOCAL_VERSION is set
    if [ -n "$LOCAL_VERSION" ] && [ "$LOCAL_VERSION" != "0" ] && [ -d "$LOCAL_PATH" ]; then
        print "phakit $LOCAL_VERSION is already installed"
        check_update
        return
    else
        print "phakit is not installed"
        LOCAL_VERSION="0"

        # Check if LOCAL_VERSION_FILE exists
        if [ -f "$LOCAL_VERSION_FILE" ]; then
            print "LOCAL_VERSION is not set, but $LOCAL_VERSION_FILE exists. Reading version from file..."
            LOCAL_VERSION="$(cat "$LOCAL_VERSION_FILE")"
        fi
    fi

    if [ -z "$LOCAL_VERSION" ]; then
        quit "Unable to update phakit. Unable to read LOCAL_VERSION (empty). Check permissions." "ERROR"
    fi

    check_update
}

# ─────────────────────────── FUNCTION check_update ────────────────────────── #
check_update() {
    # Check if LOCAL_VERSION and GIT_VERSION are empty
    if [ -z "$GITHUB_LATEST_VERSION" ]; then
        quit "GITHUB_LATEST_VERSION is empty. Something is wrong here." "ERROR"
    fi

    if [ "$GITHUB_LATEST_VERSION" == "$LOCAL_VERSION" ]; then
        print "No new updates available. Your version of phakit ($LOCAL_VERSION) is up to date."

        if prompt "Do you want to do reinstall phakit (this could help with broken links/permissions)?"; then
            echo "Installing phakit $GITHUB_LATEST_VERSION..."
        else
            quit 0 "Installation cancelled."
        fi
    else 
        print "New version of phakit available: $GITHUB_LATEST_VERSION"
        if prompt "Do you want to update phakit?"; then
            echo "Updating phakit..."
        else
            quit 0 "Update cancelled."
        fi
    fi
}

FUNCTIONS_IMPORTED="1"
# ──────────────────────────────────────────────────────────────────────────── #
#                              !SECTION /FUNCTIONS                             #
# ──────────────────────────────────────────────────────────────────────────── #







# ──────────────────────────────────────────────────────────────────────────── #
#                              SECTION: PRECHECKS                              #
# ──────────────────────────────────────────────────────────────────────────── #
# Check if we are running bash
if [ -z "$BASH_VERSION" ]; then
    quit 1 "[includes.bash] Please run the installer using bash."
fi

# Make sure we have sudo access
if [ "$EUID" -ne 0 ]; then
    quit 2 "[includes.bash] Please run installer as root."
fi

# Check if this script is invoked by the installer script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    quit 3 "[includes.bash] This script should not be run directly. Exiting..."
fi
# ──────────────────────────────────────────────────────────────────────────── #
#                             !SECTION: /PRECHECKS                             #
# ──────────────────────────────────────────────────────────────────────────── #





# ──────────────────────────────────────────────────────────────────────────── #
#                                SECTION: CONFIG                               #
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
GITHUB_LATEST_VERSION=$(wget -O - "$GITHUB_VERSION_URL")
GITHUB_REQUIREMENTSFILE="$GITHUB_RAW_URL/requirements"
GITHUB_FUNCTIONS_URL="$GITHUB_RAW_URL/linux/functions"


# CONFIG_IMPORTED: Set to 1 if the config file is imported
CONFIG_IMPORTED=1
# ──────────────────────────────────────────────────────────────────────────── #
#                               !SECTION /CONFIG                               #
# ──────────────────────────────────────────────────────────────────────────── #













# ──────────────────────────────────────────────────────────────────────────── #
#                             SECTION: REQUIREMENTS                            #
# ──────────────────────────────────────────────────────────────────────────── #
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
# ──────────────────────────────────────────────────────────────────────────── #
#                            !SECTION /REQUIREMENTS                            #
# ──────────────────────────────────────────────────────────────────────────── #