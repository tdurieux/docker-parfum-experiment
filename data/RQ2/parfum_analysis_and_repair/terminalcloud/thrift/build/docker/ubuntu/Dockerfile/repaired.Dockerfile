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

# Apache Thrift Docker build environment for Centos
#
# Known missing client libraries:
#  - None

FROM ubuntu:trusty
MAINTAINER Apache Thrift <dev@thrift.apache.org>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get dist-upgrade -y

# General dependencies
RUN apt-get install --no-install-recommends -y automake libtool flex bison pkg-config g++ libssl-dev make libqt4-dev git \
    debhelper && rm -rf /var/lib/apt/lists/*;

# C++ dependencies
RUN apt-get install --no-install-recommends -y libboost-dev libboost-test-dev libboost-program-options-dev \
    libboost-filesystem-dev libboost-system-dev libevent-dev && rm -rf /var/lib/apt/lists/*;

# Java dependencies
RUN apt-get install --no-install-recommends -y ant openjdk-7-jdk maven && \
    update-java-alternatives -s java-1.7.0-openjdk-amd64 && rm -rf /var/lib/apt/lists/*;

# Python dependencies
RUN apt-get install --no-install-recommends -y python-all python-all-dev python-all-dbg python-setuptools python-support && rm -rf /var/lib/apt/lists/*;

# Ruby dependencies
RUN apt-get install --no-install-recommends -y ruby ruby-dev && \
    gem install bundler rake && rm -rf /var/lib/apt/lists/*;

# Perl dependencies
RUN apt-get install --no-install-recommends -y libbit-vector-perl libclass-accessor-class-perl && rm -rf /var/lib/apt/lists/*;

# Php dependencies
RUN apt-get install --no-install-recommends -y php5 php5-dev php5-cli php-pear re2c phpunit && rm -rf /var/lib/apt/lists/*;

# GlibC dependencies
RUN apt-get install --no-install-recommends -y libglib2.0-dev && rm -rf /var/lib/apt/lists/*;

# Erlang dependencies
RUN apt-get install --no-install-recommends -y erlang-base erlang-eunit erlang-dev && rm -rf /var/lib/apt/lists/*;

# GO dependencies
RUN echo "golang-go golang-go/dashboard boolean false" | debconf-set-selections && \
    apt-get install --no-install-recommends -y golang golang-go && rm -rf /var/lib/apt/lists/*;

# Haskell dependencies
RUN apt-get install --no-install-recommends -y ghc cabal-install libghc-binary-dev libghc-network-dev libghc-http-dev \
    libghc-hashable-dev libghc-unordered-containers-dev libghc-vector-dev && \
    cabal update && rm -rf /var/lib/apt/lists/*;

# Haxe
RUN apt-get install --no-install-recommends -y libneko0 && \
    mkdir -p /tmp/haxe /usr/lib/haxe && \
    curl -f https://haxe.org/website-content/downloads/3,1,3/downloads/haxe-3.1.3-linux64.tar.gz -o /tmp/haxe/haxe-3.1.3-linux64.tar.gz && \
    tar -xvzf /tmp/haxe/haxe-3.1.3-linux64.tar.gz -C /usr/lib/haxe --strip-components=1 && \
    ln -s /usr/lib/haxe/haxe /usr/bin/haxe && \
    ln -s /usr/lib/haxe/haxelib /usr/bin/haxelib && \
    ln -s /usr/lib/libneko.so.0 /usr/lib/libneko.so && \
    mkdir -p /usr/lib/haxe/lib && \
    chmod -R 777 /usr/lib/haxe/lib && \
    haxelib setup /usr/lib/haxe/lib && \
    haxelib install hxcpp && rm /tmp/haxe/haxe-3.1.3-linux64.tar.gz && rm -rf /var/lib/apt/lists/*;

# Lua dependencies
RUN apt-get install --no-install-recommends -y lua5.2 lua5.2-dev && rm -rf /var/lib/apt/lists/*;

# Node.js dependencies
RUN apt-get install --no-install-recommends -y nodejs nodejs-dev nodejs-legacy npm && rm -rf /var/lib/apt/lists/*;

# CSharp
RUN apt-get install --no-install-recommends -y mono-gmcs mono-devel mono-xbuild mono-complete libmono-system-web2.0-cil \
    mingw32 mingw32-binutils mingw32-runtime nsis && rm -rf /var/lib/apt/lists/*;

# D dependencies
# THRIFT-2916: DMD pinned to 2.065.0-0 due to regression in 2.066
RUN curl -f https://master.dl.sourceforge.net/project/d-apt/files/d-apt.list -o /etc/apt/sources.list.d/d-apt.list && \
    apt-get update && apt-get -y --no-install-recommends --allow-unauthenticated install --reinstall d-apt-keyring && \
    apt-get update && \
    apt-get install --no-install-recommends -y xdg-utils dmd-bin=2.065.0-0 libphobos2-dev=2.065.0-0 && rm -rf /var/lib/apt/lists/*;

# Clean up
RUN apt-get clean && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

WORKDIR $HOME
