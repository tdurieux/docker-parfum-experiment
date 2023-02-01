#
# @author Loreto Parisi (loretoparisi at gmail dot com)
# v1.0.0
#
# Copyright (c) 2017 Loreto Parisi - https://github.com/loretoparisi/docker
#
FROM ubuntu:16.04

MAINTAINER Loreto Parisi <loretoparisi@gmail.com>

# working directory
ENV HOME /root
ENV NODE_VERSION lts
WORKDIR $HOME

# packages list
RUN \
	apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    curl \
    git \
    npm && rm -rf /var/lib/apt/lists/*;

# node.js
RUN npm install n -g && npm cache clean --force;
RUN n $NODE_VERSION
RUN npm update

# build native fasttext
RUN \
	git clone https://github.com/facebookresearch/fastText.git && \
	cd fastText && \
	make

# build fasttext.js
RUN \
    git clone --depth=1 https://github.com/loretoparisi/fasttext.js && \
    cd fasttext.js && \
    npm install && npm cache clean --force;

# copy binaries
RUN cp fastText/fasttext fasttext.js/lib/bin/linux/

# run train
RUN node fasttext.js/examples/train.js

CMD ["bash"]
