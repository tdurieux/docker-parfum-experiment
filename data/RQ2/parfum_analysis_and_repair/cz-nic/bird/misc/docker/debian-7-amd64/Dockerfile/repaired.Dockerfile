FROM debian:wheezy-slim
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'deb http://archive.debian.org/debian/ wheezy main' > /etc/apt/sources.list
RUN echo 'deb http://archive.debian.org/debian-security/ wheezy/updates main' >> /etc/apt/sources.list
RUN apt-get -y update -o Acquire::Check-Valid-Until=false && apt-get -y --no-install-recommends install \
	autoconf \
	build-essential \
	flex \
	bison \
	ncurses-dev \
	libreadline-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade







