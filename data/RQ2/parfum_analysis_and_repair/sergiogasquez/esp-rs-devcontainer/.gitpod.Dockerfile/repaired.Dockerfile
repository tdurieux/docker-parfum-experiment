# Note: gitpod/workspace-base image references older version of CMake, it's necessary to install newer one
FROM  gitpod/workspace-base
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# ARGS
# TODO: Configure Dockerfile args
ARG CONTAINER_USER=gitpod
ARG CONTAINER_GROUP=gitpod
ARG TOOLCHAIN_VERSION=1.61.0.0
ARG ESP_IDF_VERSION=release/v4.4
ARG ESP_BOARD=esp32
ARG INSTALL_RUST_TOOLCHAIN=install-rust-toolchain.sh

# Install dependencies
RUN sudo install-packages git curl gcc ninja-build libudev-dev libpython2.7 \
    python3 python3-pip python3-venv libusb-1.0-0 libssl-dev pkg-config libtinfo5 clang
# Set User
USER ${CONTAINER_USER}
WORKDIR /home/${CONTAINER_USER}

# Install Rust toolchain, extra crates and esp-idf