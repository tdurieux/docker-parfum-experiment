#
# Dockerfile for cpuminer
# usage: docker run creack/cpuminer --url xxxx --user xxxx --pass xxxx
# ex: docker run creack/cpuminer --url stratum+tcp://ltc.pool.com:80 --user creack.worker1 --pass abcdef
#
#

FROM		ubuntu:12.10
MAINTAINER	Guillaume J. Charmes <guillaume@charmes.net>

RUN		apt-get update -qq

RUN apt-get install --no-install-recommends -qqy automake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qqy libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qqy git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qqy make && rm -rf /var/lib/apt/lists/*;

RUN		git clone https://github.com/pooler/cpuminer

RUN		cd cpuminer && ./autogen.sh
RUN cd cpuminer && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CFLAGS="-O3"
RUN		cd cpuminer && make

WORKDIR		/cpuminer
ENTRYPOINT	["./minerd"]
