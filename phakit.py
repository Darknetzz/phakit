#!/bin/python3

import os, sys, argparse, subprocess

def main():
    parser = argparse.ArgumentParser(description='A tool to make a package from a directory')
    parser.add_argument('directory', help='The directory to package')
    parser.add_argument('output', help='The output file')
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