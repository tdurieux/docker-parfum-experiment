# Dockerfile.focal
#
# This file acts partly as a Docker recipe for building Cloe on Ubuntu.
#
# If you are behind a proxy, make sure to pass in the respective HTTP_PROXY,
# HTTPS_PROXY, and NO_PROXY variables.

# This is a work-around to not being able to use variables in RUN --mount=from:
# If you want to use VTD in this image, you need to specify the Docker image
# containing the distribution that can be mounted at /root/.conan/data/
ARG VTD_IMAGE=scratch
FROM ${VTD_IMAGE} AS vtd
WORKDIR /vtd

FROM ubuntu:20.04

# Install System Packages
#
# These packages are required for building and testing Cloe.
COPY Makefile.setup /cloe/Makefile.setup
RUN --mount=type=cache,id=focal-cache,target=/var/cache/apt \
    --mount=type=cache,id=focal-lib,target=/var/lib/apt \
    apt-get update && \
    apt-get install --no-install-recommends -y make ccache locales && \
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

RUN pip3 install --no-cache-dir --upgrade pip && \
    make -f /cloe/Makefile.setup \
        PIP_INSTALL_ARGS="" \
        install-python-deps

# Install and Setup Conan
#
# You may not want to use the default Conan remote (conan-center), so we use
# whatever is stored in the build arguments CONAN_REMOTE. Currently, only
# anonymous access is possible in this Dockerfile.
ARG BUILD_TYPE=RelWithDebInfo
RUN conan profile new --detect default && \
    conan profile update settings.build_type=${BUILD_TYPE} default && \
    conan profile update settings.compiler.libcxx=libstdc++11 default

ENV CONAN_NON_INTERACTIVE=yes

# Build and Install Cloe
#
# All common processes are made easy to apply by writing target recipes in the
# Makefile at the root of the repository. This also acts as a form of
# documentation.
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
