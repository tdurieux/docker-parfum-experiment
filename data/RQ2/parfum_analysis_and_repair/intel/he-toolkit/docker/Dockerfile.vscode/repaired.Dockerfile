# Copyright (C) 2022 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

# Username
ARG VSCODE_BASE_IMAGE

FROM $VSCODE_BASE_IMAGE

ARG UNAME
ARG HOME="/home/$UNAME"

LABEL maintainer="https://github.com/intel/he-toolkit"

# code-server runs on HTTPS port 8888
EXPOSE 8888/tcp

# Download and install the latest version of code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create space for IDE settings and workspace
RUN mkdir -p $HOME/User $HOME/he-workspace/.vscode && \
    # Move code-server IDE settings into correct location
    cp $HOME/he-toolkit/docker/ide-config/settings.json $HOME/he-workspace/.vscode/

# Install code-server extensions
RUN for e in vscode.cpp twxs.cmake ms-vscode.cmake-tools vadimcn.vscode-lldb; do \
      code-server --user-data-dir=$HOME/ --install-extension $e; \
    done


# Update code-server user settings
RUN echo '{"extensions.autoUpdate": false, "workbench.colorTheme": "Default Dark+"}' |\
    jq . > $HOME/User/settings.json && \
    # Create a randomly generated self-signed certificate for code-server \