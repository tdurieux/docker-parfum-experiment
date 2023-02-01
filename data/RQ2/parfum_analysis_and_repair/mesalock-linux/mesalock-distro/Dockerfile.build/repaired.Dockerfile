FROM ubuntu:16.04
MAINTAINER Mingshen Sun <mssun@mesalock-linux.org>

ENV PATH="/root/.cargo/bin:/usr/lib/go-1.9/bin:${PATH}"

RUN apt-get update && \
    apt-get install -q -y --no-install-recommends \
        curl \
        git \
        build-essential \
        cmake \
        wget \
        bc \
        gawk \
        parallel \
        pigz \
        cpio \
        bison \
        flex \
        libelf-dev \
        xorriso \
        fakeroot \
        syslinux-utils \
        uuid-dev \
        libmpc-dev \
        libisl-dev \
        libz-dev \
        python-pip \
        python-setuptools \
        software-properties-common && \
    add-apt-repository -y ppa:gophers/archive && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends \
        golang-1.9-go && rm -rf /var/lib/apt/lists/*;

# Dependencies of building pypy
RUN apt-get install -q -y --no-install-recommends \
        pypy \
        gcc \
        make \
        libffi-dev \
        pkg-config \
        zlib1g-dev \
        libbz2-dev \
        libsqlite3-dev \
        libncurses5-dev \
        libexpat1-dev \
        libssl-dev \
        libgdbm-dev \
        tk-dev \
        libgc-dev \
        python-cffi \
        liblzma-dev \
        libncursesw5-dev && rm -rf /var/lib/apt/lists/*;

# Dependencies of building MesaLink
RUN apt-get install -q -y --no-install-recommends \
        m4 \
        autoconf \
        automake \
        libtool \
        make \
        gcc \
        curl && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir wheel
RUN pip install --no-cache-dir sphinx

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN rustup install nightly-2018-10-24
RUN rustup default 1.30.1
