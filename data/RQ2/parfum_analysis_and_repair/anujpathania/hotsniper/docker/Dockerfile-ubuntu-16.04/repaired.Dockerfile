FROM ubuntu:16.04
# Add i386 support for support for Pin
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install --no-install-recommends -y \
    python \
    screen \
    tmux \
    binutils \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
 && rm -rf /var/lib/apt/lists/*
# For building Sniper
RUN apt-get update && apt-get install --no-install-recommends -y \
    automake \
    build-essential \
    curl \
    wget \
    libboost-dev \
    libsqlite3-dev \
    zlib1g-dev \
    libbz2-dev \
    g++-4.8 \
    g++-4.9 \
 && rm -rf /var/lib/apt/lists/*
# For building RISC-V Tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    nano \
    autoconf \
    automake \
    autotools-dev \
    bc \
    bison \
    curl \
    device-tree-compiler \
    flex \
    gawk \
    gperf \
    libexpat-dev \
    libgmp-dev \
    libmpc-dev \
    libmpfr-dev \
    libtool \
    libusb-1.0-0-dev \
    patchutils \
    pkg-config \
    texinfo \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*
# Helper utilities
RUN apt-get update && apt-get install --no-install-recommends -y \
    gdb \
    git \
 && rm -rf /var/lib/apt/lists/*
# Benchmark utilities
RUN apt-get update && apt-get install --no-install-recommends -y \
    gettext \
    gfortran \
    m4 \
    xsltproc \
    libx11-dev \
    libxext-dev \
    libxt-dev \
    libxmu-dev \
    libxi-dev \
    gnuplot \
 && rm -rf /var/lib/apt/lists/*
 # Python3,pip3 and modules for simulationcontrol
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
 && rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache-dir --upgrade pip==20.*# pip 21 is not compatible with Ubuntu 16.04 Python version
RUN pip3 install --no-cache-dir matplotlib seaborn diskcache tabulate
