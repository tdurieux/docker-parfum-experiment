FROM debian:jessie-slim

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install build-essential \
                        gawk \
                        pkg-config \
                        gettext \
                        automake \
                        autogen \
                        texinfo \
                        autoconf \
                        libtool \
                        bison \
                        flex \
                        zlib1g-dev \
                        libgmp3-dev \
                        libmpfr-dev \
                        libmpc-dev \
                        git \
                        sudo \
                        vim && \
    apt-get -y purge manpages \
                     xauth \
                     debconf-i18n && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    apt-get clean all && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/rt-n56u/trunk