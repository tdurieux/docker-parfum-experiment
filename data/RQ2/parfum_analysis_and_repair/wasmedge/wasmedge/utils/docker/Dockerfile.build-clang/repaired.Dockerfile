ARG BASE=wasmedge/wasmedge:ubuntu-base
FROM ${BASE}

RUN apt update && apt install --no-install-recommends -y \
	clang-12 && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*

ENV CC=/usr/bin/clang-12
ENV CXX=/usr/bin/clang++-12
