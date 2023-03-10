#------------------------------------------------------------------------------
# Dockerfile for building and testing Solidity Compiler on CI
# Target: Ubuntu 19.04 (Disco Dingo) Clang variant
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
FROM buildpack-deps:disco AS base

ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex; \
	dist=$(grep DISTRIB_CODENAME /etc/lsb-release | cut -d= -f2); \
	echo "deb http://ppa.launchpad.net/ethereum/cpp-build-deps/ubuntu $dist main" >> /etc/apt/sources.list ; \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1c52189c923f6ca9 ; \
	apt-get update; \
	apt-get install -qqy --no-install-recommends \
		build-essential \
		software-properties-common \
		cmake ninja-build \
		clang++-8 llvm-8-dev \
		libjsoncpp-dev \
		libleveldb1d \
		; \
	apt-get install --no-install-recommends -qy python-pip python-sphinx; \
	update-alternatives --install /usr/bin/llvm-symbolizer llvm-symbolizer /usr/bin/llvm-symbolizer-8 1; \
	update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8 1; \
	update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-8 1; \
	pip install --no-cache-dir codecov; \
	rm -rf /var/lib/apt/lists/*

FROM base AS libraries

ENV CC clang
ENV CXX clang++

# Boost
RUN git clone --recursive -b boost-1.69.0 https://github.com/boostorg/boost.git \
    /usr/src/boost; \
    cd /usr/src/boost; \
    ./bootstrap.sh --with-toolset=clang --prefix=/usr; \
    ./b2 toolset=clang headers; \
    ./b2 toolset=clang variant=release \
        system filesystem unit_test_framework program_options \
        install -j $(($(nproc)/2)); \
    rm -rf /usr/src/boost

# Z3
RUN git clone --depth 1 -b z3-4.8.7 https://github.com/Z3Prover/z3.git \
    /usr/src/z3; \
    cd /usr/src/z3; \
    python scripts/mk_make.py --prefix=/usr ; \
    cd build; \
    make -j; \
    make install; \
    rm -rf /usr/src/z3;

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

# EVMONE
RUN set -ex; \
	cd /usr/src; \
	git clone --branch="v0.3.0" --recurse-submodules https://github.com/ethereum/evmone.git; \
	cd evmone; \
	mkdir build; \
	cd build; \
	# isoltest links against the evmone shared library
	cmake -G Ninja -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX="/usr" ..; \
	ninja; \
	ninja install/strip; \
	# abiv2_proto_ossfuzz links against the evmone standalone static library
	cmake -G Ninja -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX="/usr" ..; \
	ninja; \
	ninja install/strip; \
	rm -rf /usr/src/evmone

FROM base
COPY --from=libraries /usr/lib /usr/lib
COPY --from=libraries /usr/bin /usr/bin
COPY --from=libraries /usr/include /usr/include
