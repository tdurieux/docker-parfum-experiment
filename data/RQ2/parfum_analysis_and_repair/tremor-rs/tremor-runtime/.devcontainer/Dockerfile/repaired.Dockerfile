#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM rust:1

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update -y \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Install linux perf \
    && apt-get install --no-install-recommends -y linux-perf linux-base \
    # Install valgrind
    && apt-get install --no-install-recommends -y valgrind google-perftools python3-pip \
    && pip3 install --no-cache-dir gprof2dot \
    # Verify git, needed tools installed
    && apt-get -y --no-install-recommends install git iproute2 procps lsb-release \
    #
    # Install lldb, vadimcn.vscode-lldb VSCode extension dependencies
    && apt-get install --no-install-recommends -y lldb python3-minimal libpython3.7 \
    # Tremor deps
    && apt-get install --no-install-recommends -y libclang-dev cmake \
    #
    # Install Rust components
    && rustup update 2>&1 \
    && rustup component add rls rust-analysis rust-src rustfmt clippy 2>&1 \
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for the non-root user
    && apt-get install --no-install-recommends -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

# Make sure container and native targets do not clash/overlap
ENV CARGO_TARGET_DIR=/workspaces/tremor-runtime/target.vsc

# State we're running in a dev container / vscode as a flag for scripts
ENV TREMOR_DEV_ENV=devcontainer

# Default to release mode benchmark runs
ENV TREMOR_MODE=release

# Install flamegraph support
RUN cargo install flamegraph
