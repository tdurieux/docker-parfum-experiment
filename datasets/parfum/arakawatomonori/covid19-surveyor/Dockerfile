FROM ubuntu:18.04
MAINTAINER TAKANO Mitsuhiro
# @takano32 <takano32@gmail.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      make \
      wget \
      jq \
      nginx \
      fcgiwrap \
      squid \
      redis-tools \
      poppler-utils \
      && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY docker/crawler/nginx/vscovid-crawler.conf /etc/nginx/sites-available/vscovid-crawler.conf
RUN ln -s /etc/nginx/sites-available/vscovid-crawler.conf /etc/nginx/sites-enabled/vscovid-crawler.conf

COPY config/squid.conf /etc/squid/squid.conf

WORKDIR /home/ubuntu/vscovid-crawler
COPY . /home/ubuntu/vscovid-crawler

COPY docker-entrypoint.sh /usr/local/sbin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]

COPY docker/crawler/bin/redis-cli /usr/local/sbin/redis-cli
EXPOSE 80
