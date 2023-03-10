FROM ubuntu:16.04

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    # common stuff
        git \
        wget \
        unzip \
        python3.5 \
        python3-pip \
        python3-venv \
    # fmp
        ruby \
        ruby-dev \
        rubygems \
        gcc \
        make \
    && rm -rf /var/lib/apt/lists/*

# issues with pip>=10:
# https://github.com/pypa/pip/issues/5240
# https://github.com/pypa/pip/issues/5221
RUN python3 -m pip install -U \
    'pip<10.0.0' \
    'setuptools<=50.3.2'


# install fpm
RUN gem install --no-ri --no-rdoc rake fpm

WORKDIR /root

ADD . /root
