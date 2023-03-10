FROM debian:stretch

ENV OS_IDENTIFIER debian-9

RUN set -x \
  && export DEBIAN_FRONTEND=noninteractive \
  && echo 'deb-src http://deb.debian.org/debian stretch main' >> /etc/apt/sources.list \
  && apt-get update \
  && apt-get install --no-install-recommends -y gcc libcurl4-openssl-dev libicu-dev \
     libopenblas-base libpcre2-dev make python-pip ruby ruby-dev wget \
  && apt-get build-dep -y r-base && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir awscli

RUN chmod 0777 /opt

# Pin fpm to avoid git dependency in 1.12.0
RUN gem install fpm:1.11.0

# Override the default pager used by R
ENV PAGER /usr/bin/pager

COPY package.debian-9 /package.sh
COPY build.sh .
ENTRYPOINT ./build.sh
