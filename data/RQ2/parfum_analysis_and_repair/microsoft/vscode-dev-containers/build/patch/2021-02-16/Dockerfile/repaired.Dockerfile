#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

ARG ORIGINAL_IMAGE=mcr.microsoft.com/vscode/devcontainers/javascript-node@sha256:204e54a530c14868112b2b533e9428b4737c6d6ae5304ae2b63248d33807f866
FROM ${ORIGINAL_IMAGE}

ARG PACKAGE_LIST="\
libonig-dev \
libonig4 \
libonig4-dbg \
dnsmasq \
dnsmasq-base \
dnsmasq-utils \
tar \
"

# Script to iterate through the above list and update packages