#!/bin/python3

import os, sys, argparse, subprocess

# Check Python version
if sys.version_info < (3, 11):
    sys.exit("Python 3.11 or later is required.")

def main():
    parser = argparse.ArgumentParser(
        prog='phakit',
        description='A tool to make a package from a directory',
        epilog='by @Darknetzz'
    )

    parser.add_argument('-i', '--init', help='Initialize a new project', default=None)
    parser.add_argument('-d', '--docs', help='Automatically create docs for your project')
    parser.add_argument('-v', '--version', help='Get current installed version of phakit')
    args = parser.parse_args()

    if args.init is not None:
        print("Initializing new project...")
        if os.path.exists(args.directory):
            print('Directory already exists. Please specify a directory that does not exist.')
            sys.exit(1)

    subprocess.run(['tar', '-czf', args.output, args.directory])

if __name__ == '__main__':
    main()