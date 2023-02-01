#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM node:lts

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1 && rm -rf /var/lib/apt/lists/*;

# Verify git and needed tools are installed
RUN apt-get install --no-install-recommends -y git procps && rm -rf /var/lib/apt/lists/*;

# Remove outdated yarn from /opt and install via package
# so it can be easily updated via apt-get upgrade yarn
RUN rm -rf /opt/yarn-* \
    && rm -f /usr/local/bin/yarn \
    && rm -f /usr/local/bin/yarnpkg \
    && apt-get install --no-install-recommends -y curl apt-transport-https lsb-release \
    && curl -f -sS https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/pubkey.gpg | apt-key add - 2>/dev/null \
    && echo "deb https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get -y install --no-install-recommends yarn && rm -rf /var/lib/apt/lists/*;

# Install eslint
RUN npm install -g eslint && npm cache clean --force;

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog

VOLUME ["/root/.ssh"]
VOLUME ["/home/pi/teslacam/video"]
VOLUmE ["/home/pi/teslacam/images"]

# Set the default shell to bash instead of sh
ENV SHELL /bin/bash