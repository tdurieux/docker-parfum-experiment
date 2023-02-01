ARG BASE=secondstate/soll:ubuntu-base
FROM ${BASE}

RUN apt update \
    && apt install --no-install-recommends -y \
        g++-9 && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

ENV CXX=g++-9
