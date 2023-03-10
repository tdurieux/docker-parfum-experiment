FROM debian:buster-slim

LABEL maintainer "alxchk@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN \
	echo 'deb http://ftp.debian.org/debian buster-backports main' >> \
		/etc/apt/sources.list && \
	apt-get update --fix-missing && \
	mkdir -p /usr/share/man/man1/ && \
	apt-get install -t buster-backports --no-install-recommends -y \
	libssl-dev libffi-dev python-dev python-pip swig \
	unzip libtool locales ncurses-term tcpdump \
	netbase fuse build-essential cython && apt-get clean && \
	rm -rf /var/lib/apt/lists/* /usr/share/doc* /usr/share/man/* /usr/share/info/* && \
	echo 'en_US.UTF-8 UTF-8' >/etc/locale.gen && \
	locale-gen && echo 'LC_ALL=en_US.UTF-8' >/etc/default/locale

RUN \
	mkdir -p /project && \
	mkdir -p /pupy && \
	mkdir -p /build

COPY requirements.txt /build/

RUN \
	python -m pip install --no-cache-dir --upgrade pip six setuptools wheel && \
		cd /build && \
			python -m pip install --no-cache-dir --upgrade -r requirements.txt

RUN \
	apt-get remove -y \
		autoconf automake libssl1.0-dev libffi-dev python-dev \
		libtool build-essential && apt-get -y autoremove && \
		rm -rf /root/.cache /build

ADD \
	https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20210810-2/mimikatz_trunk.zip \
		/opt/mimikatz

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENTRYPOINT [ "python", "-OB", "/pupy/pupysh.py", "--workdir", "/project" ]