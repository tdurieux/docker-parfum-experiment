FROM ubuntu:16.04

MAINTAINER Counterparty Developers <dev@counterparty.io>

# Install common dependencies
RUN apt-get update && apt-get install --no-install-recommends -y apt-utils ca-certificates wget curl git mercurial \
    python3 python3-dev python3-pip python3-setuptools python3-appdirs \
    build-essential vim unzip software-properties-common sudo gettext-base \
    net-tools iputils-ping telnet lynx locales && rm -rf /var/lib/apt/lists/*;

# Upgrade pip3 to newest
RUN pip3 install --no-cache-dir --upgrade pip

# Set locale
RUN dpkg-reconfigure -f noninteractive locales && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Set home dir env variable
ENV HOME /root
