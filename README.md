# phakit
a PHP project manager written in Python.

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
**phakit** is a simple PHP project/package manager.

# Get started

## Linux

### Option 1: Using the automated installer (recommended)

* Using cURL:
```bash
bash <(curl -s https://raw.githubusercontent.com/Darknetzz/phakit/main/install.bash)
```

* Using wget:
```bash
wget -O - https://raw.githubusercontent.com/Darknetzz/phakit/main/install.bash | sudo bash # -s -- --remote
```

## Option 2: Manually install
For those who favors control over simplicity.
```bash
TEMP_PATH="$HOME/.phakit"
DEST_PATH="/etc/phakit"

# Clone the git repo
git clone https://github.com/Darknetzz/phakit.git phakit

# Make sure the script files are executable
chmod +x "$TEMP_PATH/install.bash"
chmod +x "$TEMP_PATH/phakit"
chmod +x "$TEMP_PATH/phakit.py"

# Remove old links (if they exist)
rm /usr/local/bin/phakit
rm /usr/local/bin/phakit.py

# Link `phakit` and the Python script to /usr/local/bin
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

# Requirements
- [x] Python > 3.11
- [x] PHP > 8.3
- [x] Webserver (Apache2/NGINX)

# Planned features
- [ ] Create projects
- [ ] Initialize git
- [php-utils](https://github.com/Darknetzz/php-utils)
- [php-api](https://github.com/Darknetzz/php-api)
- [js-utils](https://github.com/Darknetzz/js-utils)
- [ ] Create a `index.php` template
- [ ] JS and CSS
- [ ] Automatic documentation
