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
#                                    CONFIG                                    #
# ──────────────────────────────────────────────────────────────────────────── #
TEMP_PATH="$HOME/.phakit"
DEST_PATH="/etc/phakit"
LINK_PATH="/usr/local/bin"

if [ ! -d "$DEST_PATH" ]; then
    echo "[WARNING] phakit does not seem to be installed. Will attempt to continue uninstallation..."
fi

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
rm "$LINK_PATH/phakit"
rm "$LINK_PATH/phakit.py"

# Remove phakit and temp folder
rm -rf "$DEST_PATH"
rm -rf "$TEMP_PATH"