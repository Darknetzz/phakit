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

    parser.add_argument('-c', '--create', help='Initialize a new project')
    parser.add_argument('-d', '--docs')
    args = parser.parse_args()

    if not os.path.exists(args.directory):
        print('Directory does not exist')
        sys.exit(1)

    if os.path.exists(args.output):
        print('Output file already exists')
        sys.exit(1)

    subprocess.run(['tar', '-czf', args.output, args.directory])

if __name__ == '__main__':
    main()