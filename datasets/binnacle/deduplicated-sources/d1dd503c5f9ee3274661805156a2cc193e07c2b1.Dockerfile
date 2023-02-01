#
# Development environment for the MAVSDK based on Fedora 30.
#
# Author: Julian Oes <julian@oes.ch>
#

FROM fedora:30

MAINTAINER Julian Oes <julian@oes.ch>

RUN dnf -y install \
    autoconf \
    automake \
    ccache \
    clang \
    cmake \
    colordiff \
    doxygen \
    gcc \
    gcc-c++ \
    git \
    golang \
    libcurl-devel \
    libtool \
    make \
    ninja-build \
    python \
    redhat-rpm-config \
    rpm-build \
    ruby-devel \
    rubygems \
    sudo \
    tinyxml2-devel \
    wget \
    which \
    zlib-devel \
    && dnf clean all

RUN gem install --no-document fpm;

RUN wget -qO- https://github.com/ncopa/su-exec/archive/dddd1567b7c76365e1e0aac561287975020a8fad.tar.gz | tar xvz && \
    cd su-exec-* && make && mv su-exec /usr/local/bin && cd .. && rm -rf su-exec-*

# Create user with id 1001 (Jenkins docker workflow default)
RUN useradd --shell /bin/bash -u 1001 -c "" -m user

ADD /sudoers.txt /etc/sudoers
RUN chmod 440 /etc/sudoers

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

WORKDIR "/home/user/MAVSDK"
