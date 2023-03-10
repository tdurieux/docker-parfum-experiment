FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONDONTWRITEBYTECODE 1

RUN env > /etc/environment

RUN apt-get update && apt install -y --no-install-recommends git ca-certificates \
    python3-pip python3-wheel python3-setuptools python3-dev python3-pytest \
    vim-tiny less netcat-openbsd inetutils-ping curl patch iproute2 \
    g++ libpci3 libnuma-dev make file openssh-server kmod gdb libopenmpi-dev openmpi-bin psmisc \
        autoconf automake autotools-dev libtool \
        zlib1g-dev rename zip unzip librdmacm-dev gnupg rsync \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN /bin/echo -e "set backspace=indent,eol,start\nset nocompatible\nset ts=4" > /etc/vim/vimrc.tiny

ADD ./engine /antares/engine
RUN NO_PYTHON=1 /antares/engine/install_antares_host.sh && rm -rf /var/lib/apt/lists/* ~/.cache
RUN bash -c 'rm -rf ~/.local/antares/3rdparty/tvm/build/{CMake*,Makefile,cmake_install.cmake}'
RUN bash -c 'rm -rf ~/.local/antares/3rdparty/tvm/{src,include,golang,tests,3rdparty,device-stub,apps,conda,docker,docs,gallery,jvm,nnvm,rust,vta,web,cmake,.??*}'
RUN echo '' > ~/.local/antares/3rdparty/tvm/python/tvm/relay/__init__.py

ENV ANTARES_VERSION 0.3.16.4

RUN cd ~ && git clone https://github.com/microsoft/antares --single-branch --depth 1 antares_core && mv ~/.local/antares/3rdparty antares_core
RUN cd ~ && sed -i "s/@VERSION@/${ANTARES_VERSION}/g" /antares/engine/dist-info/METADATA && cp -r /antares/engine/dist-info ~/antares-${ANTARES_VERSION}.dist-info
RUN cd ~ && rm -rf antares_core/.??* && zip -r /antares-${ANTARES_VERSION}-py3-none-manylinux1_x86_64.whl antares* >/dev/null