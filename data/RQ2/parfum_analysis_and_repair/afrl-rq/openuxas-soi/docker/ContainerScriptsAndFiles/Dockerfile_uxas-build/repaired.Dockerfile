FROM ubuntu:artful

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    ant \
    autoconf \
    build-essential \
    cmake \
    curl \
    gdb \ 
    gdbserver \ 
    git \
    libczmq-dev \
    libgtest-dev \
    libminizip-dev \
    libtool-bin \
    libzmq3-dev \
    ninja-build \
    openjdk-8-jdk \
    pkg-config \
    python-dev \
    python2.7 \
    python-pip \
    python3-pip \
    python3-setuptools \
    rsync \
    unzip \
    uuid-dev \
    wget \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
    automake && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir -Iv https://github.com/mesonbuild/meson/releases/download/0.47.0/meson-0.47.0.tar.gz

WORKDIR /UxAS/Installation/InstallLibraries/
COPY ContainerScriptsAndFiles/InstallLibraries/* ./
RUN chmod -R +x . \
    && python3 ./00_InstallDependencies.py NO_SUDO

WORKDIR /UxAS
