#!/bin/python3

# ──────────────────────────────────────────────────────────────────────────── #
#                                    IMPORTS                                   #
# ──────────────────────────────────────────────────────────────────────────── #
import os, sys, argparse, subprocess

# ──────────────────────────────────────────────────────────────────────────── #
#                                   PRECHECKS                                  #
# ──────────────────────────────────────────────────────────────────────────── #
# Check Python version
if sys.version_info < (3, 11):
    sys.exit("Python 3.11 or later is required.")

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

    parser.add_argument('-i', '--init', help='Initialize a new project', default=None)
    parser.add_argument('-p', '--directory', help='The project\'s directory', default=cwd)
    parser.add_argument('-d', '--docs', help='Automatically create docs for your project', default=None)
    parser.add_argument('-v', '--version', help='Get current installed version of phakit', action='store_true')
    args = parser.parse_args()

    initDir = args.init
    if args.init is not None:
        print("Initializing new project...")
        if os.path.exists(args.init):
            print('Directory already exists. Please specify a directory that does not exist.')
            sys.exit(1)

    subprocess.run(['tar', '-czf', args.output, args.directory])

if __name__ == '__main__':
    main()