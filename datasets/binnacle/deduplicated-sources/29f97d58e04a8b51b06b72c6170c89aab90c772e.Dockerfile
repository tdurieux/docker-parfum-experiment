FROM ubuntu:vivid
MAINTAINER Joel Martin <github@martintribe.org>

##########################################################
# General requirements for testing or common across many
# implementations
##########################################################

RUN apt-get -y update

# Required for running tests
RUN apt-get -y install make python

# Some typical implementation and test requirements
RUN apt-get -y install curl libreadline-dev libedit-dev

RUN mkdir -p /mal
WORKDIR /mal

##########################################################
# Specific implementation requirements
##########################################################

# For building rpython
RUN apt-get -y install g++

# pypy
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:pypy
RUN apt-get -y update
RUN apt-get -y install pypy

# rpython
RUN apt-get -y install mercurial libffi-dev pkg-config libz-dev libbz2-dev \
    libsqlite3-dev libncurses-dev libexpat1-dev libssl-dev libgdbm-dev tcl-dev

RUN mkdir -p /opt/pypy && \
    curl -L https://bitbucket.org/pypy/pypy/downloads/pypy2-v5.6.0-src.tar.bz2 | tar -xjf - -C /opt/pypy/ --strip-components=1
    #curl https://bitbucket.org/pypy/pypy/get/tip.tar.gz | tar -xzf - -C /opt/pypy/ --strip-components=1
RUN cd /opt/pypy && make && rm -rf /tmp/usession*

RUN ln -sf /opt/pypy/rpython/bin/rpython /usr/local/bin/rpython
RUN ln -sf /opt/pypy/pypy-c /usr/local/bin/pypy
RUN chmod -R ugo+rw /opt/pypy/rpython/_cache

RUN apt-get -y autoremove pypy

