FROM fedora:latest
ARG USER=docker
ARG UID=1000
ARG GID=1000

LABEL description="antimicroX version 3.0 on Github. See https://github.com/juliagoda/antimicroX"
MAINTAINER Jagoda Górska <juliagoda.pl@protonmail.com>


RUN dnf -y update && dnf clean all && dnf -y install \
    gcc-c++ \
    make \
    SDL2-devel \
    wget \
    libtar \
    curl-devel \
    expat-devel \
    gettext-devel \
    openssl-devel \
    zlib-devel \
    cmake \
    extra-cmake-modules \
    qt5-qtbase \
    qt5-qtbase-devel \
    libX11-devel \
    libXtst-devel \
    libXi-devel \
    qt5-qtx11extras-devel \
    mesa-libGL-devel \
    mesa-dri-drivers \
    autoconf \
    pkgconf-pkg-config \
    libtool \
    itstool \
    && dnf clean all \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.24.0.tar.gz && \
    tar -zxf git-2.24.0.tar.gz && \
    cd git-2.24.0 && \
    make prefix=/usr/local all && \
    make prefix=/usr/local install && \
   cd .. && \
    rm -rf git-2.24.0 && rm git-2.24.0.tar.gz


RUN git clone --depth 1 https://github.com/juliagoda/antimicroX.git --branch 3.0 --single-branch

RUN groupadd --gid ${GID} ${USER} && \
    adduser --uid ${UID} --gid ${GID} ${USER} && \
    usermod -p '' ${USER} && \
    usermod -a -G input ${USER} && \
    usermod -a -G tty ${USER} && \
    usermod -a -G games ${USER}


WORKDIR antimicroX

RUN mkdir -p build

WORKDIR build

# finally build project from github
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \ 
    make && \ 
    make install

WORKDIR ..

RUN rm -rf build


USER ${UID}:${GID}

WORKDIR /home/${USER}

CMD /usr/bin/antimicroX
