#!/bin/python3

# ──────────────────────────────────────────────────────────────────────────── #
#                                    IMPORTS                                   #
# ──────────────────────────────────────────────────────────────────────────── #
import os, sys, argparse, subprocess
from rich.console import Console
import requests
import shutil
from git import Repo as gitrepo

# ──────────────────────────────────────────────────────────────────────────── #
#                                   PRECHECKS                                  #
# ──────────────────────────────────────────────────────────────────────────── #
# Check Python version
if sys.version_info < (3, 11):
    sys.exit("Python 3.11 or later is required.")

# Rich Console
con = Console()

# ──────────────────────────────────────────────────────────────────────────── #
#                                    CONFIG                                    #
# ──────────────────────────────────────────────────────────────────────────── #
LOCAL_PATH="/etc/phakit"


# ──────────────────────────────────────────────────────────────────────────── #
#                                   FUNCTIONS                                  #
# ──────────────────────────────────────────────────────────────────────────── #

# ───────────────────────────── FUNCTION: printr ───────────────────────────── #
def printr(text, type = "INFO"):
    prefix = ""
    color  = ""
    type   = type.upper()
    if type == "SUCCESS":
        color  = "dark_sea_green2"
    elif type == "ERROR" or type == "DANGER":
        color  = "red1"
    elif type == "WARNING":
        color  = "orange4"
    elif type == "INFO":
        color  = "dodger_blue3"
    elif type == "PROMPT":
        color  = "magenta"
    con.print(f"[{type}] {text}", style=f"bold {color.lower()}")

# ───────────────────────────── FUNCTION: prompt ───────────────────────────── #
def prompt(text):
    printr(text, "prompt")
    res = input("")
    if res == "":
        return None
    return res

# ───────────────────────────── FUNCTION: confirm ──────────────────────────── #
def confirm(text):
    printr(text, "prompt")
    if input(f"{text} [Y/n]: ").lower() == 'n':
        return False
    return True

# ────────────────────────────── FUNCTION: init ────────────────────────────── #
def init(dir):

    if dir is None:
        dir = prompt(f'Specify project directory (or leave empty to init in {os.getcwd()})')
        if dir == None:
            dir = os.getcwd()
        else:
            dir = os.path.abspath(dir)

    if os.path.isdir(dir):
            printr('Directory already exists. Please specify a directory is empty or does not exist.')
            sys.exit(1)
    else:
        shutil.copytree(LOCAL_PATH + "/deploy", dir)

    os.chdir(dir)
    printr("Project deployed to " + dir, "SUCCESS")

    gitrepo.init(dir)
    printr("Git repository initialized", "SUCCESS")



# ──────────────────────────────────────────────────────────────────────────── #
#                                    CONFIG                                    #
# ──────────────────────────────────────────────────────────────────────────── #
cwd             = os.getcwd()
current_dirname = cwd.split('/')[-1]
current_script  = sys.argv[0]

# ──────────────────────────────────────────────────────────────────────────── #
#                                    MAIN()                                    #
# ──────────────────────────────────────────────────────────────────────────── #
def main():
    parser = argparse.ArgumentParser(
        prog='phakit',
        description='A tool to make a package from a directory',
        epilog='by @Darknetzz'
    )

    # Flags
    parser.add_argument('-i', '--init', help='Initialize a new project', action='store_true')
    parser.add_argument('-v', '--version', help='Get current installed version of phakit', action='store_true')
    parser.add_argument('-u', '--update', help='Update phakit to the latest version', action='store_true')
    parser.add_argument('--docs', help='Automatically create docs for your project', action='store_true')

    # Variables
    parser.add_argument('-d', '--directory', help='The directory to use for this action', default=None)

    # Save arguments
    args      = parser.parse_args()

    # print help if no args passed
    if not len(sys.argv) > 1:
        parser.print_help()
        sys.exit(1)

# ──────────────────────────────────────────────────────────────────────────── #
#                                    VERSION                                   #
# ──────────────────────────────────────────────────────────────────────────── #
    if args.version is True:
        with open("/etc/phakit/VERSION", "r") as v:
            printr("phakit version: " + v.read())
        sys.exit(0)


# ──────────────────────────────────────────────────────────────────────────── #
#                                    UPDATE                                    #
# ──────────────────────────────────────────────────────────────────────────── #
    if args.update is True:
        printr("Updating phakit...")
        subprocess.run(f"{LOCAL_PATH}/linux/install.sh", shell=True, check=True)
        sys.exit(0)


# ──────────────────────────────────────────────────────────────────────────── #
#                                     INIT                                     #
# ──────────────────────────────────────────────────────────────────────────── #
    if args.init is True:
        init(args.directory)
        

# ──────────────────────────────────────────────────────────────────────────── #
#                                     DOCS                                     #
# ──────────────────────────────────────────────────────────────────────────── #
    if args.docs is True:
        printr("Creating documentation...")
        if os.path.exists(args.directory):
            printr('Directory already exists. Please specify a directory that does not exist.')
            sys.exit(1)

if __name__ == '__main__':
    main()