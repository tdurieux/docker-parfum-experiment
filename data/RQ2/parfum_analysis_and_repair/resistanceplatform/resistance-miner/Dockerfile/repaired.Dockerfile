#
# Dockerfile for cpuminer
# usage: docker run creack/cpuminer --url xxxx --user xxxx --pass xxxx
# ex: docker run creack/cpuminer --url stratum+tcp://ltc.pool.com:80 --user creack.worker1 --pass abcdef
#
#

FROM            ubuntu:14.04
MAINTAINER      Guillaume J. Charmes <guillaume@charmes.net>

RUN apt-get update -qq && \
                apt-get install --no-install-recommends -qqy automake libcurl4-openssl-dev git make && rm -rf /var/lib/apt/lists/*;

RUN             git clone https://github.com/pooler/cpuminer

RUN cd cpuminer && \
                ./autogen.sh && \
                ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CFLAGS='-O2 -fomit-frame-pointer' && \
                make

WORKDIR         /cpuminer
ENTRYPOINT      ["./minerd"]
