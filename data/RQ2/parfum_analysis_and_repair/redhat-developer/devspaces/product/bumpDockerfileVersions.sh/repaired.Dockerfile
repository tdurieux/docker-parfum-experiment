#!/bin/bash

# script to bump .x branch to the latest version, in case Jenkins is hosed and can't do the sync jobs

usage() {
    echo "
Usage: $0 -b SOURCE_BRANCH -v CSV_VERSION
Example: $0 -b devspaces-3-rhel-8 -v 3.yy
"
    exit
}

# commandline args