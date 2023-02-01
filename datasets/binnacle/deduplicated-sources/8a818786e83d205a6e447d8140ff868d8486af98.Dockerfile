FROM python:3-alpine

ENV CPUCOUNT 1
RUN CPUCOUNT=$(cat /proc/cpuinfo | grep '^processor.*:' | wc -l)

RUN echo "@edgunity http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk add --update --no-cache \
    build-base \
    openblas-dev@community \
    unzip \
    wget \
    cmake \

    #Intel® TBB, a widely used C++ template library for task parallelism'
    libtbb@testing  \
    libtbb-dev@testing   \

    # Wrapper for libjpeg-turbo
    libjpeg  \

    # accelerated baseline JPEG compression and decompression library
    libjpeg-turbo-dev \

    # Portable Network Graphics library
    libpng-dev \

    # A software-based implementation of the codec specified in the emerging JPEG-2000 Part-1 standard (development files)
    jasper-dev \

    # Provides support for the Tag Image File Format or TIFF (development files)
    tiff-dev \

    # Libraries for working with WebP images (development files)
    libwebp-dev \

    # A C language family front-end for LLVM (development files)
    clang \
    clang-dev \

    linux-headers \

    # Python packages
    python3-dev \

    && pip install numpy

ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++
