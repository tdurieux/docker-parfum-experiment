ARG BASE=secondstate/soll:ubuntu-base
FROM ${BASE}

RUN apt update \
    && apt install --no-install-recommends -y \
        lld-10 \
        wabt \
        xxd && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*
