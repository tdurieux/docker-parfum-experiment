#upstream:  https://github.com/pierky/dockerfiles
FROM debian:stable

MAINTAINER 若虚 <slpcat@qq.com>

EXPOSE 179

RUN apt-get update && apt-get install --no-install-recommends -y \
        autoconf \
	bison \
	build-essential \
	curl \
	flex \
	libreadline-dev \
	libncurses5-dev \
	libssh-dev \
	m4 \
	unzip && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
RUN curl -f -O -L ftp://bird.network.cz/pub/bird/bird-2.0.7.tar.gz
RUN tar -zxvf bird-2.0.7.tar.gz && rm bird-2.0.7.tar.gz

# This directory must be mounted as a local volume with '-v `pwd`/bird:/etc/bird:rw' docker's command line option.
# The host's file at `pwd`/bird/bird.conf is used as the configuration file for BIRD.
RUN mkdir /etc/bird

RUN cd bird-2.0.7 && \
	autoconf && \
	autoheader && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-libssh && \
	make && \
	make install

CMD bird -c /etc/bird/bird.conf -d
