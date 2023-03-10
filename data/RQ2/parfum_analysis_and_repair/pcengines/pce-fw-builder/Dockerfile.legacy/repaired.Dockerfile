FROM ubuntu:14.04
MAINTAINER Piotr Król <piotr.krol@3mdeb.com>

RUN \
	useradd -p locked -m coreboot && \
	apt-get -qq update && \
	apt-get -qqy --no-install-recommends install \
	iasl \
	curl \
	git \
	python \
	m4 \
	flex \
	bison \
	gdb \
	doxygen \
	ncurses-dev \
	cmake \
	make \
	g++ \
	gcc-multilib \
	wget \
	liblzma-dev \
	zlib1g-dev \
	&& \
	apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN \
	cd /root && \
	git clone https://github.com/pcengines/coreboot.git && \
	cd coreboot && \
	git checkout pce-fw-builder-legacy && \
	make crossgcc-i386 CPUS=$(nproc) && \
	cd /root && \
	rm -rf coreboot

RUN mkdir /home/coreboot/.ccache && \
	chown coreboot:coreboot /home/coreboot/.ccache && \
	echo "export PATH=$PATH:/opt/xgcc/bin" >> /home/coreboot/.bashrc

VOLUME /home/coreboot/.ccache

ENV PATH $PATH:/opt/xgcc/bin
USER coreboot
