FROM opensuse/leap:15.2
ARG USER=docker
ARG UID=1000
ARG GID=1000

LABEL description="antimicroX version 3.0 on Github. See https://github.com/juliagoda/antimicroX" 
MAINTAINER Jagoda Górska <juliagoda.pl@protonmail.com>


RUN zypper refresh && zypper --non-interactive update && zypper --non-interactive install \
    gcc-c++ \
    make \
    libSDL2-devel \
    git-core \
    gettext \
    cmake \
    libfreetype6 \
    freetype \
    fontconfig \
    xorg-x11-fonts \
    xorg-x11-fonts-core \
    extra-cmake-modules \
    libqt5-qttools-devel \
    libqt5-qtbase-devel \
    libqt5-qtx11extras-devel \
    libX11-devel \
    libXtst-devel \
    libXi-devel \
    Mesa-libGL-devel \
    Mesa-dri \
    autoconf \
    pkgconf \
    itstool \
    && zypper clean -a \
    && rm -rf /tmp/* /var/tmp/* 

    
    
RUN git -c http.sslVerify=false clone --depth 1 https://github.com/juliagoda/antimicroX.git --branch 3.0 --single-branch 

WORKDIR antimicroX

RUN mkdir -p build

WORKDIR build


# finally build project from github
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \ 
    make && \ 
    make install 
    
    
WORKDIR ..

RUN rm -rf build
  
  
RUN groupadd --gid ${GID} ${USER} && \
    useradd --uid ${UID} --gid ${GID} ${USER} && \
    usermod -p '' ${USER} && \
    usermod -a -G input ${USER} && \
    usermod -a -G tty ${USER} && \
    usermod -a -G input ${USER}

    
USER ${UID}:${GID}

WORKDIR /home/${USER}

CMD /usr/bin/antimicroX