FROM ubuntu:focal

ENV OS_IDENTIFIER ubuntu-2004

RUN set -x \
  && sed -i "s|# deb-src|deb-src|g" /etc/apt/sources.list \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install --no-install-recommends -y libblas-dev libcurl4-openssl-dev libicu-dev liblapack-dev libpcre2-dev wget python3-pip ruby ruby-dev \
  && apt-get build-dep -y r-base && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir awscli

# Pin fpm to avoid git dependency in 1.12.0
RUN gem install fpm:1.11.0

RUN chmod 0777 /opt

# Override the default pager used by R
ENV PAGER /usr/bin/pager

COPY package.ubuntu-2004 /package.sh
COPY build.sh .
ENTRYPOINT ./build.sh
