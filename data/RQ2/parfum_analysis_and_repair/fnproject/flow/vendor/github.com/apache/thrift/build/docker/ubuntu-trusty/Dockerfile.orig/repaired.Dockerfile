# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Apache Thrift Docker build environment for Ubuntu
#
# Known missing client libraries:
#  - dotnetcore

FROM buildpack-deps:trusty-scm
MAINTAINER Apache Thrift <dev@thrift.apache.org>

ENV DEBIAN_FRONTEND noninteractive

# Add apt sources
# CMAKE
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:george-edison55/cmake-3.x && rm -rf /var/lib/apt/lists/*;

# Erlang
RUN echo 'deb http://packages.erlang-solutions.com/debian trusty contrib' > /etc/apt/sources.list.d/erlang_solutions.list && \
    curl -f -sSL https://packages.erlang-solutions.com/debian/erlang_solutions.asc | apt-key add -

# Dart
RUN curl -f https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    curl -f https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list && \
    sed -i /etc/apt/sources.list.d/dart_stable.list -e 's/https:/http:/g'

# Consider using mirror nearby when building locally
# TODO: Provide option via --build-arg=...
# RUN sed -i /etc/apt/sources.list -e 's!http://archive.ubuntu.com/ubuntu/!http://your/mirror/!g'

RUN apt-get update && apt-get install -y --no-install-recommends \
`# General dependencies` \
      bison \
      build-essential \
      clang \
      cmake \
      debhelper \
      flex \
      ninja-build \
      pkg-config \
`# Included in buildpack-deps` \
`#      autoconf` \
`#      automake` \
`#      g++` \
`#      git` \
`#      libtool` \
`#      make` && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
`# C++ dependencies` \
`# libevent and OpenSSL are needed by D too` \
      libboost-dev \
      libboost-filesystem-dev \
      libboost-program-options-dev \
      libboost-system-dev \
      libboost-test-dev \
      libboost-thread-dev \
      libevent-dev \
      libssl-dev \
      qt5-default \
      qtbase5-dev \
      qtbase5-dev-tools && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
`# Java dependencies` \
      ant \
      ant-optional \
      openjdk-7-jdk \
      maven && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
`# Python dependencies` \
`# TODO:` \
`# Install twisted and zope.interface via pip. we need twisted at ./configure time, otherwise` \
`# py.twisted tests are skipped.` \
      python-all \
      python-all-dbg \
      python-all-dev \
      python-pip \
      python-setuptools \
      python-twisted \
      python-zope.interface \
      python3-all \
      python3-all-dbg \
      python3-all-dev \
      python3-setuptools \
      python3-pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
`# Ruby dependencies` \
      ruby \
      ruby-dev \
      ruby-bundler \
`# Perl dependencies` \
      libbit-vector-perl \
      libclass-accessor-class-perl \
      libcrypt-ssleay-perl \
      libio-socket-ssl-perl \
      libnet-ssleay-perl && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
`# Php dependencies` \
      php5 \
      php5-dev \
      php5-cli \
      php-pear \
      re2c \
      phpunit \
`# GlibC dependencies` \
      libglib2.0-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install -y --no-install-recommends \
`# Erlang dependencies` \
      erlang-base \
      erlang-eunit \
      erlang-dev \
      erlang-tools \
      rebar && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
`# Haskell dependencies` \
      ghc \
      cabal-install \
`# Haxe dependencies` \
      neko \
      neko-dev \
      libneko0 && rm -rf /var/lib/apt/lists/*;

# Newer release of nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_4.x | bash
RUN apt-get install -y --no-install-recommends \
`# Node.js dependencies` \
      nodejs && rm -rf /var/lib/apt/lists/*;

# Add mono package repository url to get latest version of mono
RUN echo "deb http://download.mono-project.com/repo/debian trusty main" | tee /etc/apt/sources.list.d/mono.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A6A19B38D3D831EF
RUN apt-get update && apt-get install -y --no-install-recommends \
`# CSharp dependencies` \
      mono-devel && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
`# D dependencies` \
      xdg-utils \
`# Dart dependencies` \
      dart \
`# Lua dependencies` \
      lua5.2 \
      lua5.2-dev \
`# MinGW dependencies` \
      mingw32 \
      mingw32-binutils \
      mingw32-runtime \
      nsis \
`# Clean up` \
    && rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

# Ruby
RUN gem install bundler --no-ri --no-rdoc

# Python optional dependencies
RUN pip2 install --no-cache-dir -U ipaddress backports.ssl_match_hostname tornado
RUN pip3 install --no-cache-dir -U backports.ssl_match_hostname tornado

# Go
RUN curl -f -sSL https://storage.googleapis.com/golang/go1.4.3.linux-amd64.tar.gz | tar -C /usr/local/ -xz
ENV PATH /usr/local/go/bin:$PATH

# Haxe
RUN mkdir -p /usr/lib/haxe && \
    wget -O - https://github.com/HaxeFoundation/haxe/releases/download/3.2.1/haxe-3.2.1-linux64.tar.gz | \
    tar -C /usr/lib/haxe --strip-components=1 -xz && \
    ln -s /usr/lib/haxe/haxe /usr/bin/haxe && \
    ln -s /usr/lib/haxe/haxelib /usr/bin/haxelib && \
    mkdir -p /usr/lib/haxe/lib  && \
    chmod -R 777 /usr/lib/haxe/lib && \
    haxelib setup --always /usr/lib/haxe/lib && \
    haxelib install --always hxcpp 3.4.64

# Node.js
# temporarily removed since this breaks the build (and is not needed to test C# code)
# RUN curl -sSL https://www.npmjs.com/install.sh | sh

# D
RUN curl -f -sSL https://downloads.dlang.org/releases/2.x/2.070.0/dmd_2.070.0-0_amd64.deb -o /tmp/dmd_2.070.0-0_amd64.deb && \
    dpkg -i /tmp/dmd_2.070.0-0_amd64.deb && \
    rm /tmp/dmd_2.070.0-0_amd64.deb && \
    curl -f -sSL https://github.com/D-Programming-Deimos/openssl/archive/master.tar.gz | tar xz && \
    curl -f -sSL https://github.com/D-Programming-Deimos/libevent/archive/master.tar.gz | tar xz && \
    mkdir -p /usr/include/dmd/druntime/import/deimos /usr/include/dmd/druntime/import/C && \
    mv libevent-master/deimos/* openssl-master/deimos/* /usr/include/dmd/druntime/import/deimos/ && \
    mv libevent-master/C/* openssl-master/C/* /usr/include/dmd/druntime/import/C/ && \
    rm -rf libevent-master openssl-master && \
    echo 'gcc -Wl,--no-as-needed $*' > /usr/local/bin/gcc-dmd && \
    chmod 755 /usr/local/bin/gcc-dmd && \
    echo 'CC=/usr/local/bin/gcc-dmd' >> /etc/dmd.conf

# Dart
ENV PATH /usr/lib/dart/bin:$PATH

# OCaml
RUN echo 'deb http://ppa.launchpad.net/avsm/ppa/ubuntu trusty main' > /etc/apt/sources.list.d/avsm-official-ocaml.list && \
    gpg --batch --keyserver keyserver.ubuntu.com --recv 61707B09 && \
    gpg --batch --export --armor 61707B09 | apt-key add - && \
    apt-get update && \
    apt-get install --no-install-recommends -y ocaml opam && \
    opam init && \
    opam install oasis && rm -rf /var/lib/apt/lists/*;

# Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.17.0
ENV PATH /root/.cargo/bin:$PATH

ENV THRIFT_ROOT /thrift
RUN mkdir -p $THRIFT_ROOT/src
COPY Dockerfile $THRIFT_ROOT/
WORKDIR $THRIFT_ROOT/src
