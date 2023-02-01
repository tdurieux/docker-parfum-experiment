FROM ubuntu:20.04

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
    openssh-client \
    sudo \
    vim \
    wget \
    libqt5core5a \
    libqt5widgets5 \
    libqt5quick5 \
    libqt5quickcontrols2-5 \
    gdb \
    linux-tools-common \
    valgrind \
    x11-apps \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

# && rm -rf /var/lib/apt/lists/*
