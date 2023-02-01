FROM ruby:2.4-slim-stretch

RUN apt-get update \
    && apt-get install -y --no-install-recommends cmake make gcc pkg-config squashfs-tools git curl bison rsync \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L http://enclose.io/rubyc/rubyc-linux-x64.gz | gunzip > /usr/local/bin/rubyc \
    && chmod +x /usr/local/bin/rubyc

RUN gem update --system && gem update bundler

ENV CPPFLAGS="-P"
ENV RUBYC="/usr/local/bin/rubyc"
ENV LANG=C.UTF-8
