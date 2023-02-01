FROM ubuntu:18.04

ENV PATH="/usr/lib/ccache:/usr/local/gcc-arm-none-eabi-7-2018-q2-update/bin:$PATH"
ENV CCACHE_DIR="/ccache/ubuntu-18.04-no-v8"

ARG DEBIAN_FRONTEND=noninteractive
# apt-key will warn to not parse its output if not set
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

# unzip is required for luarocks
RUN set -xe; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
		protobuf-compiler libprotobuf-dev qtbase5-dev libqt5opengl5-dev libsdl2-dev libusb-1.0-0-dev \
		cmake ninja-build ccache g++ python3 \
		luarocks unzip \
		ca-certificates curl apt-transport-https gnupg \
		git git-lfs; \
	git lfs install; \
	# Setup NodeJS \
	curl -f -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -; \
	echo 'deb https://deb.nodesource.com/node_12.x bionic main' > /etc/apt/sources.list.d/nodesource.list; \
	echo 'deb-src https://deb.nodesource.com/node_12.x bionic main' >> /etc/apt/sources.list.d/nodesource.list; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nodejs; \
	# Cleanup APT \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/* ; \
	# Setup linters \
	luarocks install luacheck; \
	npm install -g tslint@6.1.1 typescript@3.8.3; npm cache clean --force; \
	# Setup ARM GCC \
	wget -q https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2 -O gcc-arm.tbz2; \
	echo 299ebd3f1c2c90930d28ab82e5d8d6c0 gcc-arm.tbz2 > arm.md5; \
	md5sum -c arm.md5; \
	tar -xf gcc-arm.tbz2 -C /usr/local ; \
	rm gcc-arm.tbz2 arm.md5; \
	# ccache seems to not automatically cover cc/c++ and arm compilers \
	ln -s ../../bin/ccache /usr/lib/ccache/cc ; \
	ln -s ../../bin/ccache /usr/lib/ccache/c++ ; \
	ln -s ../../bin/ccache /usr/lib/ccache/arm-none-eabi-gcc ; \
	ln -s ../../bin/ccache /usr/lib/ccache/arm-none-eabi-g++ ;
