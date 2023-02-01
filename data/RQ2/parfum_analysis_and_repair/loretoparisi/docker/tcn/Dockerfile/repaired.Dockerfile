#
# pytorch
# @author Loreto Parisi (loretoparisi at gmail dot com)
# v1.0.0
#
# Copyright (c) 2017 Loreto Parisi - https://github.com/loretoparisi/docker
#
FROM pytorch/pytorch

MAINTAINER Loreto Parisi <loretoparisi@gmail.com>

# working directory
ENV HOME /root
ENV DISPLAY :0.0
WORKDIR $HOME

# packages list
RUN \
	apt-get update && apt-get install --no-install-recommends -y \
    python-dev \
    python-pip \
    curl \
    git && rm -rf /var/lib/apt/lists/*;

# pip
RUN pip install --no-cache-dir --upgrade pip

# matplotlib
RUN \
    apt-get install --no-install-recommends -y \
    libfreetype6-dev \
    libxft-dev && \
    pip install --no-cache-dir matplotlib && rm -rf /var/lib/apt/lists/*;

COPY TCN/ $HOME

CMD ["bash"]
