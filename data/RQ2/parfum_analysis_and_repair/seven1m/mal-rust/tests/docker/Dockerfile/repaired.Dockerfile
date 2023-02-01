# WARNING: This file is deprecated. Each implementation now has its
# own Dockerfile.

FROM ubuntu:utopic
MAINTAINER Joel Martin <github@martintribe.org>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://dl.bintray.com/sbt/debian /" > /etc/apt/sources.list.d/sbt.list
RUN apt-get -y update

#
# General dependencies
#
VOLUME /mal

RUN apt-get -y --no-install-recommends install make wget curl git && rm -rf /var/lib/apt/lists/*;

# Deps for compiled languages (C, Go, Rust, Nim, etc)
RUN apt-get -y --no-install-recommends install gcc pkg-config && rm -rf /var/lib/apt/lists/*;

# Deps for Java-based languages (Clojure, Scala, Java)
RUN apt-get -y --no-install-recommends install openjdk-7-jdk && rm -rf /var/lib/apt/lists/*;
ENV MAVEN_OPTS -Duser.home=/mal

# Deps for Mono-based languages (C#, VB.Net)
RUN apt-get -y --no-install-recommends install mono-runtime mono-mcs mono-vbnc && rm -rf /var/lib/apt/lists/*;

# Deps for node.js languages (JavaScript, CoffeeScript, miniMAL, etc)
RUN apt-get -y --no-install-recommends install nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN ln -sf nodejs /usr/bin/node


#
# Implementation specific installs
#

# GNU awk
RUN apt-get -y --no-install-recommends install gawk && rm -rf /var/lib/apt/lists/*;

# Bash
RUN apt-get -y --no-install-recommends install bash && rm -rf /var/lib/apt/lists/*;

# C
RUN apt-get -y --no-install-recommends install libglib2.0 libglib2.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libffi-dev libreadline-dev libedit2 libedit-dev && rm -rf /var/lib/apt/lists/*;

# C++
RUN apt-get -y --no-install-recommends install g++-4.9 libreadline-dev && rm -rf /var/lib/apt/lists/*;

# Clojure
ADD https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein \
    /usr/local/bin/lein
RUN sudo chmod 0755 /usr/local/bin/lein
ENV LEIN_HOME /mal/.lein
ENV LEIN_JVM_OPTS -Duser.home=/mal

# CoffeeScript
RUN npm install -g coffee-script && npm cache clean --force;
RUN touch /.coffee_history && chmod go+w /.coffee_history

# C#
RUN apt-get -y --no-install-recommends install mono-mcs && rm -rf /var/lib/apt/lists/*;

# Elixir
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get -y --no-install-recommends install elixir && rm -rf /var/lib/apt/lists/*;

# Erlang R17 (so I can use maps)
RUN apt-get -y --no-install-recommends install build-essential libncurses5-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp && wget https://www.erlang.org/download/otp_src_17.5.tar.gz \
    && tar -C /tmp -zxf /tmp/otp_src_17.5.tar.gz \
    && cd /tmp/otp_src_17.5 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
    && rm -rf /tmp/otp_src_17.5 /tmp/otp_src_17.5.tar.gz
# Rebar for building the Erlang implementation
RUN cd /tmp/ && git clone -q https://github.com/rebar/rebar.git \
    && cd /tmp/rebar && ./bootstrap && cp rebar /usr/local/bin \
    && rm -rf /tmp/rebar

# Forth
RUN apt-get -y --no-install-recommends install gforth && rm -rf /var/lib/apt/lists/*;

# Go
RUN apt-get -y --no-install-recommends install golang && rm -rf /var/lib/apt/lists/*;

# Guile
RUN apt-get -y --no-install-recommends install libunistring-dev libgc-dev autoconf libtool flex gettext texinfo libgmp-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone git://git.sv.gnu.org/guile.git /tmp/guile \
    && cd /tmp/guile && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

# Haskell
RUN apt-get -y --no-install-recommends install ghc haskell-platform libghc-readline-dev libghc-editline-dev && rm -rf /var/lib/apt/lists/*;

# Java
RUN apt-get -y --no-install-recommends install maven2 && rm -rf /var/lib/apt/lists/*;

# JavaScript
# Already satisfied above

# Julia
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository -y ppa:staticfloat/juliareleases
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install julia && rm -rf /var/lib/apt/lists/*;

# Lua
RUN apt-get -y --no-install-recommends install lua5.1 lua-rex-pcre luarocks && rm -rf /var/lib/apt/lists/*;
RUN luarocks install linenoise

# Mal
# N/A: self-hosted on other language implementations

# GNU Make
# Already satisfied as a based dependency for testing

# miniMAL
RUN npm install -g minimal-lisp && npm cache clean --force;

# Nim
RUN cd /tmp && wget https://nim-lang.org/download/nim-0.17.0.tar.xz \
    && tar xvJf /tmp/nim-0.17.0.tar.xz && cd nim-0.17.0 \
    && make && sh install.sh /usr/local/bin \
    && rm -r /tmp/nim-0.17.0 && rm /tmp/nim-0.17.0.tar.xz

# OCaml
RUN apt-get -y --no-install-recommends install ocaml-batteries-included && rm -rf /var/lib/apt/lists/*;

# perl
RUN apt-get -y --no-install-recommends install perl && rm -rf /var/lib/apt/lists/*;

# PHP
RUN apt-get -y --no-install-recommends install php5-cli && rm -rf /var/lib/apt/lists/*;

# PostScript/ghostscript
RUN apt-get -y --no-install-recommends install ghostscript && rm -rf /var/lib/apt/lists/*;

# python
RUN apt-get -y --no-install-recommends install python && rm -rf /var/lib/apt/lists/*;

# R
RUN apt-get -y --no-install-recommends install r-base-core && rm -rf /var/lib/apt/lists/*;

# Racket
RUN apt-get -y --no-install-recommends install racket && rm -rf /var/lib/apt/lists/*;

# Ruby
RUN apt-get -y --no-install-recommends install ruby && rm -rf /var/lib/apt/lists/*;

# Rust
RUN curl -sf https://raw.githubusercontent.com/brson/multirust/master/blastoff.sh | sh

# Scala
RUN apt-get -y --no-install-recommends --force-yes install sbt && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install scala && rm -rf /var/lib/apt/lists/*;
ENV SBT_OPTS -Duser.home=/mal

# VB.Net
RUN apt-get -y --no-install-recommends install mono-vbnc && rm -rf /var/lib/apt/lists/*;

# TODO: move up
# Factor
RUN apt-get -y --no-install-recommends install libgtkglext1 && rm -rf /var/lib/apt/lists/*;
RUN cd /usr/lib/x86_64-linux-gnu/ \
    && wget https://downloads.factorcode.org/releases/0.97/factor-linux-x86-64-0.97.tar.gz \
    && tar xvzf factor-linux-x86-64-0.97.tar.gz \
    && ln -sf /usr/lib/x86_64-linux-gnu/factor/factor /usr/bin/factor \
    && rm factor-linux-x86-64-0.97.tar.gz

# MATLAB is proprietary/licensed. Maybe someday with Octave.
# Swift is XCode/OS X only
ENV SKIP_IMPLS matlab swift

ENV DEBIAN_FRONTEND newt
ENV HOME /

WORKDIR /mal
