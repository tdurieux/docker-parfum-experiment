FROM ubuntu:20.04

RUN  apt-get update -q \
  && apt-get install -qy \
    git \
    python3 \
    rsync \
    locales \
    make \
  && apt-get -y autoremove \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*

# ensure python runs with utf-8 encoding
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# install mergerfs-tools to /usr/local/bin:
RUN mkdir /src \
      && cd /src \
      && git clone https://github.com/joemiller/mergerfs-tools.git \
      && cd mergerfs-tools \
      && make install \
      && rm -rf -- /src
