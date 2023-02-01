ARG base_image=debian:buster

FROM ${base_image}
LABEL maintainer="Mario Konrad <mario.konrad@gmx.net>"

ARG compiler_version=13.0.0
ARG cmake_version=3.22.0
ARG boost_version=1.72.0

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
		apt-utils \
		wget curl \
		bzip2 xz-utils \
		tar \
		binutils \
		make ninja-build \
		git-core \
		libc-dev libgcc1 libgcc-7-dev \
		libtinfo5 \
 && rm -fr /var/lib/apt/lists/*
RUN mkdir -p /opt

# install clang
COPY install-clang.sh /tmp/
RUN /tmp/install-clang.sh "${compiler_version}"
ENV CXX=/usr/bin/clang++
ENV CC=/usr/bin/clang
ENV CXXFLAGS=-stdlib=libc++
ENV LDFLAGS=-stdlib=libc++
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-unknown-linux-gnu

# install cmake
COPY install-cmake.sh /tmp/
RUN /tmp/install-cmake.sh "${cmake_version}"
ENV PATH /opt/local/cmake/bin:$PATH

# install boost
COPY install-boost.sh /tmp/
RUN /tmp/install-boost.sh "${boost_version}" "clang" "-stdlib=libc++" "-stdlib=libc++"
ENV BOOST_ROOT=/opt/local

# add user
RUN useradd --groups users -M --uid 1000 user
USER user
