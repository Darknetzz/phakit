#!/bin/python3

# ──────────────────────────────────────────────────────────────────────────── #
#                                    IMPORTS                                   #
# ──────────────────────────────────────────────────────────────────────────── #
import os, sys, argparse, subprocess
from rich.console import Console
import requests
# ──────────────────────────────────────────────────────────────────────────── #
#                                   PRECHECKS                                  #
# ──────────────────────────────────────────────────────────────────────────── #
# Check Python version
if sys.version_info < (3, 11):
    sys.exit("Python 3.11 or later is required.")

# Rich Consolec
con = Console()

# ──────────────────────────────────────────────────────────────────────────── #
#                                   FUNCTIONS                                  #
# ──────────────────────────────────────────────────────────────────────────── #

# ───────────────────────────── FUNCTION: printr ───────────────────────────── #
def printr(text, type = "INFO"):
    prefix = ""
    color  = ""
    type   = type.upper()
    if type == "SUCCESS":
        color  = "GREEN"
    elif type == "ERROR" or type == "DANGER":
        color  = "RED"
    elif type == "WARNING":
        color  = "ORANGE"
    elif type == "INFO":
        color  = "BLUE"
    elif type == "PROMPT":
        color  = "GREY"
    con.print(f"[{type}] {text}", style=f"bold {color}")

# ───────────────────────────── FUNCTION: prompt ───────────────────────────── #
def prompt(text):
    printr(text, "prompt")
    if input(f"{text} [Y/n]: ").lower() == 'n':
        return False
    return True

# ────────────────────────────── FUNCTION: init ────────────────────────────── #
def init(dir):
    printr("Initializing new project...")
    if dir == None:
        prompt(f'Project directory not specified. Initialize project in current directory {os.getcwd()}?')
        dir = os.getcwd()
    if dir != None and os.path.exists(dir):
        print('Directory already exists. Please specify a directory that does not exist.')
        sys.exit(1)

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
    parser.add_argument('--docs', help='Automatically create docs for your project', action='store_true')
    parser.add_argument('-v', '--version', help='Get current installed version of phakit', action='store_true')
    parser.add_argument('-u', '--update', help='Update phakit to the latest version', action='store_true')

    # Variables
    parser.add_argument('-d', '--directory', help='The directory to use for this action', default=None)

    # Save arguments
    args      = parser.parse_args()

    if args.version is True:
        with open("/etc/phakit/VERSION", "r") as v:
            printr("phakit version: " + v.read())
            sys.exit(0)
    if args.update is True:
        printr("Updating phakit...")
        sys.exit(0)
    if args.init is True:
        printr("Initializing new project...")
        if os.path.exists(args.directory):
            printr('Directory already exists. Please specify a directory that does not exist.')
            sys.exit(1)

if __name__ == '__main__':
    main()