# phakit

```python
"""
# ──────────────────────────────────────────────────────────────────────────────#
#           dP                dP       oo   dP                                  #
#           88                88            88                                  #
#   88d888b. 88d888b. .d8888b. 88  .dP  dP d8888P                               #
#   88'  `88 88'  `88 88'  `88 88888"   88   88                                 #
#   88.  .88 88    88 88.  .88 88  `8b. 88   88                                 #
#   88Y888P' dP    dP `88888P8 dP   `YP dP   dP                                 #
#   88                                                                          #
#   dP                                                                          #
# ───────────────────────────────────────────────────────────────────────────── #
#                   a project/packager tool for PHP projects                    #
# ───────────────────────────────────────────────────────────────────────────── #
# ──────────────────────── Made with ❤️ by @Darknetzz ──────────────────────── #
# ───────────────────────────────────────────────────────────────────────────── #
"""
```

# Introduction
**phakit** is a PHP project manager to help developers save time when creating new projects.
It is specifically designed for PHP

# Roadmap for 1.0.0
- [x] Linux
    - [x] Installer script
    - [x] Uninstaller script
- [ ] Windows
    - [ ] Installer script
    - [ ] Uninstaller script
- [x] Create projects
- [x] Initialize git on project
- [x] [php-utils](https://github.com/Darknetzz/php-utils)
- [ ] [php-api](https://github.com/Darknetzz/php-api)
- [ ] [js-utils](https://github.com/Darknetzz/js-utils)
- [ ] Create a `index.php` template
- [ ] JS and CSS
- [ ] Automatic documentation

# Requirements
- [x] Python > 3.11 with the following modules:
    - [x] subprocess
    - [x] requests
    - [x] argparse
    - [x] rich
    - [x] shutil
    - [x] GitPython
- [x] PHP > 8.3
- [x] Webserver (Apache2/NGINX)

# Get started

## Linux

### Option 1: Using the automated installer (recommended)

```bash
sudo su -
bash <(curl -s https://raw.githubusercontent.com/Darknetzz/phakit/main/linux/install.bash)
```


### Option 2: Manually install
For those who favors control over simplicity. This script is a minimalistic version of `install.bash`:
**NOTE:** You must ensure that you have the required dependencies.
```bash
# Config
GITHUB_REPO_URL="https://github.com/Darknetzz/phakit.git"
TEMP_PATH="$HOME/.phakit"
LOCAL_PATH="/etc/phakit"
LOCAL_LINK_PATH="/usr/local/bin"

# Cleanup previous installation files (if any)
if [ -d "$TEMP_PATH" ]; then
    rm -rf "$TEMP_PATH"
    mkdir "$TEMP_PATH"
fi

# Clone the git repo to $TEMP_PATH
git clone "$GITHUB_REPO_URL" "$TEMP_PATH"

# Create LOCAL_PATH
mkdir -p "$LOCAL_PATH"

# Copy TEMP_PATH to LOCAL_PATH
cp -r "$TEMP_PATH" "$LOCAL_PATH"

# Set LOCAL_PATH scripts to be executable
find "$LOCAL_PATH" -type d \( -name '.git' \) -prune -o -type f -exec chmod +x {} \;

# Set permissions for symlinks (should not be necessary, but just in case)
chmod -R 775 "$LOCAL_PATH"
chmod 775 "$LOCAL_LINK_PATH/phakit"
chmod 775 "$LOCAL_LINK_PATH/phakit.py"

# And make them executable
chmod +x "$LOCAL_LINK_PATH/phakit"
chmod +x "$LOCAL_LINK_PATH/phakit.py"

# Remove old links (if they exist)
rm /usr/local/bin/phakit
rm /usr/local/bin/phakit.py

# Link `phakit` and the `phakit.py` script to /usr/local/bin
ln -s "$TEMP_PATH/phakit" /usr/local/bin/phakit
ln -s "$TEMP_PATH/phakit.py" /usr/local/bin/phakit.py
```

## Windows

### Option 1: Using the automated installed (recommended)
*Coming soon*
```powershell
irm "https://raw.githubusercontent.com/Darknetzz/phakit/main/windows/uninstall.ps1" | iex
```

# Usage
To initialize a new project, simply do this:
```bash
phakit --i "[PROJECT_NAME]" -d "[PATH]"
```

Automatically create documentation for your project:
```bash
phakit --docs "[DOCS_FOLDER]"
```

# Uninstalling

## Linux
* Using cURL:
```bash
sudo su -
bash <(curl -s https://raw.githubusercontent.com/Darknetzz/phakit/main/linux/uninstall.bash)"
```

## Windows
```powershell
irm "https://raw.githubusercontent.com/Darknetzz/phakit/main/windows/uninstall.ps1" | iex
```

# Troubleshooting
## Exit code reference: 

### 0-9: General
* **0** - Success
    * *specifically non-error - cancelling operation would also exit with 0*
* **1** - Not running bash
* **2** - Not running as root

### 10-19: Install
* **10** - Could not change directory to $HOME.
* **11** - GITHUB_LATEST_VERSION is empty. Something is wrong here.

### 40-49: Update
* **101** - Unable to update phakit. Unable to read LOCAL_VERSION (empty). Check permissions.

### 90-99: Uninstall
* **90** - phakit is not installed.
* **91** - Uninstallation failed. Please try again or remove the folders manually
* **92** - Uninstallation failed. Please try again or remove the symlinks manually

### 100-119: Includes
* **100** - Could not import config file

### 160-170: PRECHECKS
* **160** - Please run the installer using bash.
* **161** - Please run installer as root.
* **162** - This script should not be run directly. Exiting...
* **163** - $LOCAL_LINK_PATH does not exist. Exiting...

### 170-179: REQUIREMENT NOT SATISFIED
* **170** - Python 3 is not installed.
* **171** - Python 3 seems to be installed in $PYTHON, but returned an error.
* **172** - Pip is not installed.
* **173** - Pip was found at $PIP, but returned an error.
* **174** - Git is not installed.

### 180-200: MISC
* **180** - "Unable to remove symlinks."
* **181** - "Unable to create symlinks."
