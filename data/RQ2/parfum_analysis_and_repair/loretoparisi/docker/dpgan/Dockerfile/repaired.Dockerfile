#
# DPGAN
# Tensorflow
#
# @see https://github.com/lancopku/DPGAN
#
# Copyright (c) 2018 Loreto Parisi - https://github.com/loretoparisi/docker
#

FROM tensorflow/tensorflow:1.3.0-py3

MAINTAINER Loreto Parisi loretoparisi@gmail.com

# working directory
ENV HOME /root
WORKDIR $HOME

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    curl \
    wget \
    vim && rm -rf /var/lib/apt/lists/*;

# pip
RUN pip install --no-cache-dir --upgrade pip

# matplotlib
RUN \
    apt-get install --no-install-recommends -y \
    libfreetype6-dev \
    libxft-dev && \
    pip install --no-cache-dir matplotlib && rm -rf /var/lib/apt/lists/*;

RUN yes | pip install --no-cache-dir \
    nltk

COPY src/ $HOME

CMD ["bash"]
