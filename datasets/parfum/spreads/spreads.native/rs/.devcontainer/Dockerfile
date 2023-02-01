#FROM rustlang/rust:nightly
FROM rust:1.41.0

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
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git, needed tools installed
    && apt-get -y install git iproute2 procps lsb-release \
    #
    # Install clang
    && apt-get update && apt-get install -y gnupg wget software-properties-common \
    && bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" \
    && ln -s /usr/bin/clang-9 /usr/bin/clang \
    #
    # Install Ninja
    #
    && apt-get install ninja-build \
    #
    # Install vadimcn.vscode-lldb VSCode extension dependencies (other than lldb)
    && apt-get install -y python3-minimal libpython3.7 \
    #
    # Install CMake
    && wget https://cmake.org/files/v3.16/cmake-3.16.3-Linux-x86_64.sh \
    && mkdir /opt/cmake \
    && sh cmake-3.16.3-Linux-x86_64.sh --prefix=/opt/cmake --skip-license \
    && ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake \
    #
    # Install Rust components
    && rustup update \
    && rustup component add rust-analysis rust-src rustfmt clippy \ 
    # rls
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Install Node & NPM
    # && sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - \
    # && apt-get install -y nodejs \
    #
    # install rust-analyzer
    # && git clone https://github.com/rust-analyzer/rust-analyzer --depth=1 && cd rust-analyzer \
    # && cargo xtask install --server \
    # && cargo install --path ./crates/ra_lsp_server \
    #
    # Set Rust back to stable, nightly only needed for rust-analyzer
    # && rustup default stable \
    # && rustup component add rls rust-analysis rust-src rustfmt clippy \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* 
    #

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
