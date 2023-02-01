FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive
RUN sed -i 's/deb.debian.org/ftp.cz.debian.org/' /etc/apt/sources.list
RUN apt-get -y update && apt-get -y --no-install-recommends install \
	autoconf \
	build-essential \
	flex \
	bison \
	ncurses-dev \
	libreadline-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade







