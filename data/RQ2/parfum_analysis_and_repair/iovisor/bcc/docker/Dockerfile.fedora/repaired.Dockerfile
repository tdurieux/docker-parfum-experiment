# Copyright (c) PLUMgrid, Inc.
# Licensed under the Apache License, Version 2.0 (the "License")

FROM fedora:34

MAINTAINER Dave Marchevsky <davemarchevsky@fb.com>

RUN dnf -y install \
	bison \
	cmake \
	flex \
	gcc \
	gcc-c++ \
	git \
	libxml2-devel \
	make \
	rpm-build \
	wget \
	zlib-devel \
	llvm \
	llvm-devel \
	clang-devel \
	elfutils-debuginfod-client-devel \
#	elfutils-libelf-devel-static \
	elfutils-libelf-devel \
	luajit \
	luajit-devel \
	python3-devel \
	libstdc++ \
	libstdc++-devel

RUN dnf -y install \
	python3 \
	python3-pip

RUN if [[ ! -e /usr/bin/python && -e /usr/bin/python3 ]]; then \
        ln -s $(readlink /usr/bin/python3) /usr/bin/python; \
    fi

RUN dnf -y install \
	procps \
	iputils \
	net-tools \
	hostname \
	iproute \
	bpftool

RUN pip3 install --no-cache-dir pyroute2==0.5.18 netaddr==0.8.0 dnslib==0.9.14 cachetools==3.1.1
