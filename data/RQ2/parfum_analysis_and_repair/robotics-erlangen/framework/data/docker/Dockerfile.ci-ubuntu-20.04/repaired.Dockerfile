FROM ubuntu:20.04

ENV PATH="/usr/lib/ccache:/usr/local/gcc-arm-none-eabi-7-2018-q2-update/bin:$PATH"
ENV CCACHE_DIR="/ccache/ubuntu-20.04"

ARG DEBIAN_FRONTEND=noninteractive
# apt-key will warn to not parse its output if not set
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

RUN set -xe; \
	apt-get update; \
	apt-get install --no-install-recommends -y \
		libprotobuf-dev qtbase5-dev libqt5opengl5-dev libusb-1.0-0-dev libsdl2-dev libqt5svg5-dev \
		cmake g++ protobuf-compiler make ccache patch ninja-build \
		git git-lfs \
		ca-certificates curl gnupg \
		luarocks; \
	git lfs install; \
	# setup nodejs \
	curl -f --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - 2>/dev/null; \
	echo 'deb https://deb.nodesource.com/node_12.x focal main' > /etc/apt/sources.list.d/nodesource.list; \
	echo 'deb-src https://deb.nodesource.com/node_12.x focal main' >> /etc/apt/sources.list.d/nodesource.list; \
	apt-get update; \
	apt-get install -y --no-install-recommends nodejs; \
	# setup linters \
	npm install -g tslint@6.1.1 typescript@3.8.3; npm cache clean --force; \
	luarocks install luacheck; \
	# cleanup apt \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \
	# setup arm gcc \
	wget --no-verbose --output-document=gcc-arm.tbz2 https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2; \
	echo " 299ebd3f1c2c90930d28ab82e5d8d6c0 gcc-arm.tbz2" > arm.md5; \
	md5sum -c arm.md5; \
	tar -xf gcc-arm.tbz2 -C /usr/local ; \
	rm gcc-arm.tbz2 arm.md5 ; \
	# ccache seems to not automatically cover cc/c++ and arm compilers
	ln -s ../../bin/ccache /usr/lib/ccache/cc; \
	ln -s ../../bin/ccache /usr/lib/ccache/c++; \
	ln -s ../../bin/ccache /usr/lib/ccache/arm-none-eabi-gcc; \
	ln -s ../../bin/ccache /usr/lib/ccache/arm-none-eabi-g++;

ENV V8_INCLUDE_DIR=/libs/v8/include
ENV V8_OUTPUT_DIR=/libs/v8/out/x64.release
COPY --from=roboticserlangen/v8:version-1-ubuntu-20.04 /v8/v8 /libs/v8
