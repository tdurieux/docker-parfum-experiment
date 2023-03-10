ARG OS_VERSION=16.04
FROM ubuntu:${OS_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends gawk wget git-core diffstat unzip vim \
    texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev python3-dev sudo cpio file ca-certificates bc locales \
    libsdl1.2-dev xterm sed cvs subversion coreutils texi2html docbook-utils python-pysqlite2 help2man gcc \
    g++ make desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev \
    mercurial autoconf automake groff curl lzop asciidoc u-boot-tools && rm -rf /var/lib/apt/lists/*;

RUN locale-gen en_US.UTF-8

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

ARG BUILD_UID=1000
ARG BUILD_USER=ubuntu
RUN adduser --gecos 'yocto build user' --disabled-password $BUILD_USER --uid $BUILD_UID && \
    usermod -aG sudo ubuntu

USER $BUILD_USER

