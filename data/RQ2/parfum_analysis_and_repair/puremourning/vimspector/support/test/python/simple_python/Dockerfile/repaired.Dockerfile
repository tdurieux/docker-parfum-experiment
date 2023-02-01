FROM ubuntu:18.04

RUN apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get -y --no-install-recommends install sudo \
                     lsb-release \
                     ca-certificates \
                     python3-dev \
                     python3-pip \
                     ca-cacert \
                     locales \
                     language-pack-en \
                     libncurses5-dev libncursesw5-dev \
                     git && \
  apt-get -y autoremove && rm -rf /var/lib/apt/lists/*;

## cleanup of files from setup
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install --no-cache-dir debugpy

ADD main.py /root/main.py
