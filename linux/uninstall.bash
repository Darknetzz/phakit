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