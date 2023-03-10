FROM ubuntu:18.04
MAINTAINER lynix94

# ubuntu archive report hash sum mismatch today. :(
RUN rm -rf /etc/apt/sources.list
RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt bionic main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src mirror://mirrors.ubuntu.com/mirrors.txt bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt bionic-security main restricted universe multiverse" >> /etc/apt/sources.list


RUN apt -y update; \
	apt install --no-install-recommends -y git; rm -rf /var/lib/apt/lists/*; \
	apt install --no-install-recommends -y gcc g++ make autoconf automake git; \
	apt install --no-install-recommends -y iputils-ping net-tools telnet vim; \
	apt install --no-install-recommends -y libtool flex bison \
		libboost-all-dev libreadline-dev libgmp-dev \
		libgtk2.0-dev libsqlite3-dev libleveldb-dev \
		libcanberra-gtk-module libssl-dev

