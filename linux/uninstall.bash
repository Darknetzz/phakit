# ──────────────────────────── UNINSTALL SCRIPT ────────────────────────────── #
#
#           This script will uninstall phakit.
#           See more at https://github.com/Darknetzz/phakit
#
# ──────────────────────────────────────────────────────────────────────────── #



# ──────────────────────────────────────────────────────────────────────────── #
#                          SECTION: INCLUDES                                   #
# ──────────────────────────────────────────────────────────────────────────── #
INCLUDES_IMPORTED="0"
GITHUB_INCLUDES_FILE="https://raw.githubusercontent.com/Darknetzz/phakit/main/linux/includes.bash"
source <(curl -s "$INCLUDES_FILE")

if [ -z "$INCLUDES_IMPORTED" ] || [ "$INCLUDES_IMPORTED" -ne "1" ]; then
    quit 100 "Could not import includes file from GitHub."
else
    print "Includes file imported." "SUCCESS"
fi
# ────────────────────────── !SECTION /INCLUDES ──────────────────────────── #




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