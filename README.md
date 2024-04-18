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

## Option 1: Using the automated installer (recommended)
```bash
wget -O - https://raw.githubusercontent.com/Darknetzz/phakit/main/install.bash | bash
```

## Option 2: Manually install
This is essentially exactly what the `install.bash` file does.
```bash
# Change directory to home directory
cd ~

# Clone the git repo
git clone https://github.com/Darknetzz/phakit.git phakit

# Change to phakit directory
cd phakit

# Make sure it's executable
chmod +x phakit.py

# Run it
bash phakit/install.bash
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
