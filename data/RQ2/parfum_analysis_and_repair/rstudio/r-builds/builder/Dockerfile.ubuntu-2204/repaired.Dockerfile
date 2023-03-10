FROM ubuntu:jammy

ENV OS_IDENTIFIER ubuntu-2204

RUN set -x \
  && sed -i "s|# deb-src|deb-src|g" /etc/apt/sources.list \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install --no-install-recommends -y libcurl4-openssl-dev libicu-dev libopenblas-base libpcre2-dev wget python3-pip ruby ruby-dev \
  && apt-get build-dep -y r-base && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir awscli

RUN gem install fpm

RUN chmod 0777 /opt

# Override the default pager used by R
ENV PAGER /usr/bin/pager

# R 3.x requires PCRE2 for Pango support on Ubuntu 22
ENV INCLUDE_PCRE2_IN_R_3 yes

COPY package.ubuntu-2204 /package.sh
COPY build.sh .
ENTRYPOINT ./build.sh
