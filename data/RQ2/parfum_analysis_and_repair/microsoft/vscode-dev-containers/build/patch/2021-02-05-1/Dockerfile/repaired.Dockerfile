#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

ARG ORIGINAL_IMAGE=mcr.microsoft.com/vscode/devcontainers/javascript-node@sha256:58ecafbc0455c024b3bcdde60036f262edc3d139b8308c8f5e6e17c55252253a
FROM ${ORIGINAL_IMAGE}

ARG PACKAGE_LIST="\
sudo \
linux-libc-dev \
libp11-kit0 \
"

# Script to iterate through the above list and update packages