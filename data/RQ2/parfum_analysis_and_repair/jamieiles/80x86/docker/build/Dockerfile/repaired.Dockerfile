FROM s80x86-build-quartus:latest
MAINTAINER Jamie Iles <jamie@jamieiles.com>
ENV DEBIAN_FRONTEND=noninteractive
ARG MIRROR=https://sourcery.mentor.com/GNUToolchain/package14960/public/ia16-elf/
ARG TOOLCHAIN=sourceryg++-2016.11-64-ia16-elf-x86_64-linux-gnu.tar.bz2
ARG VERILATOR_VERSION=4.200
RUN apt-get update && apt-get install --no-install-recommends -y \
        clang \
        clang-c++ \
        cmake \
        cpp \
        git \
        nasm \
        libsdl2-2.0-0 \
        libsdl2-dev \
        libboost-serialization-dev \
        libboost-program-options-dev \
        libboost-python1.71.0 \
        libboost-python-dev \
        libusb-1.0-0-dev \
        python-dev \
        llvm \
        ninja-build \
        ccache \
        ruby \
        ruby-dev \
        python3 \
        python3-distorm3 \
        python3-pip \
        python3-pystache \
        python3-pystache \
        python-lxml \
        python-yaml \
        python3-yaml \
        wget \
        flex \
        bison \
        libfl-dev \
        unzip && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp && \
        wget https://github.com/verilator/verilator/archive/v$VERILATOR_VERSION.zip && \
        unzip v$VERILATOR_VERSION.zip && \
        cd verilator-$VERILATOR_VERSION && \
        autoconf && \
        ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && \
        make -j4 && \
        make install && \
        cd /tmp && \
        rm verilator* -rf
RUN gem install --pre prawn --version 2.1.0
RUN gem install --pre \
        asciidoctor-pdf \
        coderay \
        pygments.rb \
        concurrent-ruby
RUN mkdir -p /build
WORKDIR /build
RUN apt-get install --no-install-recommends -y python3-setuptools && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir textX==1.6.1
RUN rm /usr/bin/gcov; ln -s /usr/bin/llvm-cov /usr/bin/gcov
RUN cd /tmp && \
        wget $MIRROR$TOOLCHAIN && \
        tar -C /usr --strip-components 1 -xf $TOOLCHAIN && \
        rm -rf $TOOLCHAIN
