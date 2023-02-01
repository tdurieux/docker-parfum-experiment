FROM ubuntu:16.04

RUN apt-get update -y && apt-get install --no-install-recommends -y \

        git \
        wget \
        unzip \
        python3.5 \
        python3-pip \
        python-setuptools \
        python3-venv \

        ruby \
        ruby-dev \
        rubygems \
        gcc \
        make \

        debhelper \
        autotools-dev \
        libreadline-dev \
        flex \
        bison \
        libtool \
        automake \
        libgmp-dev \

        openssl \
        libssl-dev && rm -rf /var/lib/apt/lists/*;

# install fpm
RUN gem install --no-ri --no-rdoc fpm

WORKDIR /root

ADD . /root
