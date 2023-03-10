#------------------------------------------------------------------------------
# Dockerfile for building and testing Solidity Compiler on CI
# Target: Ubuntu 18.04 (Bionic Beaver)
# URL: https://hub.docker.com/r/ethereum/solidity-buildpack-deps
#
# This file is part of solidity.
#
# solidity is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# solidity is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with solidity.  If not, see <http://www.gnu.org/licenses/>
#
# (c) 2016-2019 solidity contributors.
#------------------------------------------------------------------------------
FROM buildpack-deps:bionic AS base

ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex; \
	dist=$(grep DISTRIB_CODENAME /etc/lsb-release | cut -d= -f2); \
	echo "deb http://ppa.launchpad.net/ethereum/cpp-build-deps/ubuntu $dist main" >> /etc/apt/sources.list ; \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1c52189c923f6ca9 ; \
	apt-get update; \
	apt-get install -qqy --no-install-recommends \
		build-essential \
		software-properties-common \
		cmake ninja-build clang++-8 \
		libboost-filesystem-dev libboost-test-dev libboost-system-dev \
		libboost-program-options-dev \
		libjsoncpp-dev \
		llvm-8-dev libz3-static-dev \
		; \
	apt-get install --no-install-recommends -qy python-pip python-sphinx; \
	update-alternatives --install /usr/bin/llvm-symbolizer llvm-symbolizer /usr/bin/llvm-symbolizer-8 1; \
	pip install --no-cache-dir codecov; \
	rm -rf /var/lib/apt/lists/*

FROM base AS libraries

# OSSFUZZ: libprotobuf-mutator
RUN set -ex; \
	git clone https://github.com/google/libprotobuf-mutator.git \
	    /usr/src/libprotobuf-mutator; \
	cd /usr/src/libprotobuf-mutator; \
	git checkout d1fe8a7d8ae18f3d454f055eba5213c291986f21; \
	mkdir build; \
	cd build; \
	cmake .. -GNinja -DLIB_PROTO_MUTATOR_DOWNLOAD_PROTOBUF=ON \
        -DLIB_PROTO_MUTATOR_TESTING=OFF -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="/usr"; \
	ninja; \
	cp -vpr external.protobuf/bin/* /usr/bin/; \
	cp -vpr external.protobuf/include/* /usr/include/; \
	cp -vpr external.protobuf/lib/* /usr/lib/; \
	ninja install/strip; \
	rm -rf /usr/src/libprotobuf-mutator

# OSSFUZZ: libfuzzer
RUN set -ex; \
	cd /var/tmp; \
	svn co https://llvm.org/svn/llvm-project/compiler-rt/trunk/lib/fuzzer libfuzzer; \
	mkdir -p build-libfuzzer; \
	cd build-libfuzzer; \
	clang++-8 -O1 -stdlib=libstdc++ -std=c++11 -O2 -fPIC -c ../libfuzzer/*.cpp -I../libfuzzer; \
	ar r /usr/lib/libFuzzingEngine.a *.o; \
	rm -rf /var/lib/libfuzzer

# EVMONE
ARG EVMONE_HASH="fa4f40daf7cf9ccbcca6c78345977e084ea2136a8eae661e4d19471be852b15b"
ARG EVMONE_MAJOR="0"
ARG EVMONE_MINOR="3"
ARG EVMONE_MICRO="0"
RUN set -ex; \
	EVMONE_VERSION="$EVMONE_MAJOR.$EVMONE_MINOR.$EVMONE_MICRO"; \
	TGZFILE="evmone-$EVMONE_VERSION-linux-x86_64.tar.gz"; \
	wget https://github.com/ethereum/evmone/releases/download/v$EVMONE_VERSION/$TGZFILE; \
	sha256sum $TGZFILE; \
	tar xzpf $TGZFILE -C /usr; \
	rm -f $TGZFILE;

FROM base
COPY --from=libraries /usr/lib /usr/lib
COPY --from=libraries /usr/bin /usr/bin
COPY --from=libraries /usr/include /usr/include
