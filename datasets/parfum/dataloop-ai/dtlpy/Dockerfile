FROM ubuntu:18.04

RUN apt-get -y update && \
    apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
        gcc \
        g++ \
        zlibc \
        zlib1g-dev \
        libssl-dev \
        libbz2-dev \
        libsqlite3-dev \
        libncurses5-dev \
        libgdbm-dev \
        libgdbm-compat-dev \
        liblzma-dev \
        libreadline-dev \
        tk-dev \
        wget \
        curl \
        git \
        make \
        sudo \
        bash-completion \
        tree \
        vim \
        ffmpeg \
        locales \
        software-properties-common

RUN apt install net-tools

RUN apt-get -y update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && ln -s /usr/bin/pip3 pip \
  && pip3 install --upgrade pip

# fix for other languages issues
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ARG BITBUCKET_TAG
ADD ./dist/dtlpy-$BITBUCKET_TAG-py3-none-any.whl /dtlpy-$BITBUCKET_TAG-py3-none-any.whl
RUN mkdir -p /src
ENV PYTHONPATH="$PYTHONPATH:/src"
RUN pip install --no-cache-dir --target=/src /dtlpy-$BITBUCKET_TAG-py3-none-any.whl --upgrade
