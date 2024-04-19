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
#                 a PHP project/packager tool for PHP projects                  #
# ───────────────────────────────────────────────────────────────────────────── #
# ──────────────────────── Made with ❤️ by @Darknetzz ──────────────────────── #
# ───────────────────────────────────────────────────────────────────────────── #
"""
```

# Introduction
**phakit** is a PHP project manager to help developers save time when creating new projects.
It is specifically designed for PHP

# Planned features
- [ ] Automated installer scripts
    - [ ] Linux (install.bash)
    - [ ] Windows (install.ps1)
- [ ] Automated uninstall scripts
    - [ ] Linux (uninstall.bash)
    - [ ] Windows (uninstall.ps1)
- [ ] Create projects
- [ ] Initialize git on project
- [php-utils](https://github.com/Darknetzz/php-utils)
- [php-api](https://github.com/Darknetzz/php-api)
- [js-utils](https://github.com/Darknetzz/js-utils)
- [ ] Create a `index.php` template
- [ ] JS and CSS
- [ ] Automatic documentation

# Requirements
- [x] Python > 3.11
- [x] PHP > 8.3
- [x] Webserver (Apache2/NGINX)

# Get started

## Linux

```bash
sudo su - # the installer must run as root!
INSTALL_SCRIPT=https://raw.githubusercontent.com/Darknetzz/phakit/main/linux/install.bash"
```

### Option 1: Using the automated installer (recommended)

#### Using cURL:
```bash
bash <(curl -s "$INSTALL_SCRIPT")
```

#### Using wget:
```bash
wget -O - "$INSTALL_SCRIPT" | bash
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

# Cleanup previous installation files
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
ln -s "$SOURCE_PATH_DIR/phakit" /usr/local/bin/phakit
ln -s "$SOURCE_PATH_DIR/phakit.py" /usr/local/bin/phakit.py
```
## Windows

### Option 1: Using the automated installed (recommended)
*Coming soon*
```powershell
Invoke-Expression "& { $(Invoke-RestMethod https://raw.githubusercontent.com/Darknetzz/phakit/main/install.ps1) }"
```

# Usage
To initialize a new project, simply do this:
```bash
./phakit --init "[PROJECT_NAME]" --path "[PATH]"
```

Automatically create documentation for your project:
```bash
./phpm --docs "[DOCS_FOLDER]"
```

# Uninstalling

## Linux
* Using cURL:
```bash
bash -s <(curl -s https://raw.githubusercontent.com/Darknetzz/phakit/main/uninstall.bash)
```

* Using wget:
```bash
wget -O - https://raw.githubusercontent.com/Darknetzz/phakit/main/uninstall.bash | sudo bash -s
```