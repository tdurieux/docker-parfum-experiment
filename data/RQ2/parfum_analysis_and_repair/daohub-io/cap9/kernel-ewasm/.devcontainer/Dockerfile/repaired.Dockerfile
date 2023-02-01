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

# Rust
# install tools and dependencies
RUN apt-get -y update && \
	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
		curl make cmake file ca-certificates  \
		g++ gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
		libc6-dev-arm64-cross binutils-aarch64-linux-gnu \
		&& \
	apt-get clean && rm -rf /var/lib/apt/lists/*;

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# multirust add wasm32-unknown-unknown to the toolchain
RUN rustup target add wasm32-unknown-unknown

# show backtraces
ENV RUST_BACKTRACE 1

# Install eslint
RUN npm install -g eslint && npm cache clean --force;

# Install Parity Fork
RUN git clone --depth 1 https://github.com/Daohub-io/parity-ethereum.git /tmp/parity-ethereum && \
    cd /tmp/parity-ethereum && \
    git fetch --all && \
    git checkout master && \
    cargo install --bin parity -j 1 --path . --bin parity parity-ethereum && \
    cd $HOME

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog

# Set the default shell to bash instead of sh
ENV SHELL /bin/bash