# -*- sh -*-

FROM ubuntu:12.04

RUN apt-get -qy --no-install-recommends install python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository -y ppa:rwky/redis
RUN apt-get -qy update
RUN apt-get -qy --no-install-recommends install redis-server && rm -rf /var/lib/apt/lists/*;

EXPOSE 6379
CMD /usr/bin/redis-server
