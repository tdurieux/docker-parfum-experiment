# DOCKER-VERSION 0.6.1
#
# First run:
#     $ docker build -t redis -rm=true .
#     $ ID=$(docker run -v "path/to/src:/app/src" -v "path/to/socks:/app/socks" -d uwsgi)
#     $ docker wait $ID
#     $ docker logs $ID

FROM       ubuntu:12.04
MAINTAINER Andrey Petrov "andrey.petrov@shazow.net"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y --no-install-recommends install redis-server && rm -rf /var/lib/apt/lists/*;

EXPOSE  6379
VOLUME  ["/var/redis"]
CMD     ["cd /var/redis && /usr/bin/redis-server"]
