# SPDX-FileCopyrightText: 2009 Fermi Research Alliance, LLC
# SPDX-License-Identifier: Apache-2.0

# Selecting Ubuntu 18:04 as the base OS, current default in GitHub (evaluate switching to 20.04)
FROM ubuntu:18.04
MAINTAINER The GlideinWMS team "glideinwms-support@fnal.gov"
LABEL description="This is custom Docker Image for running GitHub actions locally"

# Install the required packages to be a runner for GitHub actions
# https://github.com/actions/virtual-environments/blob/main/images/linux/Ubuntu1804-README.md

# Update Ubuntu Software repository
RUN apt update

RUN apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# To get the latest git (2.29.2 as of 2020-12-20), git-lfs, git-ftp
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:git-core/ppa -y && \
    apt-get update && \
    apt-get install --no-install-recommends git -y; \
    curl -f -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash; \
    apt-get install -y --no-install-recommends git-lfs ; rm -rf /var/lib/apt/lists/*; \
    apt-get install --no-install-recommends git-ftp -y

# source https://github.com/actions/virtual-environments/tree/main/images/linux/scripts/helpers (permalink)
# defins helper functions like setEtcEnvironmentVariable()
RUN . <(curl -s https://raw.githubusercontent.com/actions/virtual-environments/4de7f89a42529d48d04cc7a7eb85b570b709448c/images/linux/scripts/helpers/etc-environment.sh)

RUN apt-get install -y --no-install-recommends python python-dev python-pip python3 python3-dev python3-pip python3-venv; rm -rf /var/lib/apt/lists/*; \
    export PIPX_BIN_DIR=/opt/pipx_bin; \
    export PIPX_HOME=/opt/pipx; \
    python3 -m pip install pipx; \
    python3 -m pipx ensurepath; \
    setEtcEnvironmentVariable "PIPX_BIN_DIR" $PIPX_BIN_DIR; \
    setEtcEnvironmentVariable "PIPX_HOME" $PIPX_HOME; \
    prependEtcEnvironmentPath $PIPX_BIN_DIR

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt -y --no-install-recommends install nodejs && \
    apt -y --no-install-recommends install gcc g++ make && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt update && apt install -y --no-install-recommends yarn && rm -rf /var/lib/apt/lists/*;


# Default entry point
CMD ["/bin/bash"]


# build info
RUN echo "Source: glideinwms/gwms-actions" > /image-source-info.txt
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt
