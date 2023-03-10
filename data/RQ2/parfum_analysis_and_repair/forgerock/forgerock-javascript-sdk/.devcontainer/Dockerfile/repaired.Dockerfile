#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# Update the VARIANT arg in devcontainer.json to pick an Ubuntu version: 20.04, 18.04
ARG VARIANT="20.04"
FROM buildpack-deps:${VARIANT}-curl

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Options for common package install script - SHA generated on release
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG COMMON_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/master/script-library/common-debian.sh"
ARG COMMON_SCRIPT_SHA="dev-mode"

# Configure apt and install packages
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    #
    # Verify git, common tools / libs installed, add/modify non-root user, optionally install zsh
    && apt-get -y install --no-install-recommends curl ca-certificates 2>&1 \
    && curl -f -sSL ${COMMON_SCRIPT_SOURCE} -o /tmp/common-setup.sh \
    && ( [ "${COMMON_SCRIPT_SHA}" = "dev-mode" ] || ( echo "${COMMON_SCRIPT_SHA}  /tmp/common-setup.sh" | sha256sum -c -)) \
    && /bin/bash /tmp/common-setup.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    && rm /tmp/common-setup.sh \
    #
    # Clean ups
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    #
    # Install Node.js
    && curl -f -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install --no-install-recommends -y nodejs \
    #
    # Install Vi
    && apt-get install --no-install-recommends -y vim \
    && git config --global core.editor "vim" && rm -rf /var/lib/apt/lists/*;
