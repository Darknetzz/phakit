# ──────────────────────────── UNINSTALL SCRIPT ────────────────────────────── #
#
#           This script will uninstall phakit.
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
#                                    VERIFY                                    #
# ──────────────────────────────────────────────────────────────────────────── #

# Prompt the user for verification
if promt "Are you sure you want to uninstall phakit? (y/N) "; then
    quit 0 "Uninstallation cancelled."
fi

print "Uninstalling phakit..." "INFO"

if [ ! -d "$LOCAL_PATH" ]; then
    quit 90 "phakit is not installed."
fi

# Remove symlinks
rm "$LOCAL_LINK_PATH/phakit"
rm "$LOCAL_LINK_PATH/phakit.py"

# Remove phakit and temp folder
rm -rf "$LOCAL_PATH"
rm -rf "$TEMP_PATH"

# Check if phakit is still installed
if [ -d "$LOCAL_PATH" ] || [ -d "$TEMP_PATH" ]; then
    quit 91 "Uninstallation failed. Please try again or remove the folders manually"
fi

# Check if symlinks are still present
if [ -f "$LOCAL_LINK_PATH/phakit" ] || [ -f "$LOCAL_LINK_PATH/phakit.py" ]; then
    quit 92 "Uninstallation failed. Please try again or remove the symlinks manually"
fi

quit 0 "Uninstallation complete."