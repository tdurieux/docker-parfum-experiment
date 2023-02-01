ARG BASE=secondstate/soll:ubuntu-base
FROM ${BASE}

RUN apt update \
    && apt install --no-install-recommends -y \
        clang-10 && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*

ENV CXX=clang++-10
