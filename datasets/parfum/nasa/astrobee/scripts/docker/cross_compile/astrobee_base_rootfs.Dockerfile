# This will set up an Astrobee docker container using the non-NASA install instructions.
# You must set the docker context to be the repository root directory

FROM astrobee/astrobee:base-toolchain

# install of apt-utils suppresses bogus warnings later
RUN apt-get update \
  && apt-get install -y apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed" \
  && apt-get install -y \
    build-essential \
    cmake \
    git \
    lsb-release \
    sudo \
    wget \
    protobuf-compiler \
  && rm -rf /var/lib/apt/lists/*

# Copy over the rootfs
COPY . /arm_cross/rootfs

