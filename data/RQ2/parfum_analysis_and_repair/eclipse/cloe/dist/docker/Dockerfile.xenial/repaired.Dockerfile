# Dockerfile.xenial
#
# See Dockerfile.focal for documentation of each of the lines.
ARG VTD_IMAGE=scratch
FROM ${VTD_IMAGE} AS vtd
WORKDIR /vtd

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Newer CMake and GCC Packages
RUN --mount=type=cache,id=xenial-cache,target=/var/cache/apt \
    --mount=type=cache,id=xenial-lib,target=/var/lib/apt \
    apt-get update && \
    apt-get install --no-install-recommends -y apt-transport-https ca-certificates gnupg software-properties-common wget && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --batch --dearmor - > /etc/apt/trusted.gpg.d/kitware.gpg && \
    apt-add-repository "deb https://apt.kitware.com/ubuntu/ xenial main" && \
    add-apt-repository "ppa:ubuntu-toolchain-r/test" && \
    # Install packages:
    apt-get update && \
    apt-get install --no-install-recommends -y gcc-8 g++-8 cmake && \
    rm -rf /var/lib/apt/lists/*

# Install Pyenv
RUN --mount=type=cache,id=xenial-cache,target=/var/cache/apt \
    --mount=type=cache,id=xenial-lib,target=/var/lib/apt \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        build-essential \
        curl \
        git \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libncurses5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        libxmlsec1-dev \
        llvm \
        make \
        tk-dev \
        wget \
        xz-utils \
        zlib1g-dev \
    && \
    curl -f -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash && \
    rm -rf /var/lib/apt/lists/*

ENV HOME /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

ARG PYTHON_VERSION=3.6.13
RUN pyenv install ${PYTHON_VERSION} && \
    pyenv global ${PYTHON_VERSION} && \
    pyenv rehash

# Install System Packages
COPY Makefile.setup /cloe/Makefile.setup
RUN --mount=type=cache,id=xenial-cache,target=/var/cache/apt \
    --mount=type=cache,id=xenial-lib,target=/var/lib/apt \
    apt-get update && \
    apt-get install --no-install-recommends -y make ccache locales libbsd0 && \
    make -f /cloe/Makefile.setup \
        WITHOUT_DEV_DEPS=yes \
        DEBIAN_FRONTEND=noninteractive \
        APT_ARGS="--no-install-recommends -y" \
        install-system-deps \
        && \
    locale-gen && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV CCACHE_DIR=/ccache
ENV PATH=/usr/lib/ccache:$PATH

RUN pip install --no-cache-dir --upgrade pip && \
    make -f /cloe/Makefile.setup \
        PIP_INSTALL_ARGS="" \
        install-python-deps

# Install and Setup Conan
ARG BUILD_TYPE=RelWithDebInfo
RUN conan profile new --detect default && \
    conan profile update settings.build_type=${BUILD_TYPE} default && \
    conan profile update settings.compiler.libcxx=libstdc++11 default && \
    conan profile update env.PATH="[$PYENV_ROOT/shims,$PYENV_ROOT/bin]" default

ENV CONAN_NON_INTERACTIVE=yes

# Build and Install Cloe
WORKDIR /cloe
ARG WITH_VTD=0
ARG KEEP_SOURCES=0

# Download or build dependencies:
COPY vendor /cloe/vendor
COPY Makefile.package /cloe
COPY Makefile.all /cloe
ARG VENDOR_TARGET="export-vendor download-vendor"
RUN --mount=type=cache,target=/ccache \
    --mount=type=secret,target=/root/setup.sh,id=setup,mode=0400 \
    --mount=type=bind,target=/root/.conan/data/vtd,source=/vtd,from=vtd,rw \
    if [ -r /root/setup.sh ]; then . /root/setup.sh; fi && \
    make -f Makefile.all WITH_VTD=${WITH_VTD} ${VENDOR_TARGET} && \
    # Clean up:
    conan user --clean && \
    if [ ${KEEP_SOURCES} -eq 0 ]; then \
        find /root/.conan/data -name dl -type d -maxdepth 5 -exec rm -r {} + && \
        conan remove \* -s -b -f; \
    else \
        conan remove \* -b -f; \
    fi

# Build Cloe.
COPY . /cloe
ARG PROJECT_VERSION=unknown
ARG PACKAGE_TARGET=package-auto
RUN --mount=type=cache,target=/ccache \
    --mount=type=secret,target=/root/setup.sh,id=setup,mode=0400 \
    if [ -r /root/setup.sh ]; then . /root/setup.sh; fi && \
    echo "${PROJECT_VERSION}" > /cloe/VERSION && \
    make WITH_VTD=${WITH_VTD} ${PACKAGE_TARGET} && \
    # Clean up:
    conan user --clean && \
    if [ ${KEEP_SOURCES} -eq 0 ]; then \
        find /root/.conan/data -name dl -type d -maxdepth 5 -exec rm -r {} + && \
        conan remove \* -s -b -f; \
    else \
        conan remove \* -b -f; \
    fi

# Run smoketests.
RUN --mount=type=secret,target=/root/setup.sh,id=setup,mode=0400 \
    --mount=type=bind,target=/root/.conan/data/vtd,source=/vtd,from=vtd,rw \
    if [ -r /root/setup.sh ]; then . /root/setup.sh; fi && \
    make WITH_VTD=${WITH_VTD} smoketest && \
    conan user --clean
