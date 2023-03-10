FROM swift:focal

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=bash

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install --no-install-recommends -y git python3 python3-virtualenv clang cmake && rm -rf /var/lib/apt/lists/*;

RUN useradd -m builder

# Fetch JerryScript source code
RUN git clone https://github.com/jerryscript-project/jerryscript.git /home/builder/jerryscript
WORKDIR /home/builder/jerryscript

# Docker will attempt to cache the output of every step. That's fine (and useful to speed things up, e.g. by avoiding
# the need to download the entire source repository again every time!). However, whenever the following ARG is changed
# (i.e. we are building a new version of the engine), a cache miss occurs (because the build context changed) and all
# steps from here on are rerun. That, however, means we might be operating on an old checkout of the source code from
# the cache, and so we update it again before checking out the requested revision.
ARG rev=master

# Update system packages first
RUN apt-get -y update && apt-get -y upgrade

# Fetch latest source code and checkout requested source revision
RUN git pull
RUN git checkout $rev

# Upload and apply patches
ADD Patches Patches
RUN for i in `ls Patches`; do patch -p1 < Patches/$i; done

# Start building!
ADD fuzzbuild.sh fuzzbuild.sh
RUN ./fuzzbuild.sh
