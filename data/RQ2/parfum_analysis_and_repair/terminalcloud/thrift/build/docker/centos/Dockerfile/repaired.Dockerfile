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
#  - D
#  - Haxe
#

FROM centos:6.6
MAINTAINER Apache Thrift <dev@thrift.apache.org>

ENV HOME /root

RUN yum -y update

# General dependencies
RUN yum -y install -y tar m4 perl gcc git libtool libevent-devel zlib-devel openssl-devel && rm -rf /var/cache/yum

RUN mkdir -p /tmp/epel && \
    curl -f -SL "https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm" -o /tmp/epel/epel-release-6-8.noarch.rpm && \
    cd /tmp/epel && \
    rpm -ivh epel-release-6-8.noarch.rpm && \
    cd $HOME

# Autoconf
RUN mkdir -p /tmp/autoconf && \
    curl -f -SL "https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz" | tar -xzC /tmp/autoconf && \
    cd /tmp/autoconf/autoconf-2.69 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && \
    make && \
    make install && \
    cd $HOME

# Automake
RUN mkdir -p /tmp/automake && \
    curl -f -SL "https://ftp.gnu.org/gnu/automake/automake-1.14.tar.gz" | tar -xzC /tmp/automake && \
    cd /tmp/automake/automake-1.14 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && \
    make && \
    make install && \
    cd $HOME

# Bison
RUN mkdir -p /tmp/bison && \
    curl -f -SL "https://ftp.gnu.org/gnu/bison/bison-2.5.1.tar.gz" | tar -xzC /tmp/bison && \
    cd /tmp/bison/bison-2.5.1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && \
    make && \
    make install && \
    cd $HOME

# Install an updated Boost library
RUN mkdir -p /tmp/boost && \
    curl -f -SL "https://sourceforge.net/projects/boost/files/boost/1.55.0/boost_1_55_0.tar.gz" | tar -xzC /tmp/boost && \
    cd /tmp/boost/boost_1_55_0 && \
    ./bootstrap.sh && \
    ./b2 install && \
    cd $HOME

# Java Dependencies
RUN yum install -y ant junit ant-nodeps ant-junit java-1.7.0-openjdk-devel && rm -rf /var/cache/yum

# Python Dependencies
RUN yum install -y python-devel python-setuptools python-twisted && rm -rf /var/cache/yum

# Ruby Dependencies
RUN yum install -y ruby ruby-devel rubygems && \
    gem install bundler rake && rm -rf /var/cache/yum

# Node.js Dependencies
RUN yum install -y nodejs nodejs-devel npm && rm -rf /var/cache/yum

# Perl Dependencies
RUN yum install -y perl-Bit-Vector perl-Class-Accessor perl-ExtUtils-MakeMaker perl-Test-Simple && rm -rf /var/cache/yum

# PHP Dependencies
RUN yum install -y php php-devel php-pear re2c && rm -rf /var/cache/yum

# GLibC Dependencies
RUN yum install -y glib2-devel && rm -rf /var/cache/yum

# Erlang Dependencies
RUN yum install -y erlang-kernel erlang-erts erlang-stdlib erlang-eunit erlang-rebar && rm -rf /var/cache/yum

# Lua Dependencies
RUN yum install -y lua-devel && rm -rf /var/cache/yum

# Go Dependencies
RUN yum install -y golang golang-pkg-linux-amd64 && rm -rf /var/cache/yum

# C# Dependencies
RUN yum install -y mono-core mono-devel mono-web-devel mono-extras mingw32-binutils mingw32-runtime mingw32-nsis && rm -rf /var/cache/yum

# Haskell Dependencies
RUN mkdir -p /tmp/haskell && \
    curl -f -SL "https://sherkin.justhub.org/el6/RPMS/x86_64/justhub-release-2.0-4.0.el6.x86_64.rpm" -o /tmp/haskell/justhub-release-2.0-4.0.el6.x86_64.rpm && \
    cd /tmp/haskell && \
    rpm -ivh justhub-release-2.0-4.0.el6.x86_64.rpm && \
    yum -y install haskell && \
    cabal update && \
    cabal install cabal-install && \
    cd $HOME && rm -rf /var/cache/yum

# Clean up
RUN rm -rf /tmp/*

WORKDIR $HOME