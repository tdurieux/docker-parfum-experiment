#
# indic-trans CPU Dockerfile
# @author Loreto Parisi (loretoparisi at gmail dot com)
# @see https://github.com/facebookresearch/fastText
# v1.0.0
#
# Copyright (c) 2017 Loreto Parisi - https://github.com/loretoparisi/docker
#

FROM ubuntu:16.04


MAINTAINER Loreto Parisi loretoparisi@gmail.com

# working directory
WORKDIR /root

# install
RUN \
	apt-get update && apt-get install --no-install-recommends -y \
	git \
	wget \
	unzip \
    python-pip && rm -rf /var/lib/apt/lists/*;

# upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# build
RUN \
	git clone https://github.com/libindic/indic-trans && \
    cd indic-trans && \
	pip install --no-cache-dir -r requirements.txt && \
	python setup.py install

# defaults command
CMD ["bash"]

