ARG BASE=secondstate/soll:ubuntu-base
FROM ${BASE}

RUN apt update \
    && apt install --no-install-recommends -y \
        g++-9 \
        gcovr \
        git && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /
