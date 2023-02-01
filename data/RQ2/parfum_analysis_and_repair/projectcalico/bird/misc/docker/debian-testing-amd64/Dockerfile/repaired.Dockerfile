FROM debian:testing-slim
ENV DEBIAN_FRONTEND noninteractive
RUN sed -i 's/deb.debian.org/ftp.cz.debian.org/' /etc/apt/sources.list
RUN apt-get -y update && apt-get --no-install-recommends install -y \
	autoconf \
	build-essential \
	flex \
	bison \
	ncurses-dev \
	libreadline-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade







