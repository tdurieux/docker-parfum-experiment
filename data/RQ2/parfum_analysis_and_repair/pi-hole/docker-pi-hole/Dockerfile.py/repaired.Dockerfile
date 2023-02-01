#!/usr/bin/env python3
""" Dockerfile.py - generates and build dockerfiles

Usage:
  Dockerfile.py [--hub_tag=<tag>] [--arch=<arch> ...] [--debian=<version> ...] [-v] [-t] [--no-build] [--no-cache] [--fail-fast]

Options:
    --no-build           Skip building the docker images
    --no-cache           Build without using any cache data
    --fail-fast          Exit on first build error
    --hub_tag=<tag>      What the Docker Hub Image should be tagged as [default: None]
    --arch=<arch>        What Architecture(s) to build     [default: amd64 armel armhf arm64]
    --debian=<version>   What debian version(s) to build   [default: stretch buster bullseye]
    -v                   Print docker's command output     [default: False]
    -t                   Print docker's build time         [default: False]

Examples:
"""
from docopt import docopt
import os
import sys
import subprocess
from dotenv import dotenv_values

def build_dockerfiles(args) -> bool:
    all_success = True
    if args['-v']:
        print(args)
    if args['--no-build']:
        print(" ::: Skipping Dockerfile building")
        return all_success

    for arch in args['--arch']:
        for debian_version in args['--debian']:
            all_success = build('pihole', arch, debian_version, args['--hub_tag'], args['-t'], args['--no-cache'], args['-v']) and all_success
            if not all_success and args['--fail-fast']:
                return False
    return all_success


def run_and_stream_command_output(command, environment_vars, verbose) -> bool:
    print("Running", command)
    build_result = subprocess.Popen(command.split(), env=environment_vars, stdout=subprocess.PIPE,
                                    stderr=subprocess.STDOUT, bufsize=1, universal_newlines=True)
    if verbose:
        while build_result.poll() is None:
            for line in build_result.stdout:
                print(line, end='')
    build_result.wait()
    if build_result.returncode != 0:
        print(f'     ::: Error running: {command}')
        print(build_result.stderr)
    return build_result.returncode == 0


def build(docker_repo: str, arch: str, debian_version: str, hub_tag: str, show_time: bool, no_cache: bool, verbose: bool) -> bool:
    # remove the `pihole/pihole:` from hub_tag for use elsewhere