FROM ubuntu:22.04

MAINTAINER Timothy Flynn <trflynn89@pm.me>

ARG CLANG_VERSION
ARG GCC_VERSION
ARG JDK_VERSION

# Install base tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
        bzip2 \
        ccache \
        git \
        lcov \
        make \
        software-properties-common \
        sudo \
    && \

    echo "Set disable_coredump false" >> /etc/sudo.conf && rm -rf /var/lib/apt/lists/*;

# Install gcc
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/ppa \
    && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
        gcc-$GCC_VERSION \
        gcc-$GCC_VERSION-multilib \
        g++-$GCC_VERSION \
        g++-$GCC_VERSION-multilib \
    && \

    for tool in gcc g++ gcov; \
    do \
        update-alternatives --install \
            /usr/bin/$tool $tool /usr/bin/$tool-$GCC_VERSION 1; \
    done && rm -rf /var/lib/apt/lists/*;

# Install clang
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
        clang-$CLANG_VERSION \
        lld-$CLANG_VERSION \
        llvm-$CLANG_VERSION \
    && \

    for tool in clang clang++ ld.lld lld llvm-ar llvm-cov llvm-profdata llvm-strip; \
    do \
        update-alternatives --install \
            /usr/bin/$tool $tool /usr/bin/$tool-$CLANG_VERSION 1; \
    done && rm -rf /var/lib/apt/lists/*;

# Install OpenJDK
RUN if test ! -z "$JDK_VERSION" ; then \
        DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y openjdk-$JDK_VERSION-jdk; rm -rf /var/lib/apt/lists/*; \
    fi

# Cleanup
RUN apt-get clean -y && \
    apt-get autoremove -y && \
    apt-get purge -y && \
    rm -rf /tmp/* /var/tmp/* /var/cache/* /var/lib/apt/lists/*
