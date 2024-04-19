# ──────────────────────────── UNINSTALL SCRIPT ────────────────────────────── #
#
#           This script will uninstall phakit.
#           See more at https://github.com/Darknetzz/phakit
#
# ──────────────────────────────────────────────────────────────────────────── #

# ──────────────────────────────────────────────────────────────────────────── #
#                                   PRECHECKS                                  #
# ──────────────────────────────────────────────────────────────────────────── #
# Check if we are running bash
if [ -z "$BASH_VERSION" ]; then
    echo "[ERROR] Please run the installer using bash."
    exit 1
fi

# Make sure we have sudo access
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] Please run installer as root."
    exit 1
fi

# ──────────────────────────────────────────────────────────────────────────── #
#                           SECTION: CONFIG                                    #
# ──────────────────────────────────────────────────────────────────────────── #
CONFIG_IMPORTED="0"
GITHUB_CONFIGFILE_URL="https://raw.githubusercontent.com/Darknetzz/phakit/main/linux/config.bash"
source <(curl -s "$GITHUB_CONFIGFILE")

if [ "$CONFIG_IMPORTED" -ne "1" ]; then
    quit 100 "Could not import config file from GitHub."
else
    print "Config file imported." "SUCCESS"
fi
# ───────────────────────────── !SECTION: /CONFIG ──────────────────────────── #


# ──────────────────────────────────────────────────────────────────────────── #
#                              SECTION: FUNCTIONS                              #
# ──────────────────────────────────────────────────────────────────────────── #
FUNCTIONS_IMPORTED="0"
source <(curl -s "$GITHUB_FUNCTIONS_URL")

if [ "$FUNCTIONS_IMPORTED" -ne "1" ]; then
    quit 100 "Could not import functions.bash file from GitHub."
else
    print "Config file imported." "SUCCESS"
fi

# ──────────────────────────── !SECTION /FUNCTIONS ─────────────────────────── #




# ──────────────────────────────────────────────────────────────────────────── #
#                                    VERIFY                                    #
# ──────────────────────────────────────────────────────────────────────────── #

# Prompt the user for verification
read -p "Are you sure you want to uninstall phakit? (y/N) " -n 1 -r
echo    # move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Uninstallation cancelled."
    exit 1
fi

# Remove symlinks
rm "$LOCAL_LINK_PATH/phakit"
rm "$LOCAL_LINK_PATH/phakit.py"

# Remove phakit and temp folder
rm -rf "$LOCAL_PATH"
rm -rf "$TEMP_PATH"