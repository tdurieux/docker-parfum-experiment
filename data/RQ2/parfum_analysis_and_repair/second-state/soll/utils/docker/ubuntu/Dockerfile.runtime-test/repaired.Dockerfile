ARG BASE=secondstate/soll:ubuntu-base
FROM ${BASE}

RUN apt update && apt install --no-install-recommends -y \
	llvm-dev \
	liblld-10-dev \
	git \
	libboost-all-dev && rm -rf /var/lib/apt/lists/*;

RUN apt update && apt install --no-install-recommends -y \
	gcc \
	g++ && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*

ENV CC=gcc
ENV CXX=g++
