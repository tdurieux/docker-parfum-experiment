FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install --no-install-recommends -qy zsh ksh expect openssl shellcheck man && rm -rf /var/lib/apt/lists/*;

RUN mkdir /opt/encpass

VOLUME /opt/encpass
